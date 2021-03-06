#!/bin/bash

###########
# PRIVATE #
###########

_check_requirements () {
    _STATUS=0
    while read _LINE || [ -n "$_LINE" ]
        do dpkg -l | grep $_LINE > /dev/null || ( echo "You must install $_LINE in order to procede." && _STATUS=1 )
    done < ./requirements.sh.txt
    while read _LINE || [ -n "$_LINE" ]
        do pip freeze $_LINE > /dev/null || ( echo "You must install $_LINE in order to procede." && _STATUS=1 )
    done < ./requirements.py.txt    
    return $_STATUS
}

_log () {
    local _RESULT="$1"
    local _LOGFILE="./cloud/aws/logs/${_DATETIME}.log"
    if [ $( echo ${_RESULT} | jq '.' | wc -c ) -eq 0 ]; then echo "$_RESULT"; return; fi
    _DATETIME=$( date +'%Y-%m-%d_%H-%M-%S' )
    echo "${_RESULT}" > $_LOGFILE
    cat $_LOGFILE | jq '.'
}

##########
# PUBLIC #
##########

_cloud_aws_instance_describe () {
    local _DATETIME="$1"
    _INSTANCE_ID=$( cat ./cloud/aws/logs/* | jq -s '.' | tail -1 | jq '.InstanceId' )
    if [ "$_INSTANCE_ID" = 'null' ]; then
        echo '{"status":"error","message":"No instance ID on record. You must query AWS to find the the ID"}'; exit
    fi
    aws ec2 describe-instances --instance-ids $_INSTANCE_ID |
        jq '.Reservations[0].Instances[0] | { ImageId: .ImageId, InstanceId: .InstanceId, InstanceType: .InstanceType, KeyName: .KeyName, LaunchTime: .LaunchTime, AvailabilityZone: .Placement.AvailabilityZone, PrivateIpAddress: .PrivateIpAddress, PublicIpAddress: .PublicIpAddress, SubnetId: .SubnetId, VpcId: .VpcId, SecurityGroups: .SecurityGroups, Tags: .Tags }' |
        tee -a ../cloud/aws/logs/${_DATETIME}.log
}

_cloud_aws_instance_run () {
    local _DATETIME="$1"
    local _JSON='./cloud/aws/conf/specs.json'
    local _USER_DATA='./cloud/aws/conf/userdata.sh'
    _RESULT=$( aws ec2 run-instances --cli-input-json file://${_JSON} --user-data file://${_USER_DATA} )
}

_cloud_aws_logs_show () {
    if [ $( ls -1 ./logs | wc -l ) -eq 0 ]; then exit 0; fi
    cat ./cloud/aws/logs/* | jq -s '.'
}

_cloud_aws_parse_specs () {
    python ./templater.py
    sed -i 's/False/false/g; s/True/true/g' ./cloud/aws/conf/specs.json
}

#######
# RUN #
#######

_check_requirements || exit 1

_DATETIME=$( date +'%Y-%m-%d_%H-%M-%S' )

_COMM="$1"
if [ $_COMM = '_logs_show' ]; then $_COMM; exit; fi
shift
_ARGS="$@"

$_COMM "$_DATETIME" "$_ARGS"
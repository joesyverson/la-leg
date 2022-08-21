#!/bin/bash

# function to recover passwords from secret file -- not included in this repository
source ${HOME}/.bashrc.sh &> /dev/null
expose-ll

export AWS_ACCESS_KEY_ID="$_LL_AWS_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$_LL_AWS_SECRET_ACCESS_KEY"
export AWS_DEFAULT_REGION="$_LL_AWS_DEFAULT_REGION"
export AWS_DEFAULT_OUTPUT="$_LL_AWS_DEFAULT_OUTPUT"

###########
# PRIVATE #
###########

_log () {
    local _RESULT="$1"
    local _LOGFILE="./aws/logs/${_DATETIME}.log"
    if [ $( echo ${_RESULT} | jq '.' | wc -c ) -eq 0 ]; then echo "$_RESULT"; return; fi
    echo "${_RESULT}" > $_LOGFILE
    cat $_LOGFILE | jq '.'
}

##########
# PUBLIC #
##########

_aws_instance_describe () {
    _INSTANCE_ID=$( cat ./aws/logs/* | jq -s '.' | tail -1 | jq '.InstanceId' )
    if [ "$_INSTANCE_ID" = 'null' ]; then
        echo '{"status":"error","message":"No instance ID on record. You must query AWS to find the the ID"}'; exit
    fi
    aws ec2 describe-instances --instance-ids $_INSTANCE_ID |
        jq '.Reservations[0].Instances[0] | { ImageId: .ImageId, InstanceId: .InstanceId, InstanceType: .InstanceType, KeyName: .KeyName, LaunchTime: .LaunchTime, AvailabilityZone: .Placement.AvailabilityZone, PrivateIpAddress: .PrivateIpAddress, PublicIpAddress: .PublicIpAddress, SubnetId: .SubnetId, VpcId: .VpcId, SecurityGroups: .SecurityGroups, Tags: .Tags }' |
        tee -a ./aws/logs/${_DATETIME}.log
        # tee -a ../aws/logs/${_DATETIME}.log
}

_aws_instance_run () {
    local _JSON='./aws/conf/specs.json'
    local _USER_DATA='./aws/conf/userdata.sh'
    _RESULT=$( aws ec2 run-instances --cli-input-json file://${_JSON} --user-data file://${_USER_DATA} )
}

_aws_logs_show () {
    if [ $( ls -1 ./logs | wc -l ) -eq 0 ]; then exit 0; fi
    cat ./aws/logs/* | jq -s '.'
}

_aws_parse_specs () {
    python ./templater.py
    sed -i 's/False/false/g; s/True/true/g' ./aws/conf/specs.json
}

_aws_regions_list () {
    aws ec2 describe-regions --all-regions
}

_aws_resource_types_get () {
    local _LIST_DIR='./aws/resource-type-lists'
    local _LAST_LIST=$( ls -tr $_LIST_DIR | tail -1)
    local _RESOURCE_TYPES=$( curl -s https://docs.aws.amazon.com/config/latest/developerguide/resource-config-reference.html |
        grep -o 'AWS::.*::.*' |
        sed 's/ *//g; s/<.*//g')
    
    if [ "$?" -ne 0 ]; then
        echo "Request failed. Cannot generate new resource list. Use old list at ${_LAST_LIST}"
        echo "Exiting..."
    fi

    local _NEW_LIST="./aws/resource-type-lists/${_DATETIME}.lst"
    echo "$_RESOURCE_TYPES" > $_NEW_LIST
    cat "$_NEW_LIST"
    echo -e "\nMake sure the above lists resources in the format 'AWS::SERVICE::RESOURCE'."
    echo "If not, use an old list or update this command!"
}

_aws_resource_types_list () {
    local _LIST_DIR='./aws/resource-type-lists'
    local _LAST_LIST=$( ls -tr $_LIST_DIR | tail -1)
    cat ${_LIST_DIR}/${_LAST_LIST} # | jq -R '.' | jq -s '.'
}


_aws_resources_list () {
    local _REGION="$1"
    local _RESOURCE_TYPE="$2"
    if [ -z "$_REGION" ]; then _REGION="$AWS_DEFAULT_REGION"; fi

    if [ _RESOURCE_TYPE = 'all' ]; then
        _RESOURCE_TYPES=$( _aws_resource_types_list 'false' )
        for _RESOURCE_TYPE in $_RESOURCE_TYPES; do
            aws configservice list-discovered-resources --resource-type $_RESOURCE_TYPE --region $_REGION | jq '.resourceIdentifiers'
            sleep .1
        done
    else
        aws configservice list-discovered-resources --resource-type $_RESOURCE_TYPE --region $_REGION | jq '.resourceIdentifiers'
    fi
}
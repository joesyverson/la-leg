#!/bin/bash



###########
# PRIVATE #
###########

_docker () {
    command podman "$@"
}

_docker_compose () {
    command podman-compose "$@"
}

_check_system_requirements () {
    _STATUS=0
    # Depends on using dpkg and apt! 
    while read _LINE || [ -n "$_LINE" ]
        do which "$_LINE" > /dev/null || ( echo "You must install $_LINE in order to procede." && exit 1 )
    done < ./requirements.sh.txt
    _STATUS="$?"
    test $_STATUS = 0 || return $_STATUS
}

_check_python_requirements () {
    _STATUS=0
    while read _LINE || [ -n "$_LINE" ]
        do pip freeze | grep $_LINE > /dev/null || ( echo "You must install $_LINE in order to procede." && exit 1 )
    done < ./requirements.py.txt
    _STATUS="$?"
    test $_STATUS = 0 || return $_STATUS
}

_check_requirements () {
    _check_system_requirements || return 1
    _check_python_requirements || return 1
    return 0
}

_cloud_aws_env () {
    # function to recover passwords from secret file -- not included in this repository
    source ${HOME}/.bashrc.sh &> /dev/null
    expose-ll

    export AWS_ACCESS_KEY_ID="$_LL_AWS_ACCESS_KEY_ID"
    export AWS_SECRET_ACCESS_KEY="$_LL_AWS_SECRET_ACCESS_KEY"
    export AWS_DEFAULT_REGION="$_LL_AWS_DEFAULT_REGION"
    export AWS_DEFAULT_OUTPUT="$_LL_AWS_DEFAULT_OUTPUT"
}

_log () {
    local _RESULT="$1"
    local _LOGFILE="./cloud/aws/logs/${_DATETIME}.log"
    if [ $( echo ${_RESULT} | jq '.' | wc -c ) -eq 0 ]; then echo "$_RESULT"; return; fi
    echo "${_RESULT}" > $_LOGFILE
    cat $_LOGFILE | jq '.'
}

##########
# PUBLIC #
##########

_cloud_aws_instance_describe () {
    _cloud_aws_env
    _INSTANCE_ID=$( cat ./cloud/aws/logs/* | jq -s '.' | tail -1 | jq '.InstanceId' )
    if [ "$_INSTANCE_ID" = 'null' ]; then
        echo '{"status":"error","message":"No instance ID on record. You must query AWS to find the the ID"}'; exit
    fi
    aws ec2 describe-instances --instance-ids $_INSTANCE_ID |
        jq '.Reservations[0].Instances[0] | { ImageId: .ImageId, InstanceId: .InstanceId, InstanceType: .InstanceType, KeyName: .KeyName, LaunchTime: .LaunchTime, AvailabilityZone: .Placement.AvailabilityZone, PrivateIpAddress: .PrivateIpAddress, PublicIpAddress: .PublicIpAddress, SubnetId: .SubnetId, VpcId: .VpcId, SecurityGroups: .SecurityGroups, Tags: .Tags }' |
        tee -a ../cloud/aws/logs/${_DATETIME}.log
}

_cloud_aws_instance_run () {
    _cloud_aws_env
    local _JSON='./cloud/aws/conf/specs.json'
    local _USER_DATA='./cloud/aws/conf/userdata.sh'
    _RESULT=$( aws ec2 run-instances --cli-input-json file://${_JSON} --user-data file://${_USER_DATA} )
}

_cloud_aws_logs_show () {
    _cloud_aws_env
    if [ $( ls -1 ./logs | wc -l ) -eq 0 ]; then exit 0; fi
    cat ./cloud/aws/logs/* | jq -s '.'
}

_cloud_aws_parse_specs () {
    _cloud_aws_env
    python ./templater.py
    sed -i 's/False/false/g; s/True/true/g' ./cloud/aws/conf/specs.json
}

_cloud_aws_regions_list () {
    _cloud_aws_env
    aws ec2 describe-regions --all-regions
}

_cloud_aws_resource_types_list () {
    echo hit
    local _MAKE_NEW_LIST="$1"
    local _LIST_DIR='./cloud/aws/resource-type-lists'
    local _LAST_LIST=$( ls -tr $_LIST_DIR | tail -1)
    if $_MAKE_NEW_LIST; then
        local _RESOURCE_TYPES=$( curl -s https://docs.aws.amazon.com/config/latest/developerguide/resource-config-reference.html |
            grep -o 'AWS::.*::.*' |
            sed 's/ *//g; s/<.*//g')
        
        if [ "$?" -ne 0 ]; then
            echo "Request failed. Cannot generate new resource list. Use old list at ${_LAST_LIST}"
            echo "Exiting..."
        fi

        local _NEW_LIST="./cloud/aws/resource-type-lists/${_DATETIME}.lst"
        echo "$_RESOURCE_TYPES" > $_NEW_LIST
        cat "$_NEW_LIST"
        echo -e "\nMake sure the above lists resources in the format 'AWS::SERVICE::RESOURCE'."
        echo "If not, use an old list or update this command!"
    else
        cat ${_LIST_DIR}/${_LAST_LIST} # | jq -R '.' | jq -s '.'
    fi
}

_cloud_aws_resources_list () {
    _cloud_aws_env
    local _REGION="$1"
    local _RESOURCE_TYPE="$2"
    if [ -z "$_REGION" ]; then _REGION="$AWS_DEFAULT_REGION"; fi

    if [ _RESOURCE_TYPE = 'all' ]; then
        _RESOURCE_TYPES=$( _cloud_aws_resource_types_list 'false' )
        for _RESOURCE_TYPE in $_RESOURCE_TYPES; do
            aws configservice list-discovered-resources --resource-type $_RESOURCE_TYPE --region $_REGION | jq '.resourceIdentifiers'
            sleep .1
        done
    else
        aws configservice list-discovered-resources --resource-type $_RESOURCE_TYPE --region $_REGION | jq '.resourceIdentifiers'
    fi
}

_container_db_logs () {
    _docker logs db-ll
}
_container_db_shell () {
    _docker exec -it db-ll bash
}

_container_wp_logs () {
    _docker logs wp-ll
}

_container_wp_shell () {
    _docker exec -it wp-ll bash
}

_containers_down () {
    _docker_compose down
}

_containers_stop () {
    _docker_compose stop
}

_containers_up () {
    _docker_compose up -d
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

$_COMM "$_ARGS"

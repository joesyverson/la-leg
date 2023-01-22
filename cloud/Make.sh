#!/bin/bash

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



#######
# RUN #
#######

_DATETIME=$( date +'%Y-%m-%d_%H-%M-%S' )

_COMM="$1"
shift
_ARGS="$@"

$_COMM "$_ARGS"

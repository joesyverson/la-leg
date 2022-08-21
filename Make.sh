#!/bin/bash


###########
# PRIVATE #
###########

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


#######
# RUN #
#######

_check_requirements || exit 1


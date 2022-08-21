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

##########
# PUBLIC #
##########

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

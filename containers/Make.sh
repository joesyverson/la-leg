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
    _docker_compose -f ./wordpress/docker-compose.yml down
}

_containers_stop () {
    _docker_compose -f ./wordpress/docker-compose.yml stop
}

_containers_up () {
    _docker_compose -f ./wordpress/docker-compose.yml up -d
}

#######
# RUN #
#######

_DATETIME=$( date +'%Y-%m-%d_%H-%M-%S' )

_COMM="$1"
shift
_ARGS="$@"

$_COMM "$_ARGS"

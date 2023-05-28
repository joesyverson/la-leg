#!/bin/bash
source ./.env

###########
# PRIVATE #
###########

# invoke this instead if you want to use podman
_docker () {
    command podman "$@"
}

# invoke this instead if you want to use podman-compose
_docker_compose () {
    command podman-compose "$@"
}

_container_name () {
    local _TAG=$( echo "${1}" | cut -d ' ' -f 1 )
    local _TARGET=$( echo "${1}" | cut -d ' ' -f 2 )
    local _CONTAINER="laleg-${_TARGET}-${_TAG}"

    echo "$_CONTAINER"
}

_image_name () {
    local _TAG=$( echo "${1}" | cut -d ' ' -f 1 )
    local _TARGET=$( echo "${1}" | cut -d ' ' -f 2 )
    local _IMAGE="laleg:${_TARGET}-${_TAG}"

    echo "$_IMAGE"
}

##########
# PUBLIC #
##########

_nginx_build () {
    local _IMAGE=$( _image_name "$@" )
    local _TARGET=$( echo "${1}" | cut -d ' ' -f 2 )
    # local _BUILD_ARGS=""
    # for _VAR in $( cat ./.env ); do _BUILD_ARGS="${_BUILD_ARGS} --build-arg '${_VAR}' "; done
    # echo docker build --target "$_TARGET"   -t "$_CONTAINER" "$_BUILD_ARGS" .
    pushd ./nginx
    docker build --target "$_TARGET" -t "$_IMAGE" \
        --build-arg "_CONTAINER_NGINX_DEV_IMAGE=${_CONTAINER_NGINX_DEV_IMAGE}" \
        --build-arg "_CONTAINER_NGINX_DEV_IMAGE_TAG=${_CONTAINER_NGINX_DEV_IMAGE_TAG}" \
        --build-arg "_CONTAINER_NGINX_PROD_IMAGE=${_CONTAINER_NGINX_PROD_IMAGE}" \
        --build-arg "_CONTAINER_NGINX_PROD_IMAGE_TAG=${_CONTAINER_NGINX_PROD_IMAGE_TAG}" .

    popd
}

_nginx_images () {
    docker images --filter=reference="laleg*:*"
}

_nginx_logs () {
    local _CONTAINER=$( _container_name "$@" )
    docker logs -f "$_CONTAINER"
}

_nginx_remove () {
    local _CONTAINER=$( _container_name "$@" )
    docker rm "$_CONTAINER"
}

_nginx_rmi () {
    local _IMAGE=$( _image_name "$@" )

    read -p \
        "Are you sure you want to delete image '${_IMAGE}' from local stores? [n/Y] " _ANSWER
    
    case $_ANSWER in
        'n' ) echo "Skipping deletion of image '${_IMAGE}'";;
        'Y' ) echo "Deleting image '${_IMAGE}'."; docker rmi "${_IMAGE}";;
        * ) echo "Please answer 'n' for 'no' 'Y' for 'yes'. Skipping...'";;
    esac
}

_nginx_run () {
    local _IMAGE=$( _image_name "$@" )
    local _CONTAINER=$( _container_name "$@" )
    # docker run -dit --name "$_CONTAINER" -p 80:80 -p 443:443 "$_IMAGE"
    docker run -dit --name "$_CONTAINER" \
        --volume ${PWD}/nginx/etc/nginx/etc/nginx/nginx.conf:/etc/nginx/etc/nginx/nginx.conf \
        --volume ${PWD}/nginx/etc/nginx/etc/nginx/sites-available/:/etc/nginx/etc/nginx/sites-available/ \
        --volume ${PWD}/nginx/var/www/html/:/var/www/html/ \
        -p 80:80 -p 443:443 "$_IMAGE"
}

_nginx_shell () {
    local _CONTAINER=$( _container_name "$@" )
    docker exec -it "$_CONTAINER" bash
}

_nginx_start () {
    local _CONTAINER=$( _container_name "$@" )
    docker start "$_CONTAINER"
}

_nginx_stop () {
    local _CONTAINER=$( _container_name "$@" )
    docker stop "$_CONTAINER"
}

# _wp_db_logs () {
#     _docker logs db-ll
# }
# _wp_db_shell () {
#     _docker exec -it db-ll bash
# }

# _wp_down () {
#     _docker_compose -f ./wordpress/docker-compose.yml down
# }

# _wp_stop () {
#     _docker_compose -f ./wordpress/docker-compose.yml stop
# }

# _wp_up () {
#     _docker_compose -f ./wordpress/docker-compose.yml up -d
# }

#######
# RUN #
#######

_DATETIME=$( date +'%Y-%m-%d_%H-%M-%S' )

_COMM="$1"
shift
_ARGS="$@"

$_COMM "$_ARGS"

#!/bin/bash
source ./.env

###########
# PRIVATE #
###########

_check_system_requirements () {
    _STATUS=0
    # Depends on using dpkg and apt! 
    while read _LINE || [ -n "$_LINE" ]; do
        which "$_LINE" > /dev/null || ( echo "You must install $_LINE in order to procede." && return 1 )
        _STATUS="$?"
        test $_STATUS -eq 0 || return $_STATUS
    done < ./requirements.sh.txt
}

_check_python_requirements () {
    _STATUS=0
    while read _LINE || [ -n "$_LINE" ]; do
        pip freeze | grep $_LINE > /dev/null || ( echo "You must install $_LINE in order to procede." && return 1 )
        _STATUS="$?"
        test $_STATUS -eq 0 || return $_STATUS
    done < ./requirements.py.txt
}

_check_requirements () {
    _check_system_requirements || return 1
    _check_python_requirements || return 1
    return 0
}

##########
# PUBLIC #
##########

_git_add_partial () {
    local _FILE="$1"
    git add -p "$_FILE"
}

_git_branch_clean () {
    local _BRANCHES=$( git branch | sed 's/*//g' )
    local _CURRENT_BRANCH=$( _git_branch_current )
    for _BRANCH in $_BRANCHES; do
        if [[ "$_BRANCH" = 'main' || "$_BRANCH" = "$_CURRENT_BRANCH" ]]; then echo "Skipping branch '$_BRANCH'."; sleep 0.5; continue; fi
        read -p "Are you sure you want to delete branch '$_BRANCH' from local and remote? [n/Y] " _ANSWER
        case $_ANSWER in
            'n' ) echo "Skipping branch '${_BRANCH}.'";;
            'Y' ) echo "Deleting branch '${_BRANCH}'."; git branch -D $_BRANCH; git push --delete origin $_BRANCH;;
            * ) echo "Please answer 'n' for 'no' 'Y' for 'yes'. Skipping branch '${_BRANCH}.'";;
        esac
        sleep 0.5
    done
}

_git_branch_current () {
    _IDENTIFIER="$1"
    if [ "$_IDENTIFIER" = 'hash' ]
        then _ECHO=$( git rev-parse --short HEAD )
        else _ECHO=$( git branch --show-current )
    fi

    echo "$_ECHO"
}

_git_commit_amend () {
    git commit --amend --no-edit
}

_git_merge_squash () {
    local _BRANCH="$1"
    if [ -z "$_BRANCH" ]; then echo 'You must specify a branch in order to proceed. Exiting...'; exit 1; fi
    git merge --squash "$_BRANCH"
    git commit -c "$_BRANCH"
    _NUM_O_TAGS=$( git tag -l | wc -l )
    let "++_NUM_O_TAGS"
    git tag "${_NUM_O_TAGS}_${_BRANCH}"
}


#######
# RUN #
#######

#################################
# Deactivated # Takes to long ###
#################################
# _check_requirements || exit 1 #
#################################

_COMM="$1"
shift
_ARGS="$@"

$_COMM $_ARGS

#!/bin/bash

REGEX='APP_CONFIG(\[.*\])?'
BRANCH='develop'
STATE='added'

read -r -d '' helpMsg << HelpMessage

Searches for REGEX in code changes in commits unique to local branch compared to BRANCH

Usaage: 
$ git-search-local.sh [-r|--regex REGEX] [-b|--branch BRANCH]

Example: 
$ git-search-local.sh -r 'APP_CONFIG(\[.*\])?' -b master

Defaults:
  REGEX: $REGEX
  BRANCH: $BRANCH
HelpMessage

#set -o errexit -o noclobber -o nounset -o pipefail
params="$(getopt -o r:b:s:h -l regex:,branch:,state:,help --name "$0" -- "$@")"
eval set -- "$params"

while true
do
    case "$1" in
        -r|--regex)
            REGEX=$2
            shift 2
            ;;
        -b|--branch)
            BRANCH=$2
            shift 2
            ;;
        -s|--state)
            if [ $2 == 'removed' ]; then
                 STATE=$2
            fi
            shift 2
            ;;
        -h|--help)
            echo ""
            echo "$helpMsg"
            echo ""
            exit
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Not implemented: $1" >&2
            exit 1
            ;;
    esac
done

local_commit_shas=`git rev-list $(git rev-parse --abbrev-ref HEAD) --no-merges ^$BRANCH`

# Sets a regex with polarity of initial character
if [ $STATE == 'removed' ]; then
	POLAR_REGEX="^\-.*$REGEX"
else
	POLAR_REGEX="^\+.*$REGEX"
fi

declare -a found 
for sha in $local_commit_shas
do
	found_count=`git show $sha|grep -oE $POLAR_REGEX|wc -l`
	if [ "$found_count" -gt 0 ]; then
		for el in `echo "$(git show $sha)"|grep -oE "$REGEX"|sort -u`
		do
			found+=($el);
		done
	fi
done

uniques=($(for v in "${found[@]}"; do echo "$v";done| sort| uniq| xargs))
#echo "${uniques[@]}" #for single line
printf '%s\n' "${uniques[@]}"; #for multiple lines

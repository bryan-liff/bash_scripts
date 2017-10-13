#!/bin/bash

REGEX='APP_CONFIG\[.*]'
BRANCH='develop'
STATE='added'

read -r -d '' helpMsg << HelpMessage

Searches for REGEX in code changes in commits unique to local branch compared to BRANCH

Usaage: 
$ git-search-local.sh [-r|--regex REGEX] [-b|--branch BRANCH] [-s|--state added|removed]

Example: 
$ git-search-local.sh -r 'APP_CONFIG(\[.*\])?' -b master -s removed

Defaults:
  REGEX: $REGEX
  BRANCH: $BRANCH
  STATE: $STATE
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
	INITIAL_REGEX="^-"
else
    INITIAL_REGEX="^\+"
fi
POLAR_REGEX="$INITIAL_REGEX.*$REGEX"

declare -a found

add_match_to_found(){
    match=$(echo $1|grep -oE $REGEX)
    found+=($match)
}


for sha in $local_commit_shas
do
	r=$(git show --unified=0 --pretty=oneline --no-notes -w -b $sha|grep -oE $POLAR_REGEX)
	if [ ${#r} != 0 ]; then
		mapfile -t arr <<< "$r"
		for line in "${arr[@]}"
		do
            if echo "$line" | grep -q $INITIAL_REGEX
            then
                add_match_to_found "$line"
            fi
		done
	fi
done

uniques=($(for v in "${found[@]}"; do echo "$v";done| sort| uniq| xargs))
#echo "${uniques[@]}" #for single line
printf '%s\n' "${uniques[@]}"; #for multiple lines

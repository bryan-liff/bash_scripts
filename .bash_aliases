# This file must be sourced, e.g. from ~/.bashrc:
#
# if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
# fi

git_delete_origin() {
    git push origin :$1
    git branch -D $1
}
alias gdo=git_delete_origin
#Usage: gdo BRANCH_NAME

git_delete_tag() {
    git tag -d $1
    git push origin :refs/tags/$1
}
alias gdt=git_delete_tag
#Usage: gdt TAG_NAME

git_rename_tag() {
    git tag $2 $1
    git tag -d $1
    git push origin :refs/tags/$1
    git push --tags
}
alias grt=git_rename_tag
#Usage: grt OLD_TAG NEW_TAG

alias doco='docker-compose'
alias docod='docker-compose down --remove-orphans'
alias dp='docker system prune -a'
alias gb='CUR_BRANCH=`git rev-parse --abbrev-ref HEAD` && export GIT_BRANCH="${CUR_BRANCH/\//-}"'
alias drn='docker rmi -f $(docker images --filter "dangling=true" -q --no-trunc)'

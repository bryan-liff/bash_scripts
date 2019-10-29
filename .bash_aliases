# This file must be sourced, e.g. from ~/.bashrc:
#
# if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
# fi

git_delete_origin() {
    git push origin :$1
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

# Clear all *.log files in local directory
alias clf='for file in `ls *.log`; do echo > $file; done'

# Start Memcached daemon
alias mem='memcached -d -m 24 -p 11211'

# Rails reset test DB - load schema
alias rdb='RAILS_ENV=test rails db:drop; RAILS_ENV=test rails db:create; RAILS_ENV=test rails db:schema:load'

# Rails reset test DB - migrate
alias rdbm='RAILS_ENV=test rails db:drop; RAILS_ENV=test rails db:create; RAILS_ENV=test rails db:migrate'

# Rspec features, exclude 'quarantine' tag
alias rspec-f='rspec spec/features/* --tag ~quarantine'

# Rspec non-features, exclude 'quarantine' tag
alias rspec-sans='rspec --exclude-pattern '\''spec/features/**/*_spec.rb'\'' --tag ~quarantine'

# Rspec 'quarantine' tag
alias rspec-q='rspec --tag quarantine'

# Clear and output log/test.log
alias tail-t='echo > log/test.log; clear; tail -f log/test.log'

alias doco='docker-compose'
alias dp='docker system prune -a'
alias gb='CUR_BRANCH=`git rev-parse --abbrev-ref HEAD` && export GIT_BRANCH="${CUR_BRANCH/\//-}"'
alias dcwb='docker-compose run --rm web bash'

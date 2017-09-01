export GOROOT=/opt/go/goroot
export SCALA_HOME=/opt/scala
export GOPATH=/home/projects
export PATH="$PATH:$SCALA_HOME/bin:$GOROOT/bin:$GOPATH/bin"
export EDITOR=vim

gs() {
	for i in *; do [ -d $i ] || continue;echo "repo:$i"; cd "$i"; bash -c "git ${*:0}";cd ..;done
}

#parallel
gsp() {
    echo "Running 'git ${*:0}' on all directories in current path"
    ls -d */|xargs -L1 -I{} -P40  bash -c "cd {} && git ${*:0};echo '{} done'"
}

# gapi forks kavehmz/prime
# gapi rate_limit
gapi() {
	local GIT_TOKEN=$(cat /home/share/secret/github_token)
    local CMD="$1"
    local GIT_ORG_REPO=''
    [ "$2" != "" ] && GIT_ORG_REPO="/repos/$2"
	curl --silent "https://api.github.com$GIT_ORG_REPO/$CMD?access_token=$GIT_TOKEN"
}

# (cdg k/bo) => (cdg; cd k*/bo*)
cdg() {
    cd /home/projects/src/github.com
    local WDIR=$(echo $1|sed 's/\//*\//g'|sed 's/-/*/g'|sed 's/$/*/')
    [ "$1" != "" ] && cd $(ls -d $WDIR|head -n1)
}

dl() {
    L=$(python ~/.yturl/yturl.py "$1")
    echo $L
    curl -C - -o ~/"$2" "$L"
}

alias g=git
alias gg="git grep -i --color"
alias ff="find .|grep -i"
#an alias to show the latest commit for each file. This also shows which files are in git
alias gl='for i in $(ls -A);do printf "%-32s %s\n" "$i" "$(git log -n1 --oneline $i)";done'
[ -f /opt/hub/bin/hub ] && alias git=/opt/hub/bin/hub
alias ts="perl -e 'use Time::HiRes; while(<>) { print sprintf(\"%-17s \", Time::HiRes::time),"'" "'".\$_;}'"
alias sa='ssh-agent -k 2> /dev/null;eval "$(ssh-agent -s)";ssh-add ~/.ssh/id_rsa;ssh-add ~/.ssh/id_rsa_ta'

alias gc="source ~/.gc.sh"
alias k8s="kubectl config view -o template --template='{{ index . "'"current-context"'" }}'|sed -e 's/^.*_//g';echo"
alias vpn='(gc sel 5;gcloud beta compute firewall-rules delete  kmz-tmp;gcloud beta compute firewall-rules create kmz-tmp --network core --allow 22 --source-ranges "$(dig +short myip.opendns.com @resolver1.opendns.com)";ssh "$(cat ~/.vpn_server)";gcloud beta compute firewall-rules delete  kmz-tmp)'

source /home/share/git-prompt.sh
PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

[[ -f /usr/share/bash-completion/completions/git ]] && source /usr/share/bash-completion/completions/git

complete -o bashdefault -o default -o nospace -F _git g 2>/dev/null \
    || complete -o default -o nospace -F _git g

source /opt/perl5/etc/bashrc #perlbrewrc

source /home/share/aws_assumerole.sh

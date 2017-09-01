case "$1" in
  "ls")
    echo "list of projects"
    gcloud projects list |cat -n
    ;;
  "sel")
    export CLOUDSDK_CORE_PROJECT=$(gcloud projects list |cat -n|egrep "^\s+$2\s"|perl -e '$l=<>;chomp $l;$l=~ s/^\s+\d+\s(.*?)\s+.*/$1/g;print $l,"\n"')
    echo "set CLOUDSDK_CORE_PROJECT to [$CLOUDSDK_CORE_PROJECT]"
    ;;
  "ils")
    echo "list of instnaces in [$CLOUDSDK_CORE_PROJECT]"
    gcloud compute instances list|cat -n
    ;;
  "ssh")
    find_and_ssh $2
    ;;

  "cls")
    echo "list of containers in [$CLOUDSDK_CORE_PROJECT]"
    gcloud container clusters list|cat -n
    ;;
  "csel")
    find_and_set_k8s $2
    ;;
  *)
    echo "Note: [Identifier] is a number or name in the list"
    echo "Usage:"
    echo "gc ls # list projects"
    echo "gc sel [Identifier] # select a project"
    echo "gc ils # list of instances"
    echo "gc ssh [Identifier]"
    echo "gc cls # list containers"
    echo "gc csel [Identifier] # get credentials for a container"
    ;;
esac

function find_and_ssh {
    local SERVER=$(gcloud compute instances list|cat -n|egrep "\s+$1\s"|perl -e '$l=<>;chomp $l;$l=~ s/^\s+\d+\s(.*?)\s+(.*?)\s+.*/$1 --zone $2/g;print $l,"\n"')
    echo "ssh into [kmousavizamani@$SERVER]"
    gcloud compute ssh kmousavizamani@$SERVER
}

function find_and_set_k8s {
    local CONTAINER=$(gcloud container clusters list|cat -n|egrep "\s+$1\s"|perl -e '$l=<>;chomp $l;$l=~ s/^\s+\d+\s(.*?)\s+(.*?)\s+.*/$1 --zone $2/g;print $l,"\n"')
    echo "clusters get-credentials for [$CONTAINER]"
    gcloud container clusters get-credentials $CONTAINER
}
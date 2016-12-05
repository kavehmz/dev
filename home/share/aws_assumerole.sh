#!/bin/bash -i

USAGE="Usage: $0 [--profile=name] [list|role user mfa_token]"
([ "$1" != 'list' ] && ([ "$2" == '' ] || [ "$3" == '' ] ) )&& echo $USAGE &&  exit 0

PROFILE='default'
while getopts ":p:" arg; do
  case "${arg}" in
    p)
      PROFILE=${OPTARG}
      shift
      shift
      ;;
    *)
      echo $USAGE
      exit 0
      ;;
  esac
done


ROLES=$(aws iam list-roles --profile=$PROFILE|grep Arn|cut -d'"' -f4)
[ "$1" == 'list' ] && echo "$ROLES" && exit 0

ROLE="$1"
USER="$2"
MFA_TOKEN="$3"

ROLE_ARN=$(echo "$ROLES"|grep $ROLE)
MFA_SERIAL_NUMBER=$(echo $ROLE_ARN|cut -d':' -f-5):mfa/$USER

SESSION=$(aws sts assume-role --profile=$PROFILE --role-arn "$ROLE_ARN" --role-session-name s3-access-example --serial-number "$MFA_SERIAL_NUMBER" --token-code "$MFA_TOKEN")

if [ "$SESSION" != "" ]
then
    export AWS_ACCESS_KEY_ID=$(echo "$SESSION"|grep AccessKeyId|cut -d'"' -f 4)
    export AWS_SECRET_ACCESS_KEY=$(echo "$SESSION"|grep SecretAccessKey|cut -d'"' -f 4)
    export AWS_SESSION_TOKEN=$(echo "$SESSION"|grep SessionToken|cut -d'"' -f 4)
    export AWS_SESSION_EXPIRY=$(echo "$SESSION"|grep Expiration|cut -d'"' -f 4)
    export AWS_ROLE=$ROLE
    echo "Assuming role of $ROLE_ARN until [$AWS_SESSION_EXPIRY]"
    bash
    echo "End of $ROLE_ARN"
else
    echo "Fail to assume the role"
fi


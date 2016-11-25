#!/bin/bash -i
set -e
ROLES=$(aws iam list-roles|grep Arn|cut -d'"' -f4)
[ "$1" == 'list' ] && echo "$ROLES" && exit 0

([ "$1" == '' ] || [ "$2" == '' ] || [ "$3" == '' ] )&& echo "aws_access.sh [list|role user mfa_token]" &&  exit 0

ROLE="$1"
USER="$2"
MFA_TOKEN="$3"

ROLE_ARN=$(echo "$ROLES"|grep $ROLE)
MFA_SERIAL_NUMBER=$(echo $ROLE_ARN|cut -d':' -f-5):mfa/$USER

SESSION=$(aws sts assume-role --role-arn "$ROLE_ARN" --role-session-name s3-access-example --serial-number "$MFA_SERIAL_NUMBER" --token-code "$MFA_TOKEN")

if [ "$SESSION" != "a" ]
then
    export AWS_ACCESS_KEY_ID=$(echo "$SESSION"|grep AccessKeyId|cut -d'"' -f 4)
    export AWS_SECRET_ACCESS_KEY=$(echo "$SESSION"|grep SecretAccessKey|cut -d'"' -f 4)
    export AWS_SESSION_TOKEN=$(echo "$SESSION"|grep SessionToken|cut -d'"' -f 4)
    echo "Assuming role of $ROLE_ARN"
    bash
    echo "End of $ROLE_ARN"
fi


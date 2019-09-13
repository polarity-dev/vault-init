/bin/sh

set -e

COMMAND="aws secretsmanager get-secret-value"

if [ -n "${AWS_ENDPOINT}" ]; then
    COMMAND="$COMMAND --endpoint-url $AWS_ENDPOINT"
fi

if [ -n "${AWS_REGION}" ]; then
    COMMAND="$COMMAND --region $AWS_REGION"
fi

if [ -z $AWS_SECRET_ID ]; then
    echo "Missing AWS_SECRET_ID environment variable" 1>&2
    exit 1
else
    COMMAND="$COMMAND --secret-id $AWS_SECRET_ID"
fi

set +e
while true; do
    OUTPUT=$($COMMAND)
    STATUS=$?
    if [ $STATUS = 0 ]; then
        break
    else
        echo "Retrying in 5s..."
        sleep 5
    fi
done

set -e

echo $OUTPUT | jq -r ".SecretString"
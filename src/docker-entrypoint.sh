#!/usr/bin/dumb-init /bin/sh
set -e

# Note above that we run dumb-init as PID 1 in order to reap zombie processes
# as well as forward signals to all processes in its session. Normally, sh
# wouldn't do either of these functions so we'd leak zombies as well as do
# unclean termination of all our sub-processes.

# Prevent core dumps
ulimit -c 0

set +e

STATUS=1
OUTPUT=''

while true; do
  echo "Checking the current vault status..."
  vault status -address=$VAULT_ENDPOINT > /dev/null 2>&1
  STATUS=$?
  if [ $STATUS = 2 ]; then
    break
  else
    echo "Vault unavailable. Retrying in 5s..."
  fi
  sleep 5
done


while true; do
  echo "Initializing vault..."
  OUTPUT=$(vault operator init -key-shares=1 -key-threshold=1 -address=$VAULT_ENDPOINT 2> /dev/null)
  STATUS=$?
  if [ $STATUS = 0 ]; then
    echo "Vault initialized"
    break
  elif [ $STATUS = 2 ]; then
    echo "Vault is already initialized"
    exit $STATUS
  fi
  echo "Retrying in 5s..."
  sleep 5
done

ARRAY=$(echo "$OUTPUT" | awk -F': ' '{print $2}' | xargs)

UNSEAL_KEY=$(echo $ARRAY | awk '{print $1}')
ROOT_TOKEN=$(echo $ARRAY | awk '{print $2}')

echo "Trying to unseal vault..."
until vault operator unseal -address=$VAULT_ENDPOINT $UNSEAL_KEY > /dev/null 2>&1; do
  sleep 5 
  echo "Trying to unseal vault..."
done
echo "Vault unsealed"

echo "Loggin in..."
until vault login -address=$VAULT_ENDPOINT $ROOT_TOKEN > /dev/null 2>&1
do
  sleep 5
  echo "Loggin in..."
done
echo "Successfully logged in"

echo "Creating admin policy..."
until vault policy write -address=$VAULT_ENDPOINT admin /tmp/admin-policy.hcl > /dev/null 2>&1
do
  sleep 5
  echo "Creating admin policy..."
done
echo "Successfully created admin policy"

echo "Enabling userpass auth method..."
until vault auth enable -address=$VAULT_ENDPOINT userpass > /dev/null 2>&1
do
  sleep 5
  echo "Enabling userpass auth method..."
done
echo "Successfully enabled userpass auth method"

echo "Creating user admin with the desired password..."
until vault write -address=$VAULT_ENDPOINT auth/userpass/users/$VAULT_ADMIN_USERNAME \
    password=$VAULT_ADMIN_PASSWORD \
    policies=admin > /dev/null 2>&1
do
  sleep 5
  echo "Creating user admin with the desired password..."
done
echo "Successfully created user admin with username $VAULT_ADMIN_USERNAME"

echo "Revoking initial root token..."
until vault token revoke -address=$VAULT_ENDPOINT $ROOT_TOKEN > /dev/null 2>&1
do
  sleep 5
  echo "Revoking initial root token..."
done
echo "Successfully revoked initial root token"

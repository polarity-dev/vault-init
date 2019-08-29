# vault-init

vault-init is a useful container that can be used to automatically configure a vault server.

## Behaviour
vault-init performs the following operations:
1. Check the current vault status (with a retry mechanism that will retry to connect every 5s if the vault server is not available)
2. Initialize the vault server (or exit if already initilized)
3. Unseal the vault server
4. Create the admin policy
<<<<<<< HEAD
5. Create the admin user (username: `$VAULT_ADMIN_USERNAME` and password: `$VAULT_ADMIN_PASSWORD`)
=======
5. Create the admin user (username: `admin` and password: `$VAULT_ADMIN_PASSWORD`)
>>>>>>> Add README.md

## Configurations
You can configure the vault-init behaviour using these env variables:
- `VAULT_ENDPOINT` is the endpoint of the vault server (eg. `https://vault.example.com:8200`)
- `VAULT_ADMIN_PASSWORD` is the desired password for the admin user
<<<<<<< HEAD
- `VAULT_ADMIN_USERNAME` is the desired username for the admin user
=======
>>>>>>> Add README.md

## Development requirements
- [NodeJS and npm](https://nodejs.org)
- [Docker](https://www.docker.com/)

## Development instructions
1. Make sure the Docker daemon is up and running
2. Run `npm start` or `npm run start-with-build` to execute vault server and vault-init containers
3. Run `npm stop` to stop all the running containers

## Repo structure
- `src/` folder contains all the vault-init code (Dockerfile, docker-entrypoint.sh and other configuration files)
- `vault/` folder contains the vault configuration (`src/` directory) and persistence data (`data/` directory)

## Docker container push
In order to push the docker container image to dockerhub you can run
```sh
$ npm run publish
```

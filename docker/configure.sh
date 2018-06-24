#!/bin/sh

# Script creates new ENV file and changes all configuration files.

# Absolute path to the script.
SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

# File references.
DOCKER_ENV_FILE=$SCRIPT_PATH'/.env'
NGINX_RENAME_SCRIPT=$SCRIPT_PATH'/nginx/scripts/nginx-rename.sh'
TREAFIK_RENAME_SCRIPT=$SCRIPT_PATH'/traefik/scripts/traefik-rename.sh'
TRAEFIK_TOML_FILE_HTTP=$SCRIPT_PATH'/traefik/traefik.http.toml'
TRAEFIK_TOML_FILE_HTTPS=$SCRIPT_PATH'/traefik/traefik.https.toml'
TRAEFIK_SWAP_SCRIPT=$SCRIPT_PATH'/traefik/scripts/traefik-swap.sh'

# Import ENV file.
if [ -f $DOCKER_ENV_FILE ]
then
    . $DOCKER_ENV_FILE
else
    # Default script placeholders.
    DOMAIN_NAME=example.com
    EMAIL=mailbox@example.com
fi

# If there is an argument passed to the script.
if [ $# -ne 0 ]
then
    # If the passed argument is "PRODUCTION" option.
    if [ "$1" = "--production" ] || [ "$1" = "-p" ]
    then
        # Read configuration.
        printf "Enter domain name (example.com): "
        read NEW_DOMAIN_NAME
        printf "Enter your e-mail address (cos of Let's Encrypt check): "
        read NEW_EMAIL
        
        # Replace domain name in Nginx and Traefik configuration files.
        sh $NGINX_RENAME_SCRIPT $DOMAIN_NAME $NEW_DOMAIN_NAME
        sh $TREAFIK_RENAME_SCRIPT $DOMAIN_NAME $NEW_DOMAIN_NAME $EMAIL $NEW_EMAIL

        # If Traefik SSL configuration file exists.
        if [ -f $TRAEFIK_TOML_FILE_HTTPS ]
        then
            # Swap Traefik configuration to SSL.
            sh $TRAEFIK_SWAP_SCRIPT
        fi

        # Delete ENV file if exists.
        if [ -f $DOCKER_ENV_FILE ]; then rm $DOCKER_ENV_FILE; fi

        # Generate new ENV file.
        (
            echo # Don't delete this file if you want to run configuration script again.
            echo DOMAIN_NAME=$NEW_DOMAIN_NAME
            echo HTTP_PORT=80
            echo EMAIL=$NEW_EMAIL
            echo COMPOSE_CONVERT_WINDOWS_PATHS=1
        )>$DOCKER_ENV_FILE

        echo "[CONFIGURE]: All PRODUCTION configuration done."
        echo "[WARNING]: Don't delete ENV file if you want to run this configuration again."
        
    # If the passed argument is "LOCALHOST" option.
    elif [ "$1" = "--localhost" ] || [ "$1" = "-l" ]
    then
        # Read configuration.
        printf "Enter domain name (example.localhost): "
        read NEW_DOMAIN_NAME
        printf "Enter HTTP port (80 or some other if 80 is blocked): "
        read NEW_HTTP_PORT

        # Replace domain name in Nginx and Traefik configuration files.
        sh $NGINX_RENAME_SCRIPT $DOMAIN_NAME $NEW_DOMAIN_NAME
        sh $TREAFIK_RENAME_SCRIPT $DOMAIN_NAME $NEW_DOMAIN_NAME $EMAIL localhost

        # If Traefik non SSL configuration file exists.
        if [ -f $TRAEFIK_TOML_FILE_HTTP ]
        then
            # Swap Traefik configuration to non SSL.
            sh $TRAEFIK_SWAP_SCRIPT
        fi

        # Delete ENV file if exists.
        if [ -f $DOCKER_ENV_FILE ]; then rm $DOCKER_ENV_FILE; fi

        # Generate new ENV file.
        (
            echo # Don't delete this file if you want to run configuration script again.
            echo DOMAIN_NAME=$NEW_DOMAIN_NAME
            echo HTTP_PORT=$NEW_HTTP_PORT
            echo EMAIL=localhost
            echo COMPOSE_CONVERT_WINDOWS_PATHS=1
        )>$DOCKER_ENV_FILE

        echo "[CONFIGURE]: All LOCALHOST configuration done."
        echo "[WARNING]: Don't delete ENV file if you want to run this configuration again."

    # If the passed argument is "HELP" option.
    elif [ "$1" = "--help" ] || [ "$1" = "-h" ]
    then
        echo ""
        echo "Script creates new ENV file and changes all configuration files."
        echo "Usage: sh configure.sh OPTION"
        echo ""
        echo "OPTIONS:"
        echo "-p, --production   Configure stack in PRODUCTION."
        echo "-l, --localhost    Configure stack in LOCALHOST."
        echo ""
        exit
    # If the passed argument is wrong.
    else
        echo "Wrong argument supplied. Run 'sh configure.sh --help' to getting help."
    fi
# If there is no argument passed to the script.
else 
    echo "No argument supplied. Run 'sh configure.sh --help' to getting help."
fi
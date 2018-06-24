#!/bin/sh

# Script configures stack and runs proper Docker containers.

# Absolute path to the script.
SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")
STACK_CONFIGURED=false

# File references.
CONFIGURE_SCRIPT=$SCRIPT_PATH'/configure.sh'
DOCKER_ENV_FILE=$SCRIPT_PATH'/.env'

# If there is an argument passed to the script.
if [ $# -ne 0 ]
then
    # If some ENV file exists.
    if [ -f $DOCKER_ENV_FILE ]
    then
        # Import ENV configuration.
        . $DOCKER_ENV_FILE

        # Rewrite configuration prompt.
        printf "Existing configuration found ($DOMAIN_NAME).\n"
        printf "Do you want to run it? No means reconfigure! (y/n): "
        read ANSWER
        
        # If the answer is yes. Run stack.
        if [ "$ANSWER" = "yes" ] || [ "$ANSWER" = "y" ]
        then
            STACK_CONFIGURED=true
        # If the answer is no. Reconfigure stack.
        elif [ "$ANSWER" = "no" ] || [ "$ANSWER" = "n" ]
        then
            STACK_CONFIGURED=false
        else
            exit
        fi
    fi

    if [ "$STACK_CONFIGURED" = false ]
    then
        # If the passed argument is "PRODUCTION" option.
        if [ "$1" = "--production" ] || [ "$1" = "-p" ]
        then
            # Configure stack.
            sh $CONFIGURE_SCRIPT --production
            STACK_CONFIGURED=true
            PROTOCOL=https
            PORT=443
            
        # If the passed argument is "LOCALHOST" option.
        elif [ "$1" = "--localhost" ] || [ "$1" = "-l" ]
        then
            # Configure stack.
            sh $CONFIGURE_SCRIPT --localhost
            STACK_CONFIGURED=true
            PROTOCOL=http

        # If the passed argument is "HELP" option.
        elif [ "$1" = "--help" ] || [ "$1" = "-h" ]
        then
            echo ""
            echo "Script configures stack and runs proper Docker containers."
            echo "Usage: sh run.sh OPTION"
            echo ""
            echo "OPTIONS:"
            echo "-p, --production   Run stack in PRODUCTION."
            echo "-l, --localhost    Run stack in LOCALHOST."
            echo ""
            exit
        # If the passed argument is wrong.
        else
            echo "Wrong argument supplied. Run 'sh run.sh --help' to getting help."
        fi
    fi

    if [ "$STACK_CONFIGURED" = true ]
    then
        # Import ENV configuration.
        . $DOCKER_ENV_FILE

        # Create new Docker network.
        docker network create proxy.$DOMAIN_NAME
        
        # Build Docker containers.
        docker-compose build

        # Run Docker containers.
        docker-compose up -d
        
        # Echo out available services.
        if [ "$PORT" != 443 ]
        then 
            PORT=$HTTP_PORT 
        fi

        echo "[RUN]: If there is no errors above then these services should be running like a charm!"
        echo "[NGINX/PHP]:  "$PROTOCOL"://"$DOMAIN_NAME":"$PORT
        echo "[TRAEFIK]:    "$PROTOCOL"://traefik."$DOMAIN_NAME":"$PORT
        echo "[PHPMYADMIN]: "$PROTOCOL"://pma."$DOMAIN_NAME":"$PORT
        echo "[PORTAINER]:  "$PROTOCOL"://portainer."$DOMAIN_NAME":"$PORT
    fi
# If there is no argument passed to the script.
else 
    echo "No argument supplied. Run 'sh run.sh --help' to getting help."
fi
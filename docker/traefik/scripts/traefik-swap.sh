#!/bin/sh

# Script swap the Traefik non SSL configuration file to SSL variant and vice versa.

# Absolute path to the script.
SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

# File references.
TRAEFIK_TOML_FILE=$SCRIPT_PATH'/../traefik.toml'
TRAEFIK_TOML_FILE_HTTP=$SCRIPT_PATH'/../traefik.http.toml'
TRAEFIK_TOML_FILE_HTTPS=$SCRIPT_PATH'/../traefik.https.toml'
DOCKER_COMPOSE_FILE=$SCRIPT_PATH'/../../docker-compose.yml'

# If there is an argument passed to the script.
if [ $# -ne 0 ]
then
    # If the passed argument is "HELP" option.
    if [ "$1" = "--help" ] || [ "$1" = "-h" ]
    then
        echo ""
        echo "Script swap the Traefik non SSL configuration file to SSL variant and vice versa."
        echo "Usage: sh traefik-swap.sh"
        echo "No OPTIONS needed."
        echo ""
        exit
    # If the passed argument is wrong.
    else
        echo "Wrong argument supplied. Run 'sh traefik-swap.sh --help' to getting help."
    fi
# If there is no argument passed to the script.
else 
    # If non SSL configuration is running.
    if [ -f $TRAEFIK_TOML_FILE_HTTPS ]
    then
        # Swap non SSL configuration to SSL.
        cp $TRAEFIK_TOML_FILE $TRAEFIK_TOML_FILE_HTTP
        rm $TRAEFIK_TOML_FILE
        cp $TRAEFIK_TOML_FILE_HTTPS $TRAEFIK_TOML_FILE
        rm $TRAEFIK_TOML_FILE_HTTPS
        sed -i 's/#- "443:443"/- "443:443"/g' $DOCKER_COMPOSE_FILE
        echo "[Treaefik]: Swapping non SSL to SSL done."

    # If SSL configuration is running.
    elif [ -f $TRAEFIK_TOML_FILE_HTTP ]
    then
        # Swap SSL configuration to non SSL.
        cp $TRAEFIK_TOML_FILE $TRAEFIK_TOML_FILE_HTTPS
        rm $TRAEFIK_TOML_FILE
        cp $TRAEFIK_TOML_FILE_HTTP $TRAEFIK_TOML_FILE
        rm $TRAEFIK_TOML_FILE_HTTP
        sed -i 's/- "443:443"/#- "443:443"/g' $DOCKER_COMPOSE_FILE
        echo "[Traefik]: Swapping SSL to non SSL done."
    fi
fi
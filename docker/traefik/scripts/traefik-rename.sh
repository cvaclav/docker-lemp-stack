#!/bin/sh

# Script replaces current domain name in Traefik configuration file to new one.

# Absolute path to the script.
SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

# File references.
DOCKER_COMPOSE_FILE=$SCRIPT_PATH'/../../docker-compose.yml'
TRAEFIK_TOML_FILE=$SCRIPT_PATH'/../traefik.toml'
TRAEFIK_TOML_FILE_HTTP=$SCRIPT_PATH'/../traefik.http.toml'
TRAEFIK_TOML_FILE_HTTPS=$SCRIPT_PATH'/../traefik.https.toml'

# If there is no argument passed to the script.
if [ $# -eq 0 ]
then
    echo "No argument supplied. Run 'sh traefik-rename.sh --help' to getting help."
fi

# If there is one argument passed to the script.
if [ $# -ne 0 ]
then
    # If the passed argument is "HELP" option.
    if [ "$1" = "--help" ] || [ "$1" = "-h" ]
    then
        echo ""
        echo "Script replaces current domain name in Traefik configuration file to new one."
        echo "Usage: sh traefik-rename.sh <current domain name> <new domain name> <current e-mail> <e-mail>"
        echo "No OPTIONS needed."
        echo ""
        exit
    fi
fi

# If there are three arguments passed to the script.
if [ $# -eq 4 ]
then
    # Create regex.
    REGEX_DOMAIN='s/'$1'/'$2'/g'  
    REGEX_EMAIL='s/'$3'/'$4'/g'  

    # Replace network name in Docker compose file.
    REGEX_PROXY='s/proxy.'$1'/proxy.'$2'/g'  
    sed -i $REGEX_PROXY $DOCKER_COMPOSE_FILE

    # Run replace.
    sed -i $REGEX_DOMAIN $TRAEFIK_TOML_FILE
        
    # If SSL configuration file exists.
    if [ -f $TRAEFIK_TOML_FILE_HTTPS ]
    then
        sed -i $REGEX_EMAIL $TRAEFIK_TOML_FILE_HTTPS
        sed -i $REGEX_DOMAIN $TRAEFIK_TOML_FILE_HTTPS
    fi

    # If non SSL configuration file exists.
    if [ -f $TRAEFIK_TOML_FILE_HTTP ]
    then
        sed -i $REGEX_EMAIL $TRAEFIK_TOML_FILE
        sed -i $REGEX_DOMAIN $TRAEFIK_TOML_FILE_HTTP
    fi

    # Echo out status.
    echo "[Traefik]: Configuration changing '"$1"' to '"$2"' done."
fi
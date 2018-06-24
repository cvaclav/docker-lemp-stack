#!/bin/sh

# Script replaces current domain name in Nginx configuration file to new one.

# Absolute path to the script.
SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

# File references.
NGINX_CONF_FILE=$SCRIPT_PATH'/../nginx.conf'

# If there is no argument passed to the script.
if [ $# -eq 0 ]
then
    echo "No argument supplied. Run 'sh nginx-rename.sh --help' to getting help."
fi

# If there is one argument passed to the script.
if [ $# -eq 1 ]
then
    # If the passed argument is "HELP" option.
    if [ "$1" = "--help" ] || [ "$1" = "-h" ]
    then
        echo ""
        echo "Script replaces current domain name in Nginx configuration file to new one."
        echo "Usage: sh nginx-rename.sh <current domain name> <new domain name>"
        echo "No OPTIONS needed."
        echo ""
        exit
    fi
fi

# If there are two arguments passed to the script.
if [ $# -eq 2 ]
then
    # Create regex.
    REGEX='s/'$1'/'$2'/g'  

    # Run replace.
    sed -i $REGEX $NGINX_CONF_FILE

    # Echo out status.
    echo "[Nginx]: Replacing '"$1"' to '"$2"' configuration finished."
fi
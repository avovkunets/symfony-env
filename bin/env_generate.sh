#!/usr/bin/env bash

# check if script is run under bash
if [ ! "$BASH_VERSION" ];then
    echo "`tput setaf 1`✖ Please run the script under bash`tput sgr0`"
    exit
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"
ENV_FILE="$SCRIPT_DIR/../.env"
# shellcheck disable=SC1090
source "$SCRIPT_DIR/includes/fonts.sh"
# shellcheck disable=SC1090
source "$SCRIPT_DIR/includes/util.sh"

task ".env file generating:"
echo " "

touch "$ENV_FILE"
# shellcheck disable=SC2188
> "$ENV_FILE"

if [[ "$OSTYPE" == "linux-gnu"* ]];
then
  WEB_PATH="$SCRIPT_DIR/../apps"
  XDEBUG_HOST="172.155.0.1"
  MY_UID=$(id -u)
else
  WEB_PATH='web-data'
  XDEBUG_HOST="127.0.0.1"
  MY_UID=1000
fi

echo "UID=$MY_UID" >> "$ENV_FILE"
echo "XDEBUG_HOST=\"$XDEBUG_HOST\"" >> "$ENV_FILE"

echo "WEB_PATH=$WEB_PATH" >> "$ENV_FILE"
ok "${YELLOW}WEB PATH${NORM} has been added"

ok "${YELLOW}.env${NORM} has been created"

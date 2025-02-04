#!/usr/bin/env bash

HTTPDUSER="www-data"

BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
PINK="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
NORMAL="\033[0;39m"
NC="\033[0m" # No Color

function echo_done() {
    echo -e "                  ... ${GREEN}done${NC}\r$1 "
}

git_remote_url_reachable() {
    git ls-remote "$1" CHECK_GIT_REMOTE_URL_REACHABILITY &>/dev/null
}

#  ================================================================================ Typo3
#BASE_PATH="/var/www/html/typo3"
#GIT_REPO="git@github.com:oshelest/typo3base.git"
#if [[ ! -d "$BASE_PATH" ]]; then
#  echo "Started building Typo3"
#  if git_remote_url_reachable "$GIT_REPO"; then
#    git clone -b master --recursive "$GIT_REPO" "$BASE_PATH"
#    # shellcheck disable=SC2164
#    cd "$BASE_PATH"
#    composer install
#    php vendor/bin/typo3cms install:setup \
#        --skip-integrity-check \
#        --no-interaction \
#        --database-user-name=root \
#        --database-user-password= \
#        --database-host-name=db \
#        --database-port=3306 \
#        --database-name=typo3base \
#        --admin-user-name=admin \
#        --admin-password=\$em0cleW
#    echo_done "Typo3"
#  else
#    echo -e "${RED}You don't have access to typo3base repository or you have not added RSA key to your Github account${NC}"
#  fi
#else
#  echo -e "Typo3 - ${GREEN}READY${NC}"
#fi

#echo_done "Amefa - READY"

sudo service redis-server start
# Restart SSH Server
sudo service ssh restart

#  ================================================================================ rator-api
BASE_PATH="/var/www/html/rator-api"
if [[ -d "$BASE_PATH" ]]; then
  cd "$BASE_PATH"
  yarn start > /dev/null 2>&1 &
  echo_done "rator-api started"
fi



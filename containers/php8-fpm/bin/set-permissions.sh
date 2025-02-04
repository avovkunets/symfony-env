#!/usr/bin/env bash

touch $HISTFILE && chown docker:docker $HISTFILE
chown -R docker:docker /home/docker
setfacl -dR -m u:www-data:rwX -m u:$(whoami):rwX /var/www/html/symfony
setfacl -R -m u:www-data:rwX -m u:$(whoami):rwX /var/www/html/symfony
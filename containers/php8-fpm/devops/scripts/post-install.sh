#!/usr/bin/env bash

## Generate jwt keys
# --skip-if-exists
php bin/console lexik:jwt:generate-keypair --overwrite
setfacl -R -m u:www-data:rX -m u:"$(whoami)":rwX config/jwt
setfacl -dR -m u:www-data:rX -m u:"$(whoami)":rwX config/jwt
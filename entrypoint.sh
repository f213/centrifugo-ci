#!/bin/sh

#
# Build configuration using env vars
#
cat config-template.json | gomplate > /centrifugo/config.json

#
# Remove vars so centrifugo binary will not complain
#
unset CENTRIFUGO_SECRET
unset CENTRIFUGO_ALLOWED_ORIGINS
unset CENTRIFUGO_ADMIN_PASSWORD
unset CENTRIFUGO_PERSONAL_NAMESPACE
unset CENTRIFUGO_ADDITIONAL_PERSONAL_NAMESPACES

centrifugo

#!/usr/bin/env bash

# read the file 'default.tmp' and parse env var with .env value and save
envsubst '$PROXY_UPSTREAM' < /etc/nginx/conf.d/default.tmp > /etc/nginx/conf.d/default.conf

# exec replaces the current process with a different so nginx can receive PID 1 so stop when receives SIG 1
exec usr/sbin/nginx -g 'daemon off;'


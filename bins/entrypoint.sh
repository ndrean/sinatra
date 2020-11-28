#!/usr/bin/env bash

set -ex

if [[ "$WAIT_FOR_PG" == "true" ]]; then
  echo Waiting for postgres to start...
  while ! pg_isready -h $POSTGRES_HOST > /dev/null; do
    sleep 0.5; 
  done

  echo ..done
fi
if [[ "$PREPARE_DATABASE" == "true" ]]; then
  bundle exec rake db:create db:migrate
fi
exec "$@"
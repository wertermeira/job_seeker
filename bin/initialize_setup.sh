#!/bin/bash
set -e

# create db and migrate
rails db:create db:migrate

# populate data base
rails populate:users

exec "$@"
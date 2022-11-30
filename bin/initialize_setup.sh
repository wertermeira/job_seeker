#!/bin/bash
set -e

# create db and migrate
rails db:create db:migrate

exec "$@"
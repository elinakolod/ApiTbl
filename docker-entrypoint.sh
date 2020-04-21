#!/bin/bash
set -e
rm -f $APP_HOME/tmp/pids/server.pid
rm -f $APP_HOME/tmp/pids/sidekiq.pid
bundle exec rails db:create
bundle exec rails db:migrate
exec "$@"

#!/usr/bin/env bash
# exit on error
set -o errexit

# Установка конфигурации Bundle
bundle config set --local without development
bundle install
if [ -f yarn.lock ]; then
  yarn install
fi
bundle exec rake db:drop || true
bundle exec rake db:migrate
bundle exec rake db:seed
bundle exec rake assets:precompile
bundle exec rake assets:clean
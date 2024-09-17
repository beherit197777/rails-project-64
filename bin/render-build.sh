#!/usr/bin/env bash
# exit on error
set -o errexit

# Установка конфигурации Bundle
bundle config set --local without development

# Установка зависимостей
bundle install

# Установка Yarn зависимостей (если используется)
if [ -f yarn.lock ]; then
  yarn install
fi

# Создание базы данных (если она не существует)
# bundle exec rake db:create || true

# Миграция базы данных
bundle exec rake db:migrate

# Заполнение базы данных начальными данными
bundle exec rake db:seed

# Компиляция ассетов
bundle exec rake assets:precompile

# Очистка ассетов (убедитесь, что такая задача существует)
bundle exec rake assets:clean
# syntax = docker/dockerfile:1

# Используем Ruby версии 3.2.2
ARG RUBY_VERSION=3.2.2
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails приложение будет работать в этой директории
WORKDIR /rails

# Устанавливаем базовые пакеты и PostgreSQL библиотеки
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips sqlite3 libpq-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Устанавливаем переменные окружения для продакшена
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test"

# Устанавливаем переменную окружения RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY=b6356aa9a58242c712c1c59783bb1845

# Стейдж для сборки образа
FROM base AS build

# Устанавливаем пакеты для сборки gems и node модулей
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git node-gyp pkg-config python-is-python3 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Устанавливаем Node.js и Yarn
ARG NODE_VERSION=22.5.0
ARG YARN_VERSION=1.22.22
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION && \
    rm -rf /tmp/node-build-master

# Устанавливаем gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Устанавливаем node модули
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Копируем исходный код приложения
COPY . .

# Предкомпиляция ассетов для продакшена
RUN SECRET_KEY_BASE_D

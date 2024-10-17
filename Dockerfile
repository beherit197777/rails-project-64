# syntax = docker/dockerfile:1

# Используем Ruby версии 3.2.2
ARG RUBY_VERSION=3.2.2
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails приложение будет работать в этой директории
WORKDIR /rails

# Устанавливаем базовые пакеты и PostgreSQL библиотеки
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips sqlite3 libpq-dev netcat-openbsd && \
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

# Устанавливаем Node.js, Yarn и esbuild
ARG NODE_VERSION=22.5.0
ARG YARN_VERSION=1.22.22
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION && \
    npm install -g esbuild && \
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
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Удаляем node_modules после компиляции для уменьшения размера образа
RUN rm -rf node_modules

# Финальный стейдж
FROM base

# Копируем артефакты сборки: gems, приложение
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Задаём права для пользователя Rails
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint для подготовки базы данных
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Открываем порт 3000
EXPOSE 3000

# Стартуем сервер
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]


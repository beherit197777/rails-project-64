# Collective blog
[![Actions Status](https://github.com/beherit1977777/rails-project-64/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/beherit1977777/rails-project-64/actions)
[![CI](https://github.com/beherit1977777/rails-project-64/actions/workflows/ci.yml/badge.svg)](https://github.com/beherit1977777/rails-project-64/actions)

Simple blog engine on Ruby on Rails.

Users can read posts, publish their own posts, leave comments on posts and comments and like posts.

The [demo](https://rails-project-64-rixq.onrender.com) is published on [render](https://render.com/) service

### Implementation Features

* Authentication with [devise](https://github.com/heartcombo/devise)
* Adaptive UI with [bootstrap](https://getbootstrap.com)
* Hierarchy of comments witn [ancestry](https://github.com/stefankroes/ancestry)

### Development

#### Requirements

* Ruby 3.2.2 or higher

#### Local start

To install dependencies and prepare local database, run: 
```shell
make install
```

To run locally, enter:
```shell
make start
```
And open your browser at http://localhost:3000

#### Tests and linter check

Tests can be start using:
```shell
make test 
```

Linter check can be run with:
```shell
make lint 
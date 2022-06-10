FROM ruby:2.3.4

MAINTAINER Emilano Jankowski

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

RUN gem install bundler
WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
# RUN rails db:reset && rails db:seed

COPY . .
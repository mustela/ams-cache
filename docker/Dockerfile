FROM ruby:2.3.1

MAINTAINER Emilano Jankowski

ENV APP_HOME /usr/src/app

# see update.sh for why all "apt-get install"s have to stay as one long line
RUN apt-get update && apt-get install -y nodejs postgresql-client --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN gem install bundler

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install $BUNDLE_ARGUMENTS

COPY . /usr/src/app

RUN mkdir -p $APP_HOME/shared/pids $APP_HOME/shared/log $APP_HOME/shared/sockets

COPY docker/start-api.sh /usr/bin/start-api.sh
RUN chmod 750 /usr/bin/start-api.sh

EXPOSE 3000

CMD ["start-api.sh"]
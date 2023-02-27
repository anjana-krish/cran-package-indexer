FROM ruby:3.1.2
MAINTAINER anjanakrish.p@gmail.com

ENV INSTALL_PATH /opt/app
RUN mkdir -p $INSTALL_PATH

RUN apt-get update && apt-get install -y \
  curl \
  build-essential \
  libpq-dev && \
  apt-get update 

# rails
RUN gem install bundler
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

WORKDIR /opt/app/cran-package-indexer-ms

RUN bundle install


VOLUME ["$INSTALL_PATH/public"]

EXPOSE 3000

# CMD ["rails", "s", "-b", "0.0.0.0"]

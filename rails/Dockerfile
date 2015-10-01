FROM ruby:2.2.1
RUN apt-get update && apt-get install -y \
  autoconf \
  automake \
  bison \
  build-essential \
  curl \
  g++ \
  gawk \
  gcc \
  libc6-dev \
  libffi-dev \
  imagemagick \
  libgdbm-dev \
  libncurses5-dev \
  libpq-dev \
  libreadline6-dev \
  libsqlite3-dev \
  libssl-dev \
  libtool \
  libyaml-dev \
  make \
  nodejs \
  nodejs-legacy \
  npm \
  patch \
  patch \
  pkg-config \
  sqlite3 \
  vim \
  zlib1g-dev

RUN npm install -g phantomjs
RUN mkdir /myapp

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /myapp
WORKDIR /myapp

ENV POSTGRES_PASSWORD mysecretpassword
ENV POSTGRES_USER postgres

EXPOSE 80

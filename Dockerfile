FROM ruby:3.2.3-slim

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential postgresql-client curl git libpq-dev libvips \
      node-gyp pkg-config python-is-python3 \
      nodejs libvips; \
    apt-get install -y npm && npm install -g yarn;

COPY Gemfile .
COPY Gemfile.lock .

RUN gem update --system 3.5.5
RUN bundle install --jobs 8 --retry 3

COPY . .

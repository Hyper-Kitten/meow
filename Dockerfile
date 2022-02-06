FROM ruby:3.1-alpine

RUN apk add --update git less build-base nodejs-current npm postgresql-dev chromium chromium-chromedriver python2 gcompat

RUN gem install rails

# Create a root directory for the app within the Docker container
RUN mkdir /app
WORKDIR /app

# COPY Gemfile Gemfile.lock ./
# RUN npm install -g yarn && bundle install && yarn install

COPY . .

LABEL maintainer="Josh Klina"

# CMD puma -C config/puma.rb

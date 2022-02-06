FROM ruby:3.1-alpine

RUN apk add --update git less build-base nodejs-current npm postgresql-dev chromium chromium-chromedriver python2 gcompat

# Create a root directory for the app within the Docker container
RUN mkdir /app
RUN mkdir -p /app/lib/hyper_kitten/meow
WORKDIR /app

COPY Gemfile hyper-kitten-meow.gemspec ./lib/hyper_kitten/meow/version.rb ./
COPY ./lib/hyper_kitten/meow/version.rb ./lib/hyper_kitten/meow/
RUN bundle install

COPY . .

LABEL maintainer="Josh Klina"

CMD puma -C config/puma.rb

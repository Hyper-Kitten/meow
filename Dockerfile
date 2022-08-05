FROM ruby:3.1-alpine

RUN apk add --update git less build-base nodejs-current npm postgresql-dev chromium chromium-chromedriver gcompat

# Create a root directory for the app within the Docker container
RUN mkdir /app
RUN mkdir -p /app/lib/hyper_kitten_meow
WORKDIR /app

COPY Gemfile Gemfile.lock hyper-kitten-meow.gemspec ./
COPY ./lib/hyper_kitten_meow/version.rb ./lib/hyper_kitten_meow/
RUN bundle install

COPY . .

LABEL maintainer="Josh Klina"

CMD spec/dummy/bin/rails server -b 0.0.0.0

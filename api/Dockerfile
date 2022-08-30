FROM ruby:3.1.1-alpine3.15

RUN apk add --update --no-cache build-base postgresql-dev tzdata yarn bash

RUN addgroup -S docker && adduser -S -G docker docker \
    && mkdir -p /home/docker/Downloads \
    && chown -R docker:docker /home/docker

RUN mkdir -p /home/docker/app
COPY . /home/docker/app
WORKDIR /home/docker/app
RUN chown -R docker:docker /home/docker/app

# Add a script to be executed every time the container starts.
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh

ARG RAILS_ENV
ENV RAILS_ENV=$RAILS_ENV
ENV RAILS_LOG_TO_STDOUT=1

RUN gem install bundler
RUN BUNDLE_FORCE_RUBY_PLATFORM=1 bundle install
RUN yarn install

# Run everything after as non-privileged user.
USER docker

# Start the main process.
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

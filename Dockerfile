FROM ruby:2.5.1-alpine

RUN bundle config --global frozen 1 \
  mkdir -p /app/tests \
  mkdir -p /app/homeworks

COPY .rubocop.yml Gemfile Gemfile.lock Rakefile /app/
COPY tests /app/tests
COPY homeworks /app/homeworks

WORKDIR /app

RUN bundle install

ENTRYPOINT ["bundle", "exec"]

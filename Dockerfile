FROM ruby:2.7.2-alpine

RUN apk update && apk add build-base postgresql-dev

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .

# COPY Gemfile  .
# RUN gem install bundler:2.1.4 && bundle install
# RUN gem install -g Gemfile


EXPOSE 9292

# ENTRYPOINT ["/bins/docker-entrypoint.sh"]

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "9292"]

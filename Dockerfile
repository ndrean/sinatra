FROM ruby:2.7.2-alpine AS base

RUN gem install bundler:2.1.4
RUN apk update && apk add build-base postgresql-dev curl net-tools bind-tools

WORKDIR /usr/app

# copies the /usr/local/bundle bundle directory from the ndrean/webapp:gem-cache image to our new image.
COPY --from=ndrean/webapp:gem-cache /usr/local/bundle /usr/local/bundle

COPY Gemfile*    ./
# we only install gems when the Gemfile changed
RUN bundle install && mkdir -p tmps/pids

COPY . .

# just a default fake value
ENV POSTGRES_URL=postgres://@pg/test

EXPOSE 9292

# ENTRYPOINT ["/bins/docker-entrypoint.sh"]

# the app will listen on the public interface of the container, 0.0.0.0, not on the localhost of the container !!
CMD ["bundle", "exec", "puma", "--config" ,"puma.rb"]

# below is OK but does only charges a default Puma
# CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "9292"] 

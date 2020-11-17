FROM ruby:2.7.2-alpine

RUN apk update && apk add build-base postgresql-dev

WORKDIR /app
# if I already bundled myself, then I copy the following files:
COPY Gemfile  ./
#Gemfile.lock

# RUN gem install sinatra  pg dotenv

# Run below if a Gemfile is provided (Sinatra & Rake)
RUN gem install bundler:2.1.4 && bundle install

COPY . .


EXPOSE 9292


CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "9292"]
# CMD [ "bundle", "exec", "Puma", "--c", "puma.rb", "--host", "0.0.0.0", "-p", "9292"]
# CMD ["dotenv", "./app.rb"]
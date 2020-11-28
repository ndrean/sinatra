ARG BASE_IMAGE=ruby:2.6.6
ARG CACHE_IMAGE=${BASE_IMAGE}

# Create a build stage for the gem cache
# Ensure that the /usr/local/bundle exists in case we use an empty image as cache
FROM ${CACHE_IMAGE} AS gem-cache
RUN mkdir -p /usr/local/bundle

# Create an intermediate image that has bundler installed
FROM $BASE_IMAGE AS base
RUN gem install bundler:2.1.4
WORKDIR /usr/app

# Copy the gems from a the gem-cache build stage, install missing gems and clean up
FROM base AS gems
COPY --from=gem-cache /usr/local/bundle /usr/local/bundle
COPY Gemfile* ./
RUN bundle install && bundle clean --force

# Copy the gems from the gems build stage and get the source code in place
FROM base AS final
COPY --from=gems /usr/local/bundle /usr/local/bundle
COPY ./ ./
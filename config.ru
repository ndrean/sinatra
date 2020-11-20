require 'rubygems'
require 'bundler'
require 'dotenv/load'

Bundler.require

require_relative './app'

# compressing the data :)
use Rack::Deflater

run App

# rackup will start the app server Puma
# and Sinatra will be loaded via Bundler.
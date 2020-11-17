require 'rubygems'
require 'bundler'
require 'dotenv/load'

Bundler.require

require './app'

use Rack::Deflater

run App

# starting the development server Puma with rackup,
# and Sinatra will be loaded via Bundler.
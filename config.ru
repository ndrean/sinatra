require 'rubygems'
require 'bundler'
# require 'dotenv/load'

Bundler.require

require './app.rb'
# File.expand_path('my_app', File.dirname(__FILE__))

# compressing the data :)
use Rack::Deflater

# rackup will start the app server Puma and Sinatra will be loaded via Bundler.
# we extend the Sinatra class so we need to call the class name in 'app.rb' (no Sinatra::Application)
run App 


require 'sinatra'
require 'erb'
require 'dotenv'
require 'sequel'
require 'logger'
require 'sinatra'
require 'pg'


Dotenv.load('.env')

# static files served in public
# set :public_folder, 'public'

set :bind, '0.0.0.0'
set :port, 9292

# the 'bundle exec rackup' needs class App<Sinatra, and then run 'bundle exec rackup' and navigate to port 9292
set :raise_errors, true

class App < Sinatra::Base
    db_conf = {
        adapter: :postgres,
        encoding: 'unicode',
        pool: 2,
        user: ENV.fetch('POSTGRES_USER'),
        password: ENV.fetch('POSTGRES_PASSWORD'),
        host: ENV.fetch('POSTGRES_HOST'),
        port: 5432,
        database: ENV.fetch('POSTGRES_DB'),
        max_connections: 10, 
        logger: Logger.new('/dev/stdout') # /log/db/log
    }.freeze
    
    DB = Sequel.connect(db_conf)

    get '/' do
        req = DB[:requests] #.delete to cleanup
        req.insert(
            ip: request.ip,   
            host: Socket.gethostname, 
            path: request.path_info,  
            requested_at: Time.now
        )
        str = File.dirname(__FILE__) +'/public'
        queries = req.reverse(:requested_at).limit(10)
        erb :index , locals: {  queries: queries, test: str.to_s }
    end
end

# File.open('log/requests.txt', 'a+') do |f|
#      f.puts("IP: #{query[:ip]}, Server: #{query[:server]}, URI: #{query[:path]}, Time: #{query[:time]}, URL: #{query[:url]}\n")
# end
# queries = DB.run("SELECT ip, path, host, requested_at FROM requests ORDER BY id DESC LIMIT 5;")        


# not use Rack => no class, just: get '/' { erb :index }, then "ruby App.rb" and go to port 4567

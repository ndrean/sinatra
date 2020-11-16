require 'sinatra'
require 'erb'
require 'dotenv'
require 'sequel'
require 'logger'
require 'sinatra'
require 'pg'
# require 'sinatra/activerecord'

# set :database, "postgres:project-name.sqlite3"

Dotenv.load('.env')

# default is already '/public' to serve static files
set :public_folder, File.dirname(__FILE__) + '/public'

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
        logger: Logger.new('log/db.log')
    }.freeze
    
    DB = Sequel.connect(db_conf)

    # connection = PG.connect(
    #     host: db_conf[:host],
    #     dbname: db_conf[:database],
    #     user: db_conf[:user],
    #     password: db_conf[:password]
    # )

    get '/' do
        result = {
            server: Socket.gethostname,
            time:   Time.now.strftime("%I:%M %S %L %p %d of %B, %Y"),
            ip:     request.ip,
            url:    request.url,
            path:   request.path_info}

        File.open('log/requests.txt', 'a+') do |f|
             f.puts("IP: #{result[:ip]}, Server: #{result[:server]}, URI: #{result[:path]}, Time: #{result[:time]}, URL: #{result[:url]}\n")
        end

        req = DB[:requests]
        req.insert(
            ip: result[:ip], 
            host: result[:server], 
            path: result[:path],  
            requested_at: result[:time]
        )

        erb :index, locals: { result: result }
    end
end


# Note: 
# we can also not use Rack, and no class App, just with: get '/' { erb :index }
# do ruby App.rb and this launches a webserver and we navigate to port 4567
# with Puma (gem installed), do 'ruby app.rb -s Puma' also with get '/' { erb :index }
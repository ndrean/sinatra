# All the following 
# require 'sinatra'
# require 'erb'
# require 'dotenv'
# require 'pg'
# require 'sequel' 
# using the C library "sequel_pg" that overrides Ruby's implementation

require 'logger'

# Dotenv.load('.env')

set :raise_errors, true
class App < Sinatra::Base

    DB = Sequel.connect(
            ENV.fetch("POSTGRES_URL"),
            logger: Logger.new('/dev/stdout')
        )
    table = DB[:requests].freeze

    get '/' do
        host = Socket.gethostname

        # # SEQUEL QUERIES
        table.insert(
            ip: request.ip,   
            host: host, 
            path: request.path_info,  
            requested_at: Time.now.strftime("%H:%M:%S:%L")
        )

        # test inline SQL / Sequel: aggregating by count
        # hits = table.with_sql("
        #     SELECT host, COUNT(*) AS count 
        #     FROM requests           
        #     GROUP BY host
        #     ORDER BY count DESC 
        #     ")
        
        erb :index , locals: {  
            queries: table.reverse(:requested_at).limit(6),
            active: host,
            figures: table.group_and_count(:host),
            counts: table.count 
        }
    end

    get '/clean' do
        table.delete
        redirect env['HTTP_REFERER']
    end

    # Count number of active containers: needed unix socket connection with Docker daemon
    # get '/count' do
        # result = %x(curl --unix-socket /var/run/docker.sock http://localhost/v1.40/containers/json)
        # JSON.parse(result).length.to_s
        # redirect home
    # end

end
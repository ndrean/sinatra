require 'sinatra'
# require 'sinatra/json'
require 'json'
require 'erb'
require 'dotenv'

require 'pg'
require 'sequel' 
# using the C library "sequel_pg" that overrides Ruby's implementation

require 'logger'
require 'sinatra'

Dotenv.load('.env')

# set :json_encoder, :to_json
# set :json_content_type, :json

set :raise_errors, true
class App < Sinatra::Base
    DB = Sequel.connect(
            ENV.fetch("POSTGRES_URL"),
            logger: Logger.new('/dev/stdout')
        )
    req = DB[:requests]
    servers=[]
    
    # Count number of active containers: needed unix socket connection with Docker daemon
    # get '/count' do
        # result = %x(curl --unix-socket /var/run/docker.sock http://localhost/v1.40/containers/json)
        # JSON.parse(result).length.to_s
        # redirect home
    # end

    get '/' do
        host = Socket.gethostname
        req.insert(
            ip: request.ip,   
            host: host, 
            path: request.path_info,  
            requested_at: Time.now.strftime("%H:%M:%S:%L")
        )
        
        hits_per_server = req.group_and_count(:host)
        counts = req.count
        
        erb :index , locals: {  
            queries: req.reverse(:requested_at).limit(8),
            # servers: servers ,
            active: host,
            figures: hits_per_server,
            counts: counts 
        }
    end

    get '/clean' do
         DB[:requests].delete
        redirect env['HTTP_REFERER']
    end

end
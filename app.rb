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

    
    # Count number of active containers: needed unix socket connection with Docker daemon
    # get '/count' do
        # result = %x(curl --unix-socket /var/run/docker.sock http://localhost/v1.40/containers/json)
        # JSON.parse(result).length.to_s
        # redirect home
    # end

    get '/' do
        req.insert(
            ip: request.ip,   
            host: Socket.gethostname, 
            path: request.path_info,  
            requested_at: Time.now
        )
        erb :index , locals: {  queries: req.reverse(:requested_at).limit(8), server: Socket.gethostname  }
    end

    delete '/clean  ' do
         DB[:requests].delete
        redirect env['HTTP_REFERER']
    end

end
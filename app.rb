require 'sinatra'
require 'erb'
require 'dotenv'

require 'pg'
require 'sequel' 
# using the C library "sequel_pg" that overrides Ruby's implementation

require 'logger'
require 'sinatra'

Dotenv.load('.env')

set :raise_errors, true
class App < Sinatra::Base
    DB = Sequel.connect(
            ENV.fetch("POSTGRES_URL"),
            logger: Logger.new('/dev/stdout')
        )
    req = DB[:requests]

    get '/' do
        req.insert(
            ip: request.ip,   
            host: Socket.gethostname, 
            path: request.path_info,  
            requested_at: Time.now
        )
        erb :index , locals: {  queries: req.reverse(:requested_at).limit(8) }
    end

    get '/clean' do
         DB[:requests].delete
         redirect '/'
        # erb :index , locals: {  queries: req.reverse(:requested_at).limit(8) }
    end

end
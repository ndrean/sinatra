workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['THREAD_COUNT'] || 5)
threads threads_count, threads_count

rackup      DefaultRackup

port        ENV.fetch('PORT')     || 9292
environment ENV.fetch('RACK_ENV') || 'development'

# pidfile ENV.fetch("PIDFILE") { "/tmp/web_server.pid" }
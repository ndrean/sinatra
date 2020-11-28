# workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['THREAD_COUNT'] || 8)
threads threads_count, threads_count

# preload_app! # if workers

app_dir = File.expand_path(".", __dir__)

rackup      "#{app_dir}/config.ru" # DefaultRackup

# bind        "unix://#{app_dir}/tmp/sockets/nginx.socket" # couldn't make it work
port        ENV.fetch('PORT')  { 9292 }

environment ENV.fetch('RACK_ENV') { "development" }

pidfile     "#{app_dir}/tmp/pids/web_server.pid"
# Nginx config on Docker to serve multiple containerized apps

```bash
  proxy_cache_path /var/cache/nginx/mycache levels=1:2 keys_zone=mycache:1m inactive=10m;


  # mapping between file type and expires length for browser caching;
  map $sent_http_content_type $expires {
      default                    off;
      text/html                  epoch;
      text/css                   max;
      application/javascript     max;
      ~image/                    max;
  }

  log_format my_log ' "Request: $Request, Status: $status, Request_uri: $request_uri, Host: $host, Host: $upstream, Client_IP: $remote_addr, Proxy_IP: $proxy_add_x_forwarded_for, Proxy_Hostname: $proxy_host, Real_IP: $http_x_real_ip, Cache_Status: $upstream_cache_status  "';
  # check tail -f access.log

  server {
    server_name webapp.me*; # file /etc/hosts modified & <- if SSL
    listen 8080  default_server;

    access_log /var/log/nginx/access.log my_log; #<- to watch logs

    set $upstream $PROXY_UPSTREAM;

    proxy_set_header  Host            $upstream;  # $http_host needed for Rails ??
    proxy_set_header Connection       "";
    proxy_set_header  X-Real-IP       $remote_addr; # client IP adress
    proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;

    # configure a resolver for Nginx with the address of your actual DNS resolver.
    resolver 127.0.0.11:53  valid=1s; # <- Docker network DNS resolver

    expires   $expires;       # reading the mapping file/$expires

    # Proxy-caching by Nginx
    proxy_cache       mycache;
    proxy_cache_valid 60m;
    add_header        X-Proxy-Cache $upstream_cache_status;
    proxy_cache_key   $scheme$request_method$host$request_uri;

    location ~ \.(jpeg|css|png|js|webp|ico)$ {
      # since we run nginx in a separate container from the app, then we need to copy
      # the static files into the nginx container. We do this with a bind, and tthe files
      # are located in the folder below.
      root /usr/share/nginx/html;

      # return 200 http://webapp:8080$uri; # testing..

      # gzip_static on;
      access_log off;
      add_header Cache-Control public;
      add_header Last-Modified "";
      add_header ETag "";

      break;
    }

    # any other request not found by the regex and starting with '/' will be served by @app
    location / {
      # proxy_pass http://webapp;   <- if 'upstream directive as can't pass env var'
      proxy_pass http://$upstream; #$request_uri; # $request_uri; <- revers proxying

      gzip_static on;
      proxy_pass_header Authorization;
      proxy_http_version 1.1;
      proxy_ssl_server_name on;

      proxy_buffering       off;
      proxy_read_timeout    5s;
      proxy_redirect        off;
      proxy_ssl_verify      off;
      client_max_body_size  0;
    }
  }

```

# Postgres & ORM Sequel

gem 'pg'
gem 'sequel'
gem 'gem 'sequel_pg', :require=>'sequel'
(no require)

1. Create database
   `>: psql createdb test`

2. Create USER/PWD
   `>: psql create ...`

3. Create table
   Run a SQL script

4. Connect ot the database
   Sequel.connect(\$POSTGRES_URL)

5. Create model

```ruby
class Owner < Sequel::Model
  one_to_many :dogs

  def validate
    super
    errors.add(:name, "must be present") if name.empty?
  end
end
```

6. Migration

```ruby
Sequel.migration do
  change do
    create_table(:dogs) do
      primary_key :id
      String :ip, :null => false
      ...
    end
  end
end
```

and run: `sequel [path/to/migrate-file] postgres://[host]/[db-name]``
For example:

```sh
> sequel -m /db/migrates/ postgres://localhost/test
```

7. Seeding
   With the gem `sequel-seed`, we do:

```ruby
Sequel.seed do
    def run
        ['123.123.123','/', 2020-11-01],
        ['127.0.0.1','/',2020-11-02]
        .each do |ip, path, requested_at|
            Request.create(ip: ip, path: path, requested_at: requested_at )
        end
    end
end
```

we can do in the app:

```ruby
require 'sequel/extensions/seed'
Sequel.extension :seed

Sequel::Seeder.apply(DB,"db/seeds")
```

# Useful commands

> crop images and change format with Imagemagick

`magick convert puma.jpeg -resize 180x180! puma.webp`

> Sinatra console (IRB)

`bundle exec irb -I. -r app.rb`

> find file by name

`ls / f -name puma.rb`
=> /usr/local/bin/puma

> find directory by name

`ls / -type d -name bundle`

> find all directories in current directory

`ls . -type d`

> create several subdir with '-p' in one go)

`mkdir -p tmp/{pids,sockets}`

> count number of lines

- List all Docker processes with:
- `docker ps -q |wc -l` ('-q' is the get the process id, and '|wc' is 'Word Count)
- List all TCP connections with `netstat -t`

# Dotenv with Sinatra (or Rack based apps)

<https://github.com/bkeepers/dotenv>

We pass environment variables to **Sinatra** via the `.env` file and the `Dotenv` gem. It shuold be loaded as early as possible in the `Rakefile`. It loads by default `.env`:

```ruby
#Rakefile
require 'dotenv'
Dotenv.load('.env')
```

Then we can get the variables with `ENV['PORT']` or better `ENV.fetch('PORT') { 9292 }` since this fraises an exception if not present. We also yield a default value.

# Config Sinatra / Puma / Rack

We extend the class `Sinatra::Base` with a class `App < Sinatra::Base` so we need to pass the class to `run App`.

Since we use **bundler**, we need a `config.ru` for `rackup` since Rack launchs with `rackup config.ru`. The location of the "DefaultRackup`is found with`File.expand_path(".",**dir**)` (try this in IRB).

Then we can start the app in the Dockerfile with `bundle exec Puma -C puma.rb` where 'puma.rb' is Puma's config file.

<https://medium.com/@theterminalguy/using-bundler-with-sinatra-e194c3422c6a>

# .dockerignore

To avoid to copy files into the container such as /tmp/pids/, you exclude them by putting into the dockerignore.

# Docker-compose

`docker-compose up --build`
`docker-compose down`
Open a container for exploration during execution:
`docker-compose exec webapp sh`
Scale up:
`docker-compose up --scale webapp=2``

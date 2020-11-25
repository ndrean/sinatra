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

`magick (or convert) puma.jpeg -resize 180x180! puma.webp`

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

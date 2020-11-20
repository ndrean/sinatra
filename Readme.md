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

<script>
         document.getElementById('restart').onclick = document.location.reload();
    </script>

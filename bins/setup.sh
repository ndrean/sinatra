docker-compose up -d pg

echo "Setting up the development database"
docker-compose run --rm -e WAIT_FOR_PG=true app bundle exec rake db:create db:migrate

# echo "Setting up the test database"
# docker-compose run --rm -e RACK_ENV=test app bundle exec rake db:create db:migrate
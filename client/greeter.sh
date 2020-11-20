#!/usr/bin/env bash

result=$(docker-compose exec pg psql -d test -U myuser -c "select * from requests order by requested_at limit 5;")

$result > rest.txt

main() {
    while IFS= read -r line
    do
        echo "$line"
    done < "$result"
}
main "$@"



# AMS Cache test

## Running the services

`docker-compose up -d`

That command will run: 
* Postgresql:5432
* Redis:6379
* Redis-commander:8085

### Running rails

1. `rails db:create`
2. `rails db:migrate && rails db:seed`
3. `rails server`
4. To get a user record run `curl -X GET localhost:3000/users/1`

Checking Posgtgres logs

`docker-compose logs -f db 2>&1 | grep execute`





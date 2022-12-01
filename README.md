# JobSeeker

## Description
Hands-on test for Ruby on Rails developer
## Config .env
rename .env_sample to .env
## Config the setup
```sh
docker-compose build
```
```sh
docker-compose up
```
## Enter container
```sh
docker exec -it job_seeker bash
```
## Create Database, migrate and populate database
after enter in container

command below will create, migrate and populate the data
```sh
./bin/initialize_setup.sh
```
## Run test, rubocop and generate swagger docs
```sh
bundle exec brakeman
bundle exec rspec
bundle exec rubocop
bundle exec rails rswag
```
## Run app
```sh
bundle exec rails s -b 0.0.0.0
```
## Features

Application http://localhost:3000


### for more endpoint information
Documentation http://localhost:3000/api-docs




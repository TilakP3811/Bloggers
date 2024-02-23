APP = docker-compose run --rm app bash -c

env-setup :
	cp .env.example .env
	touch ~/.pry_history

build :
	docker-compose build

build-no-cache :
	docker-compose build --no-cache

db-start :
	docker-compose up -d db

install :
	${APP} "bundle install"

yarn-install :
	docker-compose run --rm --no-deps app bash -c "yarn install"

db-clean :
	${APP} "bundle exec rake db:drop"

db-setup :
	${APP} "bundle exec rake db:create db:schema:load"

db-initialize :
	${APP} "bundle exec rake db:migrate db:seed"

first-run: env-setup build yarn-install db-start db-clean db-setup db-initialize

sh :
	${APP} "bash"

console :
	${APP} "rails c"

db-console :
	${APP} "rails db"

server :
	docker-compose run -p 3000:3000 --rm app

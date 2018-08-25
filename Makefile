
build:
	docker-compose build

clean: stop
	docker-compose rm -f

shell:
	docker-compose run web bash

redis-cli:
	docker-compose run redis redis-cli -h redis

start:
	docker-compose up

stop:
	docker-compose down
	docker-compose stop

kill:
	@lsof -i :8080 | awk '{print $$2}' | tail -n +2 | xargs kill -9
	@rm -rf logs && rm -f *.pid

secret:
	@python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"

.PHONY: build run clean migrate shell redis-cli start stop kill secret

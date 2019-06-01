DOCKER-COMPOSE=sudo docker-compose
DOCKER-RUN=$(DOCKER-COMPOSE) run --service-ports --rm

help:
	# MAKEFILE TARGETS:
	#
	# "front" runs Front-end ReactJS development server
	# "front-test" runs tests for Front-end ^^
	#
	# "back" runs the Back-end Node server
	# "back-test" runs tests for Back-end ^^
	#
	# "stack" runs both Front- and Back-end in one Node instance
	#
	# "redis-cli" runs the redis command-line client
	#
	# "clean" spins down all docker instances
	#
	# "help" this help text
	#

front:
	$(DOCKER-RUN) node-base npm run start
front-test:
	$(DOCKER-RUN) node-base npm run test

back:
	$(DOCKER-RUN) node-needs-redis npm run server
back-test:
	$(DOCKER-RUN) node-needs-redis npm run server-test

stack:
	$(DOCKER-RUN) node-needs-redis npm run dev

redis-cli:
	$(DOCKER-RUN) redis-cli

clean:
	sudo docker-compose down


.PHONY: start server dev clean help

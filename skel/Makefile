DOCKER-COMPOSE=sudo docker-compose
DOCKER-RUN=$(DOCKER-COMPOSE) run --service-ports --rm

start:
	$(DOCKER-RUN) node_start
server:
	$(DOCKER-RUN) node_server
dev:
	$(DOCKER-RUN) node_dev

clean:
	sudo docker-compose down

help:
	# "start" runs the ReactJS development front-end server
	# "server" runs the Node server
	# "dev" runs both simultaneously
	# "clean" spins down all docker instances

.PHONY: start server dev clean help

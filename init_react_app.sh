#!/usr/bin/env bash

set -e

# provide Visual Cues to contrast with the output of "npm init/install"
bold=$(tput bold)
normal=$(tput sgr0)
section_title() {
	echo -e "\n\n==========================================================\n"
	echo "==>${bold} $* ${normal}"
	echo ""
}

exec_cmd() {
	section_title $*
	$*
}

echo -n "Enter project name (no capitals, no spaces): "
read APP_NAME


cat > bootstrap_docker-compose.yaml << EndSnippet
version: '2'

services:

  node-base:
    image: node:12
    user: 'node'
    working_dir: /home/node/app
    volumes:
      - ./:/home/node/app

EndSnippet

# DOCKER-RUN: npm init react-app ${APP_NAME}
exec_cmd sudo docker-compose \
	-f bootstrap_docker-compose.yaml \
	run --rm \
	node-base npm init react-app ${APP_NAME}

# DOCKER-RUN: npm install --save-dev ..."
#   inspired by: https://www.twilio.com/blog/react-app-with-node-js-server-proxy
exec_cmd sudo docker-compose \
	-f bootstrap_docker-compose.yaml \
	run --rm \
	--workdir="/home/node/app/${APP_NAME}" \
	node-base npm install --save-dev \
	express body-parser node-env-run nodemon npm-run-all express-pino-logger pino-colada \
	redis \
	chai chai-http mocha

section_title Patch package.json
mv ${APP_NAME}/package.json package.json.orig
cat package.json.orig \
	| sed 's#"start": "react-scripts start"#"start": "react-scripts start",\n    "server": "node-env-run server --exec nodemon \| pino-colada",\n    "server-test": "mocha --watch",\n    "dev": "run-p server start"#g' \
	| sed 's#"scripts": {#"proxy": "http://localhost:3001",\n  "scripts": {#g' \
	| tee ${APP_NAME}/package.json

section_title Patch GIT-ignore
echo -e "\nredis_persistence/" >> ${APP_NAME}/.gitignore

# COPY Docker files
exec_cmd cp -r skel/* ${APP_NAME}/
exec_cmd touch ${APP_NAME}/.env

section_title "Cleaning up..."

# Cleanup
exec_cmd rm bootstrap_docker-compose.yaml package.json.orig

section_title "Done"

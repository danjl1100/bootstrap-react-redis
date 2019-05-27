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

echo "APP_NAME=${APP_NAME}" > .env


cat > bootstrap_docker-compose.yaml << EndSnippet
version: '2'

services:

  node_base:
    image: node:12
    user: 'node'
    working_dir: /home/node/app
    volumes:
      - ./:/home/node/app

  bootstrap_init_react:
    extends: node_base
    command: "npm init react-app ${APP_NAME}"

  bootstrap_install_deps:
    extends: node_base
    working_dir: /home/node/app/${APP_NAME}
    command: "npm install --save-dev express body-parser node-env-run nodemon npm-run-all express-pino-logger pino-colada redis"
EndSnippet

# DOCKER-RUN: npm init react-app ${APP_NAME}
exec_cmd sudo docker-compose \
	-f bootstrap_docker-compose.yaml \
	run --rm \
	bootstrap_init_react

# DOCKER-RUN: npm install --save-dev ..."
#   inspired by: https://www.twilio.com/blog/react-app-with-node-js-server-proxy
exec_cmd sudo docker-compose \
	-f bootstrap_docker-compose.yaml \
	run --rm \
	bootstrap_install_deps

section_title Patch package.json
mv ${APP_NAME}/package.json package.json.orig
cat package.json.orig \
	| sed 's#"start": "react-scripts start"#"start": "react-scripts start",\n    "server": "node-env-run server --exec nodemon \| pino-colada",\n    "dev": "run-p server start"#g' \
	| sed 's#"scripts": {#"proxy": "http://localhost:3001",\n  "scripts": {#g' \
	| tee ${APP_NAME}/package.json

section_title Patch GIT-ignore
echo -e "\nredis_persistence/" >> ${APP_NAME}/.gitignore

# COPY Docker files
exec_cmd cp -r skel/* ${APP_NAME}/
exec_cmd touch ${APP_NAME}/.env

section_title "Done"

# Cleanup
echo "Press enter to cleanup..."
read a
exec_cmd rm .env bootstrap_docker-compose.yaml package.json.orig

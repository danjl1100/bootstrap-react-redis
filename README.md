# bootstrap-react-redis

Creates docker-compose project environments with a web app development stack: [ReactJS](https://reactjs.org/) on the front end,  [Node](https://nodejs.org/) express server backend, [Redis](https://redis.io/) server, and tests for both the front- and back-ends.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development purposes.

### Prerequisites

Install [Docker](https://docs.docker.com/install/), and [Docker Compose](https://docs.docker.com/compose/install/) on your development machine.
You may need sudo/root rights to run docker commands (see [here](https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user)).

Double check that your Docker and Docker Compose installations are working:

```
docker version
  ...
docker-compose version
  ...
```

### Creating Projects

Clone this repo if you haven't already.

```
git clone https://github.com/danjl1100/bootstrap-react-redis.git
```

Run the create script.

```
cd bootstrap-react-redis
./create-project.sh
  ...
```

Enter the name of your new project, and let the script do the rest!

```
Enter project name (no capitals, no spaces): my-cool-app
```

Move the newly-created project to the desired location
```
mv my-cool-app ~/projects/
```

Finally, check out the available commands in the `Makefile`.
```
cd ~/projects/my-cool-app
make help
  ...
```

## License

This project is licensed under the GPL3 License - see the [COPYING](COPYING) file for details.

## Acknowledgments

The following sources greatly helped with creating this project.
* [Twillo Tutorial](https://www.twilio.com/blog/react-app-with-node-js-server-proxy) on server proxy integration with ReactJS
* [Hacker Noon Tutorial](https://hackernoon.com/a-better-way-to-develop-node-js-with-docker-cd29d3a0093) on using Docker Compose to run Node scripts

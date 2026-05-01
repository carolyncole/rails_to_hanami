# hanami-to-rails
Backing code for a workshop in how to convert a Rails application over to a Hanami application

## dependencies
This workshop depends on having a docker engine on your machine.  You can install docker locally by [downloading the appropriate installer.](https://docs.docker.com/desktop/#next-steps) 

## Setup docker container

Build the docker image by running 
```
docker build -t rails2hanami .
```

Start a container using the new image by running
```
docker run -it --name rails2hanami --publish 3001:3000 rails2hanami
```

### Additional commands

restart the container by running
```
docker start rails2hanami
```

open a shell on the container
```
docker exec -it rails2hanami bash
```

remove the built docker container
```
docker rm rails2hanami
```

### Testing container

To make sure your container is setup correctly run.  All examples should pass.
```
docker exec -it rails2hanami bundle exec rspec
```
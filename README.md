# Rails to Hanami
Backing code for a workshop in how to convert a Rails application over to a Hanami application

## Dependencies
This workshop depends on having a docker engine on your machine.  You can install docker locally by [downloading the appropriate installer.](https://docs.docker.com/desktop/#next-steps) 

## Setup Docker Container

Build the docker image by running 
```
docker build -t rails2hanami .
```

Start a container using the new image by running
```
docker run -it --name rails2hanami --publish 3001:3000 --publish 2301:2300 --volume .:/usr/src/app rails2hanami
```

### Testing the Container

To make sure your container is setup correctly run.  All examples should pass.
```
docker exec -it rails2hanami bundle exec rails db:migrate
docker exec -it rails2hanami bundle exec rspec
```

## Additional Docker Commands

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

#### Clean Up (this is destructive)
Clean up docker completely to start entirely over.  This will impact your entire docker setup
```
docker system prune -a
```

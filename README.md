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
docker run -it --name rails2hanami --publish 3001:3000 --publish 2301:2300 --volume .:/usr/src/app rails2hanami
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
docker exec -it rails2hanami bundle exec rails db:migrate
docker exec -it rails2hanami bundle exec rspec
```

### running the Hanami server
```
docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec bundle install
docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec npm install
docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec bundle exec hanami assets compile
docker exec -w /usr/src/app/bookshelf -it rails2hanami bundle exec hanami dev
```

visit Hanami the site at http://localhost:2301/  
# hanami-to-rails
Backing code for a workshop in how to convert a Rails application over to a Hanami application


Build the docker image by running 
```
docker build -t rails2hanami .
```

Start a container using the new image by running
```
docker run -it --name rails2hanami --publish 3001:3000 rails2hanami
```

restart the container by running
```
docker start rails2hanami
```

open a shell on the container
```
docker exec -it rails2hanami sh
```
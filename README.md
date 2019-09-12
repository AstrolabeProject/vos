## Astrolabe Virtual Observatory Server

This is a public code repository of the [Astrolabe Project](http://astrolabe.arizona.edu/) at the [University of Arizona](http://www.arizona.edu).

Author: [Tom Hicks](https://github.com/hickst)

Purpose: This is an Integration project which documents, coordinates, and administers the separate containerized components of the Astrolabe Virtual Observatory Server.

## Installation

***Note**: Installation of the Astrolabe VO Server requires a working Docker installation, version 18.06 or greater, and **Docker  must  be running in swarm mode** (instructions below).*

### Enable Docker swarm mode

The containers which make up the Astrolabe VO Server are orchestrated by running Docker in "swarm" mode. Swarm mode is not enabled by default. To enable swarm mode in your running Docker engine, open a shell window and type:
```
   > docker swarm init
```

After a minute or so, you may verify that swarm mode is enabled:
```
   > docker info | grep Swarm
```

You should see a response like this:
```
Swarm: active
```

### Prepare the local deployment directory

In this initial version of the VO Server, all data and images reside on your local host machine. To setup the server, you must first create the data and link to the images. **The data directory and images links must be created  in the working directory for this project** (i.e. the directory into which you checked out this project):
```
    > ln -s /path/to/directory/containing/your/images ./images
```

### Deploy the VO Server

To deploy the Astrolabe VO Server use the Docker `stack deploy` command:
```
    > docker stack deploy -c docker-compose.yml vos
```
and then wait a few minutes for the VO Server containers to initialize.

## TBD: RELOAD

### Access the VO Server

If deployment was successful, you will be able to access the VO Server and the Firefly viewer from within a browser on your local machine:

Access the VO Server at [http://localhost:8080/dals/](http://localhost:8080/dals/)
Access the Firefly viewer at [http://localhost:8888/firefly](http://localhost:8888/firefly)


## License

Software licensed under Apache License Version 2.0. 

Copyright (c) The University of Arizona, 2019. All rights reserved.

This README file was composed with the online tool [StackEdit](https://stackedit.io/).


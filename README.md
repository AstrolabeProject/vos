
## Astrolabe Virtual Observatory Server

This is a public code repository of the [Astrolabe Project](http://astrolabe.arizona.edu/) at the [University of Arizona](http://www.arizona.edu).

Author: [Tom Hicks](https://github.com/hickst)

**Purpose**: This is an Integration project which documents, coordinates, and administers the separate containerized components of the Astrolabe Virtual Observatory Server.

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

In this initial version of the VO Server, all data and images reside on your local host machine. To setup the server, you must first create the data and link to the images. **The data directory and images links must be created  in the working directory for this project** (i.e. the directory into which you checked out this project).

Create a link (named `images`) to an existing directory of JWST images and catalogs on your local disk:
```
    > ln -s path/to/directory/containing/your/images images
```


#### 

### Start and stop the VO Server

To run the Astrolabe VO Server use the Docker `stack deploy` command:
```
    > docker stack deploy -c docker-compose.yml vos
```
and then wait a few minutes for the VO Server containers to initialize.

## TBD: RELOAD

## Access the VO Server

If deployment was successful, you will be able to access the VO Server and the Firefly viewer from within a browser on your local machine:

 - Access the VO Server at [http://localhost:8080/dals/](http://localhost:8080/dals/)  
  - Access the Firefly viewer at [http://localhost:8888/firefly](http://localhost:8888/firefly)

### Access URLs

The Astrolabe VO Server provides endpoints for data and image metadata retrieval via SCS (Simple Cone Search), SIA (Simple Image Access), and TAP (Table Access Protocol). The following URLs may be used by **local** VO clients (since this is, currently, only a local server):

 - SCS for JWST image metadata: http://vos:8080/dals/scs-jwst
 - SCS for the JWST catalog: http://vos:8080/dals/scs-jcat
 - SIA for JWST image metadata: http://vos:8080/dals/sia-jwst
 - TAP for JWST catalog and image metadata: http://vos:8080/dals/tap-jwst

## License

Software licensed under Apache License Version 2.0. 

Copyright (c) The University of Arizona, 2019. All rights reserved.

This README file was composed with the online tool [StackEdit](https://stackedit.io/).


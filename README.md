
## Astrolabe Virtual Observatory Server

This is a public code repository of the [Astrolabe Project](http://astrolabe.arizona.edu/) at the [University of Arizona](http://www.arizona.edu).

**Author**: [Tom Hicks](https://github.com/hickst)

**Purpose**: This is an Integration project which documents, coordinates, and administers the separate containerized components of the Astrolabe Virtual Observatory Server.

## Installation

***Note**: Installation of the Astrolabe VO Server requires a working Docker installation, version 19.03 or greater, and **Docker must be running in swarm mode** (instructions below).*

### 1. Checkout this project

Git `clone` this project to your local disk and enter the project directory:
```
  > git clone https://github.com/AstrolabeProject/vos.git
  > cd vos
```

### 2. Enable Docker swarm mode

The containers which make up the Astrolabe VO Server are orchestrated by running Docker in "swarm" mode. Swarm mode is not enabled by default. To enable swarm mode in your running Docker engine, open a shell window and type:
```
 > docker swarm init
```

After a few seconds, you may verify that swarm mode is enabled:
```
 > docker info | grep Swarm
```

If swarm mode is enabled, you should see a positive response like this:
```
Swarm: active
```

### 3. Prepare the deployment

In this initial version of the VO Server, all data and images reside on your local host machine. To set up the server, you must create a directory containing your images, or link to an existing one. **The image directory (or link) must be created in the working directory for this project** (i.e. the directory into which you checked out this project).

To create a link (which must be named "*images*") to an existing directory of JWST images and catalogs on your local disk:
```
  > ln -s path/to/directory/of/your/JWST/fits/files images
```

### 4. Start the VO Server

To run the Astrolabe VO Server use the `docker stack deploy` command:
```
  > docker stack deploy -c docker-compose.yml vos
```
OR, if you are familiar with `Make`, use the convenient Makefile:
```
  > make up
```
and then wait for the VO Server containers to initialize, which **may take several minutes** as the containers must be downloaded (the first time only) and started.

You can use common Docker commands to monitor the status of the VO Server containers. The `docker service` command shows whether all five VO Server containers have been instantiated:
```
  > docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE                           PORTS
1m841e7liokk        vos_celery          replicated          1/1                 astrolabe/cuts:latest
v59tayb4v5n0        vos_cuts            replicated          1/1                 astrolabe/cuts:latest    *:8000->8000/tcp
7lxjg8h50l0c        vos_pgdb            replicated          1/1                 astrolabe/vosdb:latest   *:5432->5432/tcp
dab3jzqf032d        vos_redis           replicated          1/1                 redis:5.0-alpine         *:6379->6379/tcp
zbynaauuna18        vos_vos             replicated          1/1                 astrolabe/dals:latest    *:8080->8080/tcp
```
The VO Server will be ready when the `REPLICAS` column shows 1/1 for all five VO Server containers.

The `docker container` command is also useful to view the status of the VO Server containers:
```
  > docker container ls -a
    CONTAINER ID        IMAGE                           COMMAND                  CREATED             STATUS              PORTS                NAMES
7138a0f4ab88        astrolabe/dals:latest    "catalina.sh run"        2 hours ago         Up 2 hours          8080/tcp             vos_vos.1.qiwaa1vf8uoj4dpab5hovakxp
4c63d1668481        astrolabe/cuts:latest    "gunicorn -c /cuts/c…"   2 hours ago         Up 2 hours                               vos_cuts.1.v8w6gs1rjo1jecu64xbov41qs
e2a970bfa0b4        astrolabe/cuts:latest    "celery worker -l de…"   2 hours ago         Up 2 hours                               vos_celery.1.sdiia00iapiwyxdu6cvlubsar
59008932fd1f        astrolabe/vosdb:latest   "docker-entrypoint.s…"   2 hours ago         Up 2 hours          5432/tcp             vos_pgdb.1.h7petbeck29mf39stnoye8cip
6b970370405f        redis:5.0-alpine         "docker-entrypoint.s…"   2 hours ago         Up 2 hours          6379/tcp             vos_redis.1.x5n2ngphgyzxs87etrideb5sl
```
The `STATUS` column (to the right) should eventually show "Up" for all five VO Server containers.


### 5. Load a JWST catalog, extract and load metadata from FITS files

***Note**: you only have to extract and load the data into the VO Server **once**; when you first install it. Docker will retain the data in a local database between runs of the VO Server.*

If you have not already done so previously, you can now load the VO Server with a JWST catalog and image metadata, extracted from the JWST FITS files which reside on your hard disk.

The extraction and loading program is called FFP (for FITS File Processor) and is available as another Astrolabe Docker container. To download the FFP program:
```
  > docker pull astrolabe/ffp
```
***Note**: you only have to do this `pull` step **once** for it to reside on your local machine.*

To run the FFP program, make sure that the VO Server is running (Step 4 above) and then call `make` to extract and load the data from the `images` subdirectory of your current directory:
```
  > make loadData
```
***Note**: Loading compressed (gzipped) JWST FITS images take about 15 seconds per image (compared to about 1/4 second each when uncompressed). The JWST catalog takes about 5 minutes to process, so please be patient.*


## Access the VO Server

If deployment was successful, you will be able to access the VO Server from within a browser on your local machine:

  - Access the VO Server at [http://localhost:8080/dals/](http://localhost:8080/dals/)

More commonly, however, you will probably want to access the VO Server from the [Astrolabe customized version of Firefly](https://github.com/AstrolabeProject/firefly-al). Please refer to that project for instructions on how to start a Firefly viewer which connects to your running VO Server.

### Access URLs

The Astrolabe VO Server provides endpoints for data and image metadata retrieval via SCS (Simple Cone Search), SIA (Simple Image Access), and TAP (Table Access Protocol). The following URLs may be used by **local VO clients** (since this is, currently, only a local server):

 - SCS for JWST image metadata: http://localhost:8080/dals/scs-jwst
 - SCS for the JWST catalog: http://localhost:8080/dals/scs-jcat
 - SIA for JWST image metadata: http://localhost:8080/dals/sia-jwst
 - TAP for JWST catalog and image metadata: http://localhost:8080/dals/tap-jwst

### Stopping the VO Server

***Note**: If you have also started an [Astrolabe customized version of Firefly](https://github.com/AstrolabeProject/firefly-al), you must stop Firefly **before** stopping the VO Server.*

To stop the VO Server use the `docker stack rm` command:
```
  > docker stack rm vos
```
OR, if you are familiar with `Make`, use the convenient Makefile:
```
  > make down
```
The VO Server containers should stop within a minute or so. This can be monitored with the Docker commands given (above) in the Startup section.

## License

Software licensed under Apache License Version 2.0.

Copyright (c) The University of Arizona, 2019. All rights reserved.

This README file was composed with the online tool [StackEdit](https://stackedit.io/).

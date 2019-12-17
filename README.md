
## Astrolabe Virtual Observatory Server

This is a public code repository of the [Astrolabe Project](http://astrolabe.arizona.edu/) at the [University of Arizona](http://www.arizona.edu).

**Author**: [Tom Hicks](https://github.com/hickst)

**Purpose**: This is an Integration project which documents, coordinates, and administers the separate containerized components of the Astrolabe Virtual Observatory Server.

## Installation

***Note**: Installation of the Astrolabe VO Server requires a working Docker installation, version 18.09 or greater, and **Docker must be running in swarm mode** (instructions below).*

### 1. Checkout this project (ONCE)

Git `clone` this project to your local disk and enter the project directory:
```
  > git clone --branch onehost https://github.com/AstrolabeProject/vos.git
  > cd vos
```


### 2. Enable Docker swarm mode (ONCE)

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


### 3. Prepare the deployment (ONCE)

In this custom, standalone version of the VO Server, the database and all images reside on your local host machine. To set up the server, you must create a directory containing the JWST images, or link to an existing one. **The image directory (or link) must be created in the working directory for this project** (i.e. the directory into which you checked out this project).

To create a link (which must be named "*images*") to an existing directory of JWST images on your local disk:
```
  > ln -s path/to/directory/of/your/JWST/fits/files images
```


### 4. Download the Server software (ONCE)

To reduce the time necessary for the VO Server to start up, you should initially download the component containers. The VOS Makefile includes a command to do this:
```
  > make setup
```
***Note: it may take several minutes to download all the components**, so you probably have time to get a cup of coffee.*


### 5. Start the VO Server

Once the components have been downloaded to your local host, start the Astrolabe VO Server using `Make`:
```
  > make up
```
and then wait for the VO Server containers to initialize.

You can use common Docker commands to monitor the status of the VO Server containers:

The `docker service` command shows whether all five VO Server containers have been instantiated:
```
  > docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
mc6fuwfnibbg        vos_celery          replicated          1/1                 cuts:devel
5cz497paw1pd        vos_cuts            replicated          1/1                 cuts:devel          *:8000->8000/tcp
lsncxzizxs5w        vos_dals            replicated          1/1                 dals:1H             *:8080->8080/tcp
sehgkg8x8emq        vos_pgdb            replicated          1/1                 vosdb:devel         *:5432->5432/tcp
ethrhhbfgh7p        vos_redis           replicated          1/1                 redis:5.0-alpine    *:6379->6379/tcp
```
The VO Server will be ready when the `REPLICAS` column shows 1/1 for all five VO Server containers.

The `docker container` command is also useful to view the status of the VO Server containers:
```
  > docker container ls -a
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS               NAMES
d88d173dc2e5        cuts:devel          "gunicorn -c /cuts/c…"   54 seconds ago       Up 52 seconds                           vos_cuts.1.dks9tf4g5znd2iutsbvvcom46
edd722fe3de0        dals:1H             "catalina.sh run"        56 seconds ago       Up 53 seconds       8080/tcp            vos_dals.1.n2dd3d9mrlbh0s2dtjrfbk2j0
2b05df2f1017        cuts:devel          "celery worker -l de…"   57 seconds ago       Up 55 seconds                           vos_celery.1.vzfoa25qrv6y9b8nhtw5ws9oh
a9612421f3be        vosdb:devel         "docker-entrypoint.s…"   59 seconds ago       Up 56 seconds       5432/tcp            vos_pgdb.1.qycrcdbmmhi9sru0900khz1jg
7bdf34b62b46        redis:5.0-alpine    "docker-entrypoint.s…"   About a minute ago   Up 58 seconds       6379/tcp            vos_redis.1.ptx5v3snxr21f0ecyinaex73v
```
The `STATUS` column (to the right) should eventually show "Up" for all five VO Server containers.


### 6. Load a previously created database containing JWST catalogs and image data (ONCE)

***Note**: you only have to load the "canned" data into the VO Server database **once**; when you first install it. Docker will retain the data in the local database between runs of the VO Server.*

To load the pre-built database, make sure that the VO Server is running (Step 5 above) and then use `make` to download and install the database:
```
  > make loadData
```
***Note**: This step downloads a 160+ megabyte file and installs it. Depending on your internet connection, this could take a couple minutes. You should see a progress bar during the download, then a bunch of database loading commands (which you can ignore).*


## Access the VO Server and Image/Cutout Server

If deployment was successful, you will be able to access the VO and Image/Cutout servers from within a browser on your local machine:

  - Access the VO Server at [http://localhost:8080/dals/](http://localhost:8080/dals/)
  - Access the Image/Cutout Server at [http://localhost:8000/](http://localhost:8000/)

Much more commonly, however, you will want to access the VO and Image/Cutout servers from client software which has been customized to recognize these servers. In this release, we provide customized versions of Firefly and JupyterLab notebook.


### Using the Astrolabe-customized version of Firefly

For instructions on starting, stopping, and using the Astrolabe-customized version of Firefly, please see the [Firefly-AL document](https://github.com/AstrolabeProject/vos/blob/onehost/docs/Firefly-AL.md).


### Using the Astrolabe-customized version of JupyterLab notebook

For instructions on starting, stopping, and using the Astrolabe-customized version of JupyterLab notebook, please see the [JupAL document](https://github.com/AstrolabeProject/vos/blob/onehost/docs/JupAL.md).


### Access URLs

The Astrolabe VO Server provides endpoints for data and image metadata retrieval via SCS (Simple Cone Search), SIA (Simple Image Access), and TAP (Table Access Protocol). The following URLs may be used by other, **non-customized, local VO clients** (local clients only since this is, currently, only a local server):

 - SCS for JWST image metadata: http://localhost:8080/dals/scs-jwst
 - SCS for the JWST Jaguar catalog: http://localhost:8080/dals/scs-jaguar
 - SCS for the JWST EAZY Results Summary catalog: http://localhost:8080/dals/scs-eazy
 - SCS for the JWST Photometric catalog: http://localhost:8080/dals/scs-photo
 - SIA for JWST image metadata: http://localhost:8080/dals/sia-jwst
 - TAP for JWST catalog and image metadata: http://localhost:8080/dals/tap-jwst


## Stopping the VO Server

***Note**: If you have also started the Astrolabe-customized version of Firefly or the JupyterLab notebook, you must stop these **before** stopping the VO Server.*

To stop the customized version of Firefly:
```
  > make stopff
```

To stop the customized version of JupyterLab notebook:
```
  > make stopjl
```

Finally, to stop the VO Server:
```
  > make down
```
The VO Server containers should stop within a minute or so. This can be monitored with the Docker commands given (above) in the [Startup](#start-the-vo-server) section.


## To Rerun the VO Server

Most of the preceding installation steps need only be performed once per machine. Once installed, a stopped VO Server may be restarted simply by executing [Step 5](#start-the-vo-server) (the startup section above) and stopped as described immediately above.


## License

This software is licensed under Apache License Version 2.0.

Copyright (c) The University of Arizona, 2019. All rights reserved.

This README file was composed with the online tool [StackEdit](https://stackedit.io/).


## Astrolabe Virtual Observatory Server

This is a public code repository of the [Astrolabe Project](http://astrolabe.arizona.edu/) at the [University of Arizona](http://www.arizona.edu).

**Author**: [Tom Hicks](https://github.com/hickst)

**Purpose**: This is an Integration project which documents, coordinates, and administers the separate containerized components of the Astrolabe Virtual Observatory Server.

## Installation

***Note**: Installation of the Astrolabe VO Server requires a working Docker installation, version 18.06 or greater, and **Docker  must  be running in swarm mode** (instructions below).*

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
and then wait for the VO Server containers to initialize, which **may take several minutes** as the containers must be downloaded (the first time only) and started.

You can use common Docker commands to monitor the status of the VO Server containers. The `docker service` command shows whether all three VO Server containers have been instantiated:
```
  > docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE                           PORTS
we6clxxksey1        vos_firefly         replicated          1/1                 ipac/firefly:release-2019.2.1   *:8888->8080/tcp
xo34qn5sj49i        vos_pgdb            replicated          1/1                 astrolabe/vosdb:latest          *:5432->5432/tcp
8pk7v629zraq        vos_vos             replicated          1/1                 astrolabe/dals:latest           *:8080->8080/tcp
```
The VO Server will be ready when the `REPLICAS` column shows 1/1 for all three VO Server containers.

The `docker container` command can also provide status for the VO Server containers:
```
  > docker container ls -a
    CONTAINER ID        IMAGE                           COMMAND                  CREATED             STATUS              PORTS                NAMES
8ddc1bb670af        astrolabe/dals:latest           "catalina.sh run"        20 hours ago        Up 20 hours         8080/tcp             vos_vos.1.4v9h4pj7mtmwgubisxgb63st2
2d5c52ed072a        astrolabe/vosdb:latest          "docker-entrypoint.s…"   20 hours ago        Up 20 hours         5432/tcp             vos_pgdb.1.rn0ivpiyi2wg5unqbq2yidvfx
495006c7b5ba        ipac/firefly:release-2019.2.1   "/bin/bash -c './lau…"   20 hours ago        Up 20 hours         5050/tcp, 8080/tcp   vos_firefly.1.y0sjhh4wn9puwu3e0n6wrmwo4
```
The `STATUS` column (to the right) should eventually show "Up" for all 3 VO Server containers.

### 5. Extract and load a JWST catalog and metadata from FITS files

The VO Server is now ready to be loaded with a JWST catalog and image metadata, extracted from the JWST FITS files which reside on your hard disk.

***Note**: you only have to extract and load the data into the VO Server **once**; when you first install it. Docker will retain the data in a local database between runs of the VO Server.*

The extraction and loading program is called FFP (for FITS File Processor) and is available as another Astrolabe Docker container. To download the FFP program:
```
  > docker pull astrolabe/ffp
```
***Note**: you only have to do this `pull` step **once** for it to reside on your local machine.*

To run the FFP program, make sure that the VO Server is up (Step 4 above) and then call `Make` to extract and load the data from the `images` subdirectory of your current directory:
```
  > make loadData
```
***Note**: Compressed (gzipped) JWST FITS images take about 15 seconds each (compared to about 1/4 second each when uncompressed). The JWST catalog takes about 5 minutes to process, so please be patient.*


## Access the VO Server

If deployment was successful, you will be able to access the VO Server and the Firefly viewer from within a browser on your local machine:

  - Access the VO Server at [http://localhost:8080/dals/](http://localhost:8080/dals/)
  - Access the Firefly viewer at [http://localhost:8888/firefly](http://localhost:8888/firefly)

### Access URLs

The Astrolabe VO Server provides endpoints for data and image metadata retrieval via SCS (Simple Cone Search), SIA (Simple Image Access), and TAP (Table Access Protocol). The following URLs may be used by **local VO clients** (since this is, currently, only a local server):

 - SCS for JWST image metadata: http://vos:8080/dals/scs-jwst
 - SCS for the JWST catalog: http://vos:8080/dals/scs-jcat
 - SIA for JWST image metadata: http://vos:8080/dals/sia-jwst
 - TAP for JWST catalog and image metadata: http://vos:8080/dals/tap-jwst

### Stopping the VO Server

To stop the VO Server use the `docker stack rm` command:
```
  > docker stack rm vos
```
The VO Server containers should stop within a minute or so. This can be monitored with the Docker commands given (above) in the Startup section.

## Connecting Firefly

### Loading images into Firefly from the local disk

After opening the Firefly viewer in a browser, you can load one of the images from your local image directory as follows:

 1. Click the `Images` button on the top button bar to bring up the `Images Search` window.
 2. Select `URL` in the `Select Image Source` box.
 3. Enter the *file URL* for one of the images in your local image directory. Precede the actual filename with `file:///external/`. For example: `file:///external/goods_s_F356W_2018_08_30.fits`
 4. Click the `Search` button at the bottom of the `Images Search` window.
 5. The image should load in about 10-15 seconds.

### Load the JWST Catalog from the VO Server

To search the JWST catalog in the local VO Server:

 1. Click the Catalogs button on the top button bar to bring up the catalogs window.
 2. Select the `VO Catalog` tab at the top of the catalogs window.
 3. Enter coordinates (no names) for the search, such as `53.16 -27.78`
 4. Select a search radius and units, such as `4 arcseconds`
 5. Enter the `Cone Search URL` for the local VO Server, which is `http://vos:8080/dals/scs-jcat`
 6. Click the `Search` button at the bottom of the catalogs window.
 7. The results from the catalog search should open and display next to the previously loaded image.

## License

Software licensed under Apache License Version 2.0.

Copyright (c) The University of Arizona, 2019. All rights reserved.

This README file was composed with the online tool [StackEdit](https://stackedit.io/).


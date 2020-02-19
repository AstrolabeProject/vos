
## Astrolabe VO Server Alpha-testing Cleanup Instructions

**Author**: [Tom Hicks](https://github.com/hickst)

**Purpose**: Instructions for cleaning and resetting your local hard disk and Docker environment after *alpha* testing of the [Astrolabe VO Server](https://github.com/AstrolabeProject/vos.git). These instructions are only necessary if you have some version of the VO Server currently installed and wish to install a newer version.


## Cleanup

### 1. Stop and remove any running Docker containers:
1. Find them with:
```
  > docker container ls -a
```
2. Stop them with:
```
  > docker stop <NAME or CONTAINER ID>...
```
3. Remove them with:
```
  > docker rm <NAME or CONTAINER ID>...
```


### 2. Remove any previous Docker Images related to the VO Server:
- astrolabe/ffal:1H
- astrolabe/cuts:latest
- astrolabe/dals:1H
- astrolabe/jupal:1H
- astrolabe/vosdb:latest
- astrolabe/vosdbmgr:latest

Remove Docker images with:
```
  > docker image rm <IMAGE ID> <IMAGE ID>...
```


### 3. Remove the previous Docker Volumes related to the VO Server:
```
  > docker volume rm vos_pgdata
  > docker volume rm vos_redis
```


## Re-Installation

### 4. Update the VOS Project from GitHub

Your existing VOS project directory must be updated from GitHub. From the VOS project directory, verify that you are using the **onehost** branch (it will be starred) and then "pull" to get the latest code:
```
  > git branch
  master
* onehost

  > git pull
```


### 5. Image Collections

As in previous versions of this software, the FITS images to be served must be available to the VO Server from the VOS project directory. Please see the [Prepare the deployment](https://github.com/AstrolabeProject/vos/tree/onehost#3-prepare-the-deployment-once) section of the main README file to verify your setup.

Starting with the 2/2/2020 version of the Astrolabe VO Server, the *images* directory (linked from the VOS project directory) **must** be organized as a hierarchy (tree) of directories representing different image "collections".  Please see the [Image Collections](https://github.com/AstrolabeProject/vos/tree/onehost#31-image-collections) section of the main README file to learn how your images must be organized for this standalone version of the VO Server.


### 6. Re-install and Start the VO Server software

At this point, you can follow the directions of the main README file, starting at the section labeled [Download the Server software](https://github.com/AstrolabeProject/vos/tree/onehost#4-download-the-server-software-once).



## License

This software is licensed under Apache License Version 2.0.

Copyright (c) The University of Arizona, 2019. All rights reserved.

This README file was composed with the online tool [StackEdit](https://stackedit.io/).

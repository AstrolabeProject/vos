
## Astrolabe Virtual Observatory Server

This is a public code repository of the [Astrolabe Project](http://astrolabe.arizona.edu/) at the [University of Arizona](http://www.arizona.edu).

**Author**: [Tom Hicks](https://github.com/hickst)

**Purpose**: VOS is an **integration** project which documents, coordinates, and administers the separate containerized components of the Astrolabe Virtual Observatory Server.

***Note**: Currently, the Astrolabe VO and Image/Cutout Servers are hosted, in the cloud, by the [Cyverse Project](http://cyverse.org). This special (master) branch of the VOS project provides an Astrolabe-customized JupyterLab server which connects to the Astrolabe VO and Image/Cutout Servers running on Cyverse hosts. You can use the **onehost** branch of this project to create an entirely local installation of the Astrolabe servers.*


## The Astrolabe-customized version of JupyterLab

***Note**: Installing the Astrolabe-customized version of JupyterLab requires a working Docker installation, version 19.03 or greater.*

### 1. Checkout this project (ONCE)

Git `clone` this project somewhere within your "home" area and enter the project directory. For example:
```
  > cd /Users/johndoe/astro
  > git clone --branch onehost https://github.com/AstrolabeProject/vos.git
  > cd vos
  > pwd
/Users/johndo/astro/vos
```

***Note**: hereafter, this directory will be called the "VOS project directory".*


### 2. Download the Server software (ONCE)

This (master) branch of the project provides an Astrolabe-customized JupyterLab server which connects to the Astrolabe VO and Image/Cutout Servers running at Cyverse.

To reduce the time necessary for the JupyterLab server to start up, you should initially download the container. The VOS Makefile includes a command to do this:
```
  > make setup
```
***Note: it may take several minutes to download the container**, so you may have time to get a cup of coffee.*


### 3. Start the local JupyterLab Server

Once the JupyterLab container has been downloaded to your local host, start the it using `Make`:
```
  > make runjl
```
and then wait a few seconds for the container to initialize.

You can use common Docker commands to monitor the status of the container:

The `docker container` command is useful to view the status of containers:
```
  > docker container ls -a
CONTAINER ID        IMAGE                   COMMAND                  CREATED             STATUS              PORTS                    NAMES
cb7442e2f55b        astrolabe/jupal:latest  "jupyter lab --no-br…"   3 seconds ago       Up 2 seconds        0.0.0.0:9999->8888/tcp   jupal

```
The `STATUS` column (to the right) should show "Up" for the JupyterLab container.


### Using the Astrolabe-customized version of JupyterLab notebook

For instructions on starting, stopping, and using the Astrolabe-customized version of JupyterLab notebook, please see the [JupAL document](https://github.com/AstrolabeProject/vos/blob/master/docs/JupAL.md).


## Stopping the local JupyterLab Server

The JupyterLab server is best stopped **from within** JupyterLab itself. To shutdown JupyterLab, open the `File` menu in the menubar, and select the `Shut Down` menu item.

If you are unable to shutdown the JupterLab server from within JupyterLab, you can, as a last resort, force the container to stop. **Forcing the container to stop is not recommended as the normal shutdown procedure because of the possibility that you can lose unsaved work and/or data.**

To force the customized version of the JupyterLab server to stop:
```
  > make killjl
```

The status of the JupyterLab server container can be monitored with the `docker container ls -a` command described in the [Startup](#start-the-local-jupyterlab-server) section.


## License

This software is licensed under Apache License Version 2.0.

Copyright (c) The University of Arizona, 2019. All rights reserved.

This README file was composed with the online tool [StackEdit](https://stackedit.io/).

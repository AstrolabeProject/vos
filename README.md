
## Astrolabe Virtual Observatory Server

This is a public code repository of the [Astrolabe Project](http://astrolabe.arizona.edu/) at the [University of Arizona](http://www.arizona.edu).

**Author**: [Tom Hicks](https://github.com/hickst)

**Purpose**: VOS is an **integration** project which documents, coordinates, and administers the separate containerized components of the Astrolabe Virtual Observatory Server.

***Note**: Currently, the Astrolabe VO and Image/Cutout Servers are hosted by the [Cyverse Project](http://cyverse.org). The **master** branch of this project provides an Astrolabe-customized JupyterLab notebook container which can connect to the Astrolabe servers running on Cyverse hosts. Alternatively, to create an entirely local installation of the Astrolabe servers, the **onehost** branch of this project may be used.*


## Installing the Astrolabe-customized version of JupyterLab

***Note**: Installing the Astrolabe-customized version of JupyterLab requires a working Docker installation, version 19.03 or greater, and the Git and Make programs.*


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


### 2. Download the software (ONCE)

This, the **master** branch of the project, provides an Astrolabe-customized version of JupyterLab which can connect to the Astrolabe VO and Image/Cutout Servers, running at [Cyverse](http://cyverse.org).

To reduce the time necessary for JupyterLab to start up, you should initially download the Docker container. The VOS Makefile includes a command to do this:
```
  > make setup
```
***Note: it may take several minutes to download the container**, so you may have time to get a cup of coffee.*


### Using the Astrolabe-customized version of JupyterLab

For instructions on starting, stopping, and using the Astrolabe-customized version of JupyterLab, please see the [JupAL document](https://github.com/AstrolabeProject/vos/blob/master/docs/JupAL.md).


## License

This software is licensed under Apache License Version 2.0.

Copyright (c) The University of Arizona, 2019. All rights reserved.

This README file was composed with the online tool [StackEdit](https://stackedit.io/).

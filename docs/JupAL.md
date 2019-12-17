
## Astrolabe customized version of the JupyterLab notebook server

**Author**: [Tom Hicks](https://github.com/hickst)

***Purpose**: This document describes a special version of [JupyterLab](https://github.com/jupyterlab/jupyterlab) which has been customized for the [Astrolabe Project](http://astrolabe.arizona.edu/) at the [University of Arizona](http://www.arizona.edu). Use of this version requires that you have successfully started the [Astrolabe VO Server](https://github.com/AstrolabeProject/vos.git) **before** starting JupyterLab.*


## Installation

### 1. Install Astrolabe VO Server

Install and start the [Astrolabe VO Server](https://github.com/AstrolabeProject/vos.git) **before** following these directions to start JupyterLab.


### 2. Start JupyterLab

To start JupyterLab, and connect it to the running VO and Image/Cutout servers, use the `Makefile` provided by the VO Server project:
```
  > make runjl
```
and then wait for the JupyterLab container to initialize.

You can use common Docker commands to monitor the status of the JupyterLab container. The `docker container` command shows the status of the JupyterLab container (named `jupal`) and VO Server containers:
```
  > docker container ls -a
CONTAINER ID        IMAGE                    COMMAND                  CREATED             STATUS             PORTS                NAMES
692cc6b7093f        astrolabe/jupal:1H       "jupyter lab --no-br…"   13 seconds ago      Up 11 seconds      0.0.0.0:9999->8888/tcp jupal
7138a0f4ab88        astrolabe/dals:1H        "catalina.sh run"        1 hour ago          Up 1 hour          8080/tcp             vos_vos.1.qiwaa1vf8uoj4dpab5hovakxp
4c63d1668481        astrolabe/cuts:latest    "gunicorn -c /cuts/c…"   1 hour ago          Up 1 hour                               vos_cuts.1.v8w6gs1rjo1jecu64xbov41qs
e2a970bfa0b4        astrolabe/cuts:latest    "celery worker -l de…"   1 hour ago          Up 1 hour                               vos_celery.1.sdiia00iapiwyxdu6cvlubsar
59008932fd1f        astrolabe/vosdb:latest   "docker-entrypoint.s…"   1 hour ago          Up 1 hour          5432/tcp             vos_pgdb.1.h7petbeck29mf39stnoye8cip
6b970370405f        redis:5.0-alpine         "docker-entrypoint.s…"   1 hour ago          Up 1 hour          6379/tcp             vos_redis.1.x5n2ngphgyzxs87etrideb5sl
```
The `STATUS` column (to the right) should eventually show "Up" for the JupyterLab container.


## Accessing JupyterLab

If deployment was successful, you will be able to access the customized version of JupyterLab from within a browser on your local machine:

  - Access the JupyterLab server at [http://localhost:9999/lab?](http://localhost:9999/lab?)


### Using the Astrolabe VO and Image/Cutout Servers

Both the VO Server and the Image/Cutout Server are useable from within a JupyterLab notebook. Their respective URLs are:

  - **VO Server**: http://dals:8080/dals/
  - **Image/Cutout Server**: http://cuts:8000/

***Note**: documentation on the programmable endpoints of these servers will be in the included in a future release. For now, refer to the Sample Notebooks for examples.*


### Sample Notebooks

This release includes several (read-only) sample notebooks located in the `work/notebooks` directory:

  1. **PlotFromCuts.ipynb** - a notebook which demonstrates how to load images and cutouts from the local Astrolabe Image/Cutout server using Python and Astropy.
  2. **TablesViaVO.ipynb** - a notebook which demonstrates how to query the local Astrolabe VO Server to retrieve catalog data using SCS or TAP via Python and the Pyvo library.
  3. **UseSimbad.ipynb** - a small notebook demonstrating a simple Simbad search using Python and Astropy.


## Stopping JupyterLab

To stop JupyterLab use the provided `make` command:
```
  > make stopjl
```
The JupyterLab container should stop within a minute or so. This can be monitored with the Docker commands given (above) in the [Start JupyterLab](#start-jupyterlab) section.


## License

This software is licensed under Apache License Version 2.0.

Copyright (c) The University of Arizona, 2019. All rights reserved.

This README file was composed with the online tool [StackEdit](https://stackedit.io/).

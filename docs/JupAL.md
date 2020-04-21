
## The Astrolabe customized version of JupyterLab

**Author**: [Tom Hicks](https://github.com/hickst)

***Purpose**: This document describes a special version of [JupyterLab](https://github.com/jupyterlab/jupyterlab) which has been customized for the [Astrolabe Project](http://astrolabe.arizona.edu/) at the [University of Arizona](http://www.arizona.edu). This version of JupyterLab can connect to Astrolabe servers running remotely. Currently, the Astrolabe Virtual Observatory (VO) and Image/Cutout Servers are hosted by the [Cyverse Project](http://cyverse.org).*


## Installation

Please refer to the Astrolabe/VOS project [README document](https://github.com/AstrolabeProject/vos/tree/master) for instructions on downloading the Astrolabe-customized version of JupyterLab and other Astrolabe project software.


## Starting the local JupyterLab container

Once the JupyterLab Docker container has been downloaded to your local host, start the it using `Make`:
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


## Accessing JupyterLab

If deployment was successful, you will be able to access the customized version of JupyterLab from within a browser on your local machine:

  - Access the Astrolabe JupyterLab server at [http://localhost:9999/lab?](http://localhost:9999/lab?)


### Using the Astrolabe VO and Image/Cutout Servers

The Astrolabe Virtual Observatory and Image/Cutout servers provide API endpoints for programmatic access. These APIs are useable from within the JupyterLab notebook. The "top-level" URLs for the server APIs are:

  - **VO Server**: https://hector.cyverse.org/dals/
  - **Image/Cutout Server**: https://hector.cyverse.org/cuts

***Note**: Examples of using the Astrolabe server endpoints are included in the Sample Notebooks, described next.*


### Sample Notebooks

This release includes several (read-only) sample notebooks located in the `work/notebooks` directory:

  1. **PlotFromCuts.ipynb** - a notebook which demonstrates how to load images and cutouts from the Astrolabe Image/Cutout server using Python and [Astropy](https://www.astropy.org/).
  2. **TablesViaVO.ipynb** - a notebook which demonstrates how to query the Astrolabe VO Server to retrieve catalog data using SCS or TAP via Python and the included [Pyvo library](https://pyvo.readthedocs.io/en/latest/).
  3. **UseSimbad.ipynb** - a small notebook demonstrating a simple [Simbad](http://simbad.u-strasbg.fr/simbad/) search using Python and [Astropy](https://www.astropy.org/).
  4. **WWT-NASAExoplanetArchive.ipynb** - a beautiful demo notebook showing some of the capabilities of the [pywwt library](https://github.com/WorldWideTelescope/pywwt), which is included in the Astrolabe-customized version of JupyterLab.
  5. **WWT-VisualizingImagery.ipynb** - a notebook demonstrating how to load and visualize images with [pywwt](https://github.com/WorldWideTelescope/pywwt).


## Stopping the local JupyterLab container

In order to avoid losing work, the JupyterLab container is best stopped **from within** JupyterLab itself. To shutdown JupyterLab, open the `File` menu in the JupyterLab menubar, and select the `Shut Down` menu item. Be sure to save your work, from any modifed notebooks, before you shutdown JupyterLab.

If you are unable to shutdown the JupterLab container from within JupyterLab, you can, as a last resort, force the container to stop. **Forcing the container to stop is not recommended as a normal shutdown procedure because you can lose unsaved work and/or data.**

To force the customized version of JupyterLab to stop:
```
  > make killjl
```

The status of the JupyterLab container can be monitored with the `docker container ls -a` command.


## License

This software is licensed under Apache License Version 2.0.

Copyright (c) The University of Arizona, 2019. All rights reserved.

This README file was composed with the online tool [StackEdit](https://stackedit.io/).



## Astrolabe Virtual Observatory Server.

This is a public code repository of the [Astrolabe Project](http://astrolabe.arizona.edu/) at the [University of Arizona](http://www.arizona.edu).

Author: [Tom Hicks](https://github.com/hickst)

Purpose: Integration project which documents, coordinates, and administers the separate containerized components of the Astrolabe Virtual Observatory Server.

## Installation

***Note**: Installation of the Astrolabe VO Server requires a working Docker installation, version 18.06 or greater, and **Docker  must  be running in swarm mode** (instructions below).*

The containers which make up the Astrolabe VO Server are orchestrated by running Docker in "swarm" mode. Swarm mode is not enabled by default. To enable swarm mode in your running Docker engine, open a shell window and type:
```
   > docker swarm init
```

After a minute or so, you may verify that swarm mode is enabled with the following command:
```
   > docker info | grep Swarm
```

You should see a response like this:
```
Swarm: active
```


## License

Software licensed under Apache License Version 2.0. 

Copyright (c) The University of Arizona, 2019. All rights reserved.

This README file was composed with the online tool [StackEdit](https://stackedit.io/).


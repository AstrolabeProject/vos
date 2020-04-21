ENVLOC=/etc/trhenv

FFURL=https://hector.cyverse.org/local

JAL=jupal
JAL_IMG=astrolabe/jupal:latest
JAL_JOPTS='_JAVA_OPTIONS=-Xms512m -Xmx8192m -Djava.security.egd=file:///dev/urandom'
JAL_DATA=${PWD}/data
JAL_WORK=${PWD}/work
JAL_PORT=9999

NAME=${JAL}


.PHONY: help exec runff stopff runjl stopjl

help:
	@echo 'Make what? help, runjl'
	@echo '  where: help     - show this help message'
	@echo '         setup    - download/update all component containers from DockerHub'
	@echo '         runjl    - start the custom JupyterLab container on this host'

exec:
	docker cp .bash_env ${NAME}:${ENVLOC}
	docker exec -it ${NAME} bash


# get the latest image from DockerHub
setup:
	docker pull ${JAL_IMG}


# dummy targets to inform users that the custom version of Firefly is running on Hector
runff:
	@echo 'The Astrolabe/JWST customized version of Firefly is accessible on the following URL:'
	@echo ${FFURL}

stopff:
	@echo 'Firefly is running remotely on hector.cyverse.org and cannot be stopped from here.'


# run a custom version of JupyterLab which talks to Hector
runjl:
	docker run -d --rm --name ${JAL} -e ${JAL_JOPTS} -p${JAL_PORT}:8888 -v ${JAL_WORK}:/home/jovyan/work -v ${JAL_DATA}:/home/jovyan/data ${JAL_IMG}

stopjl:
	@echo ''
	@echo 'Please stop the JupiterLab container from within Jupiterlab by selecting the "File/Shut Down" menu item.'
	@echo 'As a last resort, you can force a shutdown with the "make killjl" command (NOTE! this may lose changes and/or data).'
	@echo ''

killjl:
	@echo 'Killing the Astrolabe/JWST customized JupiterLab on this host...'
	@docker rm -f ${JAL}

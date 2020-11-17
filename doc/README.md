# Diseño de esta imagen docker para NAS Synology

Los NAS Synology permiten bajar imágenes de docker hub (https://www.synology.com/en-global/knowledgebase/DSM/help/Docker/docker_container ).

## Imagen openjdk

openjdk está publicado en docker

https://hub.docker.com/_/openjdk

Para usarlo como contenedor java, tanto para entornos build y runtime , crear un archivo **Dockerfile**. Su contenido se parecerá un poco a eso, pero un poco más complejo:

```
FROM openjdk:7
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
RUN javac Main.java
CMD ["java", "Main"]
```
Luego se puede construir y correr en docker
```
$ docker build -t my-java-app .
$ docker run -it --rm --name my-running-app my-java-app
```


### Precauciones

Hasta versión 7 JVM intenta adaptar su consumo de CPU en función de información detectadas desde el host. Pues puede resultar una cifra demasiado grande.
Esta solucionado en versión 8

Para evitar un uso excesivo de memoria, configurar -XX:MaxRAM=

/bin/sh de linux alpine no soporta nombre de variables de entorno con puntos. Si la aplicación tiene nombres de variables con puntos, invocar java directamente (no a traves del shell) CMD ["java", ...] y usa bash en lugar de sh

https://hub.docker.com/r/frolvlad/alpine-openjdk7/

## Proyecto de Marcelo Aguero

https://github.com/marceloaguero/docker-dcm4chee
imagen docker 2.18.3 openjdk:8 avec docker-compose


## Proyecto openmediavault-dcm4chee

El año pasado, Nicolas Roduit cerró un proyecto Github que consistía en la integración de dcm4chee 2 ( https://github.com/nroduit/openmediavault-dcm4chee/tree/master/dcm4chee-mysql/debian ) al debian de openmediavault ( https://www.openmediavault.org)

Hasta el releease 4.0.O , integraba dcm4chee 2 y weasis junto con mysql. 

El último release 4.0.1 pasó de mysql a postgres. 

Pues nos quedaremos con el release 4.0.0 del 20 de agosto 2018 como nuestra linea base ( https://github.com/nroduit/openmediavault-dcm4chee/releases/tag/v4.0.0 ).
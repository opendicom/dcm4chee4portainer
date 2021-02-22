# Descripción

dockerized-cron es una imagen creada para ejecutar el demonio cron desde un contenedor docker con persistencia para almacenar la configuración de la programación, los scripts utilizados y el resultado de dichos scripts.

Está basado de forma muy cercana con el [articulo](https://lostindetails.com/articles/How-to-run-cron-inside-Docker) de Martin Kramer y realizada con la perspectiva de ejecutar tareas de respaldo de datos.

# Funcionamiento

## Construir la imagen
```bash
$ docker build -t dockerized-cron:v1.0 .
```
## Iniciar un nuevo contenedor sin persistencia

Esta instancia es absolutamente de prueba, pues cualquier respaldo, script o tarea programada creada dentro del contenedor será eliminado al finalizar el mismo. 
```bash
$ docker run --rm --name nombre_contenedor -d dockerized-cron:v1.0
```

# Persistencia

Esta imagen admite persistir varios componentes. Se utilizan los volumenes de docker para ello. La elección del tipo de volumen (bind, named) depende de cada instalación y/o preferencia de uso.

 ### Scripts de ejecución

 El directorio `/scripts` en la imagen está destinado a ser repositorio de los archivos que serán ejecutados por cron.

 ### Tareas programadas

 La configuración de esto se encuentra en `/etc/crontab` . Persistiendo este archivo no se pierde la configuración realizada.
 
 ### Directorio de datos

 El directorio `/data_dst` es utilizado si alguna tarea genera archivo/s de salida. Por ejemplo algún respaldo. En particular este directorio podría ser un mount de NFS o algo similar 
 
 El directorio `/data_src` tiene el objetivo de montar algún dato de un servidor externo. Por ejemplo alguna carpeta a respaldar o archivos de configuración/parámetros necesarios para la ejecución de alguna tarea programada. 
 
## Iniciar un nuevo contenedor con persistencia
 
Este ejemplo asume tener 3 directorios y un archivo vacío creado en el host docker. 
```bash
     /data/source/
     /data/destino/
     /data/scripts/
     /data/crontab
```

```bash
$ docker run --name nombre_contenedor -d \
	-v /data/source:/data_src:ro \
	-v /data/destino:/data_dst \
	-v /data/scripts:/scripts \
	-v /data/crontab:/etc/crontab \
	dockerized-cron:v1.0
```

# Scripts

Dentro del directorio scripts de este repositorio se encuentran 2 archivos de ejemplo. Uno para respaldo de aplicaciones jboss y otro de base de datos mysql.
 
# Tareas programadas

Como se mencionó anteriormente, la ejecución de los scripts es gestionada por cron. Su archivo de configuración en el contenedor se encuentra en /etc/crontab, pero seguramente usted lo haya "mapeado" sobre un volumen en su host docker, en este ejemplo en `/data/crontab`. Pues edite este archivos con el formato de cron para programar la ejecución de los scripts.
```bash
# cat /data/crontab

# /etc/crontab: system-wide crontab
# Unlike any other crontab you don't have to run the `crontab'
# command to install the new version when you edit this file
# and files in /etc/cron.d. These files also have username fields,
# that none of the other crontabs do.

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed
17 *    * * *   root    cd / && run-parts --report /etc/cron.hourly
25 6    * * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
47 6    * * 7   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
52 6    1 * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
#
# Tus Scripts luego de este renglon
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

0 1 * * * root /scripts/s1.sh > /proc/1/fd/1 2>/proc/1/fd/2
```

Como se ve en el ejemplo, es muy recomendable redireccionar la salida stdout/stderr de los scripts hacia el pid 1. De esta forma se logra obtener la salida de los scripts (logs) desde docker con 
```bash
$ docker logs nombre_contenedor
```
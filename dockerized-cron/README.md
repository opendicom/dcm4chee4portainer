# Descripción

dockerized-cron es una imagen creada para ejecutar el demonio cron desde un contenedor docker con persistencia para almacenar la configuración de la programación, los scripts utilizados y el resultado de dichos scripts.

Está basado de forma muy cercana con el [articulo](https://lostindetails.com/articles/How-to-run-cron-inside-Docker) de Martin Kramer y realizada con la perspectiva de ejecutar tareas de respaldo de datos.

# Funcionamiento

## Construir la imagen
```bash
docker build -t dockerized-cron:v1.0 .
```
## Iniciar un nuevo contenedor sin persistencia

Esta instancia es absolutamente de prueba, pues cualquier respaldo, script o tarea programada creada dentro del contenedor será eliminado al finalizar el mismo. 
```bash
docker run --rm --name nombre_contenedor -d dockerized-cron:v1.0
```

# Tareas programadas

Cron por defecto busca cambios en  `/etc/crontab`y `/etc/cron.d/*`  cuando detecta un cambio en alguno de los archivos actualiza su lista de tareas a memoria para ejecutar las mismas cuando corresponda. Este comportamiento funciona a la perfección desde un sistema operativo completo, pero puede fallar desde algunos contenedores, es decir cuándo hay un cambio en un archivo de configuración cron no lo detecta y por lo tanto no instala la nueva tarea en memoria.

Por tal motivo dockerized-cron maneja cron con cierta peculiaridad. Existe un archivo `/crontab_file` quien contiene la configuración de cron deseada. Cada vez que el contenedor es creado carga la configuración de este archivo a memoria. Si este archivo es cambiado luego de que el contenedor inició será necesario cargar manualmente a memoria la configuración o reiniciar el contenedor.

## Cargar la configuración de cron de forma manual

Para cargar de forma manual la configuración de cron luego que modificó el archivos /crontab_file

```bash
docker exec -it nombre_contenedor bash
crontab /crontab_file
```

## Log de tareas

Para ver la salida de las tareas es necesario redirigir stdin y stdout hacia el proceso con pid 1. De esta forma podremos observar los logs con el comando de Docker

```bash
docker logs nombre_contenedor
```

Para redirigir las salidas, en el archivo `/crontab_file` debemos agregar la tarea programada de la siguiente forma:

```bash
0 1 * * * /scripts/s1.sh > /proc/1/fd/1 2>/proc/1/fd/2
```

# Persistencia

Esta imagen admite persistir varios componentes. Se utilizan los volumenes de docker para ello. La elección del tipo de volumen (bind, named) depende de cada instalación y/o preferencia de uso.

 ### Scripts de ejecución

 El directorio `/scripts` en la imagen está destinado a ser repositorio de los archivos que serán ejecutados por cron.

 ### Tareas programadas

 La configuración de esto se encuentra en `/crontab_file . Persistiendo este archivo no se pierde la configuración realizada.

 ### Directorio de datos

 El directorio `/data_dst` es utilizado si alguna tarea genera archivo/s de salida. Por ejemplo algún respaldo. En particular este directorio podría ser un mount de NFS o algo similar 

 El directorio `/data_src` tiene el objetivo de montar algún dato de un servidor externo. Por ejemplo alguna carpeta a respaldar o archivos de configuración/parámetros necesarios para la ejecución de alguna tarea programada. 

## Iniciar un nuevo contenedor con persistencia

Este ejemplo asume tener 3 directorios y un archivo vacío creado en el host docker. 
```bash
     /data/source/
     /data/destino/
     /data/scripts/
     /data/crontab_file
```

```bash
docker run --name nombre_contenedor -d \
	-v /data/source:/data_src:ro \
	-v /data/destino:/data_dst \
	-v /data/scripts:/scripts \
	-v /data/crontab_file:/crontab_file \
	dockerized-cron:v1.0
```

# Scripts

Dentro del directorio scripts de este repositorio se encuentran 2 archivos de ejemplo. Uno para respaldo de aplicaciones jboss y otro de base de datos mysql.


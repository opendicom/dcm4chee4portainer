# Descripción

dockerized-dcm4chee2.18.3 es una imagen creada para ejecutar [dcm4chee2.18.3](https://dcm4che.atlassian.net/wiki/spaces/ee2/overview) desde un contenedor docker con persistencia para almacenar la configuración y los archivos dicom. La base de datos se asume instanciada en otro lugar.

Tiene [pre-instalado el visualizador Weasis](https://nroduit.github.io/en/old/dcm4chee/) de manera que se puede observar el estudio desde el acceso web.

Se actualizó el plugin libclib_jiio a su ultima versión (1.2.0-b04) que mejora el bug de memory leak al comprimir en jpeg2000 aunque no lo soluciona de manera definitiva. Mas información sobre esto [aquí](https://groups.google.com/g/dcm4che/c/tFnyGVAttEU).

Se equipó esta imagen con el demonio cron ejecutado en segundo plano, pues es posible realizar tareas de mantenimiento sobre el contenedor de manera automática, como puede ser eliminación de logs o reinicio de servicio como por ejemplo por los problemas de memory leak al usar compresión de imágenes.


# Funcionamiento

## Construir la imagen
```bash
docker build -t dockerized-dcm4chee2.18.3:v1.0 .
 ```
## Iniciar un nuevo contenedor sin persistencia

Esta instancia es absolutamente de prueba, pues cualquier configuración o archivo enviado será eliminado al finalizar el contenedor. 
```bash
docker run --rm --name nombre_contenedor -d dockerized-dcm4chee2.18.3:v1.0
```

# Persistencia

Esta imagen admite persistir varios componentes. Se utilizan los volúmenes de docker para ello. La elección del tipo de volumen (bind, named) depende de cada instalación y/o preferencia de uso.

 ### Configuración de dcm4chee

 El directorio `/opt/dcm4chee/server/default` es donde se guarda la configuración del servicio. Para persistir estos datos, es necesario utilizar un volumen de tipo Named Volume ya que al iniciar por primera vez el contenedor se deben copiar los datos de configuración al nuevo volumen. Esta "copia" NO funciona con un volumen de tipo Bind.

 ### Repositorio DICOM

 Por defecto dcm4chee configura el repositorio de archivos dicom en el directorio `/opt/dcm4chee/server/default/archive`. Utilizando un volumen en este directorio se persiste el repositorio.
 
## Iniciar un nuevo contenedor con persistencia
 
Este ejemplo asume tener 1 directorio creado previamente para repositorio dicom.
```bash
/data/archive/
```
```bash
docker run --name nombre_contenedor -d \
	-v /data/archive:/opt/dcm4chee/server/default/archive/ \
	-v dcm4chee_vol:/opt/dcm4chee/server/default/ \
	dockerized-dcm4chee2.18.3:v1.0
```

Nótese la diferencia entre los volúmenes. El primer volumen es de tipo Bind y el segundo Named volume.

## Cron
Para configurar tareas en cron basta con montar un archivo del host docker sobre `/etc/crontab` en el contenedor.
En el directorio de este repositorio existe un archivo de configuración de ejemplo `crontab_ejemplo`.
```bash    
## Apagado del jboss todos los días a las 4:00 am
#0 4 * * * root pkill -15 java

## Borrado de logs los 1ros de cada mes
#0 0 1 * * root rm -f /opt/dcm4chee/server/default/log/server.log.*
```


## Iniciar un nuevo contenedor con persistencia y cron

Asumimos que existe el archivo `/host/path/crontab_pacs` en el host docker y que tiene una configuración de cron adecuada.

```bash
docker run --name nombre_contenedor -d \
    -v /data/archive:/opt/dcm4chee/server/default/archive/ \
	-v dcm4chee_vol:/opt/dcm4chee/server/default/ \
    -v /host/path/crontab_pacs:/etc/crontab
	dockerized-dcm4chee2.18.3:v1.0
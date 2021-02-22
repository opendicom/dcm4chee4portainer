# nasdicom

# Introducción

**nasdicom** es una solución completa de PACS desarrollada para plataforma Docker. Se basa en varias imágenes ya disponibles pero ajustadas para cumplir algunos requerimientos extras.
El software utilizado es **dcm4chee 2.18.3** como pacs, **mysql 5.7** como motor de base de datos, **nginx** como servidor de proxy reverso y **cron** para tareas programadas de respaldo/mantenimiento.

 Todo esto lanzado desde un compose que unifica los servicios en un único Stack brindando la solución completa. Como lo indica su nombre **nasdicom** fue pensado con la meta de ser instalado en un NAS para transformar a éste en un PACS completo juntando aplicación y storage.

# Imágenes personalizadas
En los directorios `dockerized-dcm4chee2.18.3` y `dockerized-cron` se encuentran la información necesaria para construir las imágenes utilizadas en el compose así como también documentación de su uso.

# Construcción de nasdicom

Crear un clon del repositorio en un nas donde ya esté instalado docker y docker-compose

## Creación de la imagen dockerized-dcm4chee2.18.3

```bash
$ docker build --rm -f "dockerized-dcm4chee.2.18.3/Dockerfile" -t dockerized-dcm4chee.2.18.3:v1.0 "dockerized-dcm4chee.2.18.3"
```

## Creación de la imagen docker-cron

```bash
$ docker build --rm -f "dockerized-cron/Dockerfile" -t dockerized-cron:v1.0 "dockerized-cron"
```

## Preparar el host docker
Es necesario crear algunos directorios y archivos en el host docker para permitir la persistencia de los datos. Suponemos los siguientes directorios y archivos creados.
```bash
/host/path/archive/     # Almacén de archivos dicom
/host/path/mysql/       # Almacén de base de datos
/host/path/crontab_pacs # Archivo cron para el contenedor pacs-app.
/host/path/crontab_bkp          # Archivo cron para el contenedor pacs-bkp
/host/path/reverse-proxy.conf   # Archivo de configuración nginx
/host/path/scripts/     # para almacenar los scripts de ejecución con dockerized-cron
/host/path/data_dst/    # para almacenar los datos de salida de los scripts de dockerized-cron
```

## Configurar docker-compose.yml con las carpetas y archivos creados anteriormente
A continuación se muestra solo un extracto del archivo docker-compose.yml donde se deben actualizar los parámetros.
```yml
    services:
        db:
            volumes:
                # Directorio donde se almacenan los datos de MYSQL (BIND MOUNT)
                - /host/path/mysql/:/var/lib/mysql
            [...]
        
        pacs:
            volumes:
                # Directorio donde se almacenan los archivos DICOM del PACS (BIND MOUNT)
                - /host/path/archive/:/opt/dcm4chee/server/default/archive
          
                # Archivo contab con las tareas programadas
                - /host/path/crontab_pacs:/etc/crontab
            [...]
        
        rproxy:
            volumes:
                - /host/path/reverse-proxy.conf:/etc/nginx/nginx.conf:ro 
            [...]
            
        backups:
            volumes: 
                # Directorio con los scripts utilizados para hacer los respaldos
                - /host/path/scripts/:/scripts

                # Directorio donde almacenar los respaldos (host docker)
                - /host/path/data_dst:/data_dst

                # Archivo contab con las tareas programadas
                - /host/path/crontab_bkp:/etc/crontab
            [...]
```

### Ahora solo queda iniciar el compose

```bash
$ docker-compose -f "docker-compose.yml" up -d 
```

# Portainer.io
Incluimos en este proyecto un docker-compose de [portainer.oi](https://www.portainer.io/) con el propósito de facilitar la administración y mantenimiento de la plataforma docker desde una aplicación web sin necesidad de tener acceso al nas. Para instanciar portainer.io:
```bash
$ cd portainer
$ docker-compose -f "docker-compose.yml" up -d 
```
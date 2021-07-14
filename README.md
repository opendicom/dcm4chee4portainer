# Introducción

**nasdicom** es una solución completa de PACS desarrollada para plataforma Docker. Se basa en varias imágenes ya disponibles pero ajustadas para cumplir algunos requerimientos extras.
El software utilizado es **dcm4chee 2.18.3** como pacs, **mysql 5.7** como motor de base de datos, **nginx** como servidor de proxy reverso y **cron** para tareas programadas de respaldo/mantenimiento.

 Todo esto lanzado desde un compose que unifica los servicios en un único Stack brindando la solución completa. Como lo indica su nombre **nasdicom** fue pensado con la meta de ser instalado en un NAS para transformar a éste en un PACS completo juntando aplicación y storage.

# Imagen personalizada
En el directorio `dockerized-cron` se encuentran la información necesaria para construir la imagen utilizada en el compose así como también documentación de su uso.

# Construcción de nasdicom

Crear un clon del repositorio en un nas donde ya esté instalado docker y docker-compose

## Creación de la imagen docker-cron

```bash
docker build --rm -t dockerized-cron:v1.0 dockerized-cron/
```

# Persistencia 

Por defecto el directorio `data` de este repositorio es el destinado a persistir los datos mysql, respaldos y archive dicom. Si desea utilizar este directorio no es necesario realizar ninguna preparación extra en el host docker. De lo contrario, si desea ajustar los directorios de persistencia siga los siguientes pasos:

## Preparar el host docker

Crear el grupo de directorios necesarios, para este ejemplo se asumen los siguientes:

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
        mysql:
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
            
        cron:
            volumes: 
                # Directorio con los scripts utilizados para hacer los respaldos
                - /host/path/scripts/:/scripts

                # Directorio donde almacenar los respaldos (host docker)
                - /host/path/data_dst:/data_dst

                # Archivo contab con las tareas programadas
                - /host/path/crontab_bkp:/etc/crontab
            [...]
```

# Iniciar el compose

```bash
docker-compose -f "docker-compose.yml" up -d 
```

# Portainer.io
Incluimos en este proyecto un docker-compose de [portainer.oi](https://www.portainer.io/) con el propósito de facilitar la administración y mantenimiento de la plataforma docker desde una aplicación web sin necesidad de tener acceso al nas. Para instanciar portainer.io:
```bash
cd portainer
docker-compose -f "docker-compose.yml" up -d 
```

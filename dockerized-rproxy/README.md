# Descripción

dockerized-rproxy simplemente utiliza la imagen oficial de nginx con un archivo de configuracion personalizado para que el contenedor generado brinde los servivios de proxy reverso.

En este directorio, se encuentra el archivo `reverse-proxy.conf` que presenta una configuracion básica de nginx como proxy reverso.


## Iniciar un nuevo contenedor con una configuracion personalizada

    # docker run --rm -v /dockerized-rproxy/reverse-proxy.conf:/etc/nginx/nginx.conf:ro -p 80:80/tcp nginx:latest

Nótese que utilizamos un volumen (-v) para "reemplazar" el archivo `etc/nginx/nginx.conf` del contenedor con nuestro archivo de configuracion almacenado en el host. De esta manera nginx inicia con nuesta configuracion.

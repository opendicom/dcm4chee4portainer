# dcm4chee4portainer

## Introducción

**Imagen docker** de PACS **"dcm4chee 2.18.3 con weasis nativo"** para uso desde un docker-compose que incluya también una imagen docker **"msyql 5.7"**.

La plataforma de destino de tal composer es una aplicación de tipo **"portainer"** que se encuentra en varios NAS para transformar el NAS en PACS completo juntando aplicación y storage.

La imagen docker está diseñada para superar los problemas de compatibilidad de versiones que surgen con un servidor que no puede ir más allá de java versión 7.

Dentro de la carpeta /doc copiamos la información de referencia para la creación de esta imagen.

## Construccion de dockerized-dcm4chee

Crear un clon del repositorio en una maquina donde ya esté instalado docker y docker-compose

En el archivo .env se declaran los parámetros de configuración como son nombre de base de datos, usuario, contraseña, etc.

Luego se crea la imagen docker y los contenedores y se instancian con el comando:

```bash
docker-compose -f "docker-compose.yml" up -d --build
```

## Componentes de dockerized-dcm4chee

para hacer...
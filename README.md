# dcm4chee4portainer

**Imagen docker** de PACS **"dcm4chee 2.18.3"** para uso desde un docker-compose que incluya también una imagen docker **"msyql 5.7"**.

La plataforma de destino de tal composer es una aplicación de tipo **"portainer"** que se encuentra en varios NAS para transformar el NAS en PACS completo juntando aplicación y storage.

Al dcm4chee le agregamos el excelente visualizador **"weasis"**, escrito en java.

La imagen docker está diseñada para superar los problemas de compatibilidad de versiones que surgen con un servidor que no puede ir más allá de java versión 7 y clientes que vienen con java 8 y superior instalados.

Dentro de la carpeta /doc copiamos la información de referencia para la creación de esta imagen.

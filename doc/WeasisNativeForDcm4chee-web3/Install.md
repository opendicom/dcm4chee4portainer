# Install weasis-connector

dcm4chee 2.18.3 soporta java 1.7 máx. porque requiere jboss 4.2.3 que tiene esta limitación.

 https://developer.jboss.org/thread/206569

weasis-connector permite crear un manifiesto con las imágenes a descargar por weasis en la máquina cliente.
Se realiza con botónes agregados al GUI de dcm4chee.

![Weasis%20in%20dcm4chee-web3.png](Weasis%20in%20dcm4chee-web3.png)

La lógica de creación de los botones y entrega del manifiesto se encuentra en weasis-pacs-connector.

Elígimos la versión 6.1.5 (2019-07-12) porque es compatible con java 1.7 (y servlet container 2.5).
Versión 7 NO soporta dcm4chee 2.18.3.


## Paquetes a colocar dentro de server/default/deploy/

https://sourceforge.net/projects/dcm4che/files/Weasis/weasis-pacs-connector/6.1.5/weasis-pacs-connector.war/download

https://sourceforge.net/projects/dcm4che/files/Weasis/weasis-pacs-connector/6.1.5/dcm4chee-web-weasis.jar/download


## configuración para uso con el protocolo weasis y clientes nativos

desde http://<your-host>:8080/jmx-console

In dcm4chee.web seleccionar service=WebConfig y entrar los dos valores siguientes:

WebviewerNames = weasis

WebviewerBaseUrl = weasis:/weasis-pacs-connector/weasis

Aplicar los cambios.

### Si el aet del pacs fue cambiado...

1. Download the current weasis-connector-default.properties and rename it weasis-pacs-connector.properties, 

2. download dicom-dcm4chee.properties (configuration of the dcm4chee archive)

3. Copy 1. y 2. in the classpath of the servlet container. In JBoss (inferior to version 7), the best location would typically be server/default/conf.

4. Edit the configuration as needed. For example, dcm4chee may be running on a different computer than Weasis, or the AE Title of dcm4chee may have been changed.



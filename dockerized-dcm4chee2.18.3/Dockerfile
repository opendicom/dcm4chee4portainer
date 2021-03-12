FROM openjdk:7

LABEL version="1.0"
LABEL maintainer="opendicom"

#Instalación de paquetes necesarios
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		curl \
		unzip \
		cron \
	&& rm -rf /var/lib/apt/lists/*

# Instalacion de dcm4chee
RUN curl -L -O http://downloads.sourceforge.net/project/dcm4che/dcm4chee/2.18.3/dcm4chee-2.18.3-mysql.zip \
	&& unzip dcm4chee-2.18.3-mysql.zip -d /opt/ \
	&& ln -s /opt/dcm4chee-2.18.3-mysql /opt/dcm4chee \
	&& rm -f dcm4chee-2.18.3-mysql.zip

# Instalacion de JBoss 4.2.3.GA
COPY install_jboss.sh /opt/dcm4chee/bin/
RUN chmod 755 /opt/dcm4chee/bin/install_jboss.sh
RUN curl -L -O http://downloads.sourceforge.net/project/jboss/JBoss/JBoss-4.2.3.GA/jboss-4.2.3.GA.zip \
  && unzip jboss-4.2.3.GA.zip -d /opt \
  && rm -f jboss-4.2.3.GA.zip \
  && /opt/dcm4chee/bin/install_jboss.sh /opt/jboss-4.2.3.GA \
  && rm -rf /opt/jboss-4.2.3.GA/

# Instalcion de JAI Image I/O en dcm4chee
RUN mv /opt/dcm4chee/bin/native/libclib_jiio.so /opt/dcm4chee/bin/native/libclib_jiio.so.orig
COPY libclib_jiio.so /opt/dcm4chee/bin/native/

# Ajuste de la conexion a la base de datos, se cambia el host por defecto (localhost) a db
RUN sed -i "s|localhost:3306/pacsdb|db:3306/pacsdb|g" /opt/dcm4chee/server/default/deploy/pacs-mysql-ds.xml

# Instalacion de weasis
RUN curl -L -O https://sourceforge.net/projects/dcm4che/files/Weasis/3.6.2/weasis.war \
	&& curl -L -O https://sourceforge.net/projects/dcm4che/files/Weasis/3.6.2/weasis-i18n.war \
	&& curl -L -O https://sourceforge.net/projects/dcm4che/files/Weasis/3.6.2/weasis-ext.war \
	&& curl -L -O https://sourceforge.net/projects/dcm4che/files/Weasis/weasis-pacs-connector/6.1.5/weasis-pacs-connector.war \
    && curl -L -O https://sourceforge.net/projects/dcm4che/files/Weasis/weasis-pacs-connector/6.1.5/dcm4chee-web-weasis.jar

# Instalacion de archivo crontab
RUN touch /crontab_file

RUN mv weasis.war /opt/dcm4chee/server/default/deploy/
RUN mv weasis-i18n.war /opt/dcm4chee/server/default/deploy/
RUN mv weasis-ext.war /opt/dcm4chee/server/default/deploy/
RUN mv weasis-pacs-connector.war /opt/dcm4chee/server/default/deploy/
RUN mv dcm4chee-web-weasis.jar /opt/dcm4chee/server/default/deploy/
RUN mkdir -p /opt/dcm4chee/server/default/data/xmbean-attrs/
COPY dcm4chee.web@3Aservice@3DWebConfig.xml /opt/dcm4chee/server/default/data/xmbean-attrs/

EXPOSE 8080 11112
COPY init_wrapper_script.sh init_wrapper_script.sh
RUN chmod 755 init_wrapper_script.sh
CMD ["./init_wrapper_script.sh"]
FROM openjdk:7

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		curl \
		unzip \
	&& rm -rf /var/lib/apt/lists/*

# Install dcm4chee
RUN curl -L -O http://downloads.sourceforge.net/project/dcm4che/dcm4chee/2.18.3/dcm4chee-2.18.3-mysql.zip \
	&& unzip dcm4chee-2.18.3-mysql.zip -d /opt/ \
	&& ln -s /opt/dcm4chee-2.18.3-mysql /opt/dcm4chee \
	&& rm -f dcm4chee-2.18.3-mysql.zip

# Install JBoss 4.2.3.GA
COPY install_jboss.sh /opt/dcm4chee/bin/
RUN curl -L -O http://downloads.sourceforge.net/project/jboss/JBoss/JBoss-4.2.3.GA/jboss-4.2.3.GA.zip \
  && unzip jboss-4.2.3.GA.zip -d /opt \
  && rm -f jboss-4.2.3.GA.zip \
  && /opt/dcm4chee/bin/install_jboss.sh /opt/jboss-4.2.3.GA

# Install JAI Image I/O into dcm4chee
RUN mv /opt/dcm4chee/bin/native/libclib_jiio.so /opt/dcm4chee/bin/native/libclib_jiio.so.orig
COPY libclib_jiio.so /opt/dcm4chee/bin/native/

EXPOSE 8080 11112

VOLUME /opt/dcm4chee/server/default

CMD ["/opt/dcm4chee/bin/run.sh"]

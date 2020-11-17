# Install dcm4chee on Debian

Ubuntu es una variante de Debian compatible con los paquetes deb.
Hasta Ubunto 18.04 LTS permite instalar java open-jdk 1.7 necesario para dcm4chee 2.18.3
Versiones más recientes de Ubuntu ya no permiten instalar open-jdk inferiores a 1.8.

1. Download https://github.com/nroduit/openmediavault-dcm4chee/releases/download/v4.0.0/dcm4chee-mysql_2.18.3.1_amd64.deb
2. sudo apt-get install mysql-server
3. sudo dpkg -i dcm4chee-mysql_2.18.3.1_amd64.deb

=> may have dependency errors, execute the next command to install the dependencies.
sudo apt-get -f install

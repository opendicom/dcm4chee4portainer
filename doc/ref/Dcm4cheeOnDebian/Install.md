# Install dcm4chee on Debian

1. Download https://github.com/nroduit/openmediavault-dcm4chee/releases/download/v4.0.0/dcm4chee-mysql_2.18.3.1_amd64.deb
2. sudo apt-get install mysql-server
3. sudo dpkg -i dcm4chee-mysql_2.18.3.1_amd64.deb

=> may have dependency errors, execute the next command to install the dependencies.
sudo apt-get -f install

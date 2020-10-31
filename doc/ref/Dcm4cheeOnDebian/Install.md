# Install dcm4chee on Debian
Nicolas Roduit edited this page on 20 Aug 2018

## Install/Upgrade dcm4chee and Weasis

1. Download the latest dcm4chee-mysql_x.x.x_all.deb and dcm4chee-weasis_x.x.x_all.deb at https://github.com/nroduit/openmediavault-dcm4chee/releases
2. sudo apt-get install mysql-server
3. sudo dpkg -i dcm4chee-mysql_x.x.x_all.deb
=> may have dependency errors, execute the next command to install the dependencies.
sudo apt-get -f install
4. sudo dpkg -i dcm4chee-weasis_x.x.x_all.deb

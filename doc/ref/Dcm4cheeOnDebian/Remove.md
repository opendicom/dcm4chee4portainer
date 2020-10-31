
# Remove dcm4chee and Weasis

1. sudo /etc/init.d/dcm4chee stop
2. sudo apt-get remove dcm4chee-weasis or sudo dpkg -r dcm4chee-weasis
3. sudo apt-get remove dcm4chee-mysql or sudo dpkg -r dcm4chee-mysql

=> will remove the binaries, but not the configuration or data files created by dcm4chee-mysql. 

It will also leave dependencies installed with it on installation time untouched.

## Note: 

for removing all the files (including the generated files), type 

sudo apt-get purge dcm4chee-mysql ( or sudo dpkg -P dcm4chee-mysql )

This will remove about everything regarding the package dcm4chee-mysql (all the content of /var/lib/dcm4chee/ and drop the mysql database), but not the dependencies installed with it on installation. 

If you use the default image directory located in the installed directory (/var/lib/dcm4chee/archive), all the images will be deleted.
# dcm4chee initial configuration

## Login into web interface

Connect to the Web Interface at http://localhost:8080/dcm4chee-web3/ of the archive using any Web Browser. You should get the User Login Screen. Login in using default Administrator account 'admin', with password 'admin'.

## Change storage location

1. Connect to JBoss's JMX Console at http://localhost:8080/jmx-console/ (http://localhost:8080/admin-dcm4chee/ or from version 4.0.0) and login using also the Administrator account 'admin', with password 'admin'.
2. Follow the link "group=ONLINE_STORAGE,service=FileSystemMgt" to the configuration page for File System Management service under the "dcm4chee.archive" heading.
3. Invoke the operation addRWFileSystem(), with argument dirPath specifying the directory, where the archive shall store received objects/images.

If no Storage File System is configured, the archive will auto-configure dcm4chee-2.xx-xxx/server/default/archive as Storage File System, when receiving the first object/image.

## Optional: Change the default AE Title

1. Connect to JBoss's JMX Console at http://localhost:8080/jmx-console/ and login using also the Administrator account 'admin', with password 'admin'.
2. Follow the link "service=AE" to the configuration page for AE (Application Entity - a DICOM term for a DICOM node on the network) service under the "dcm4chee.archive" heading.
3. Invoke the operation updateAETitle with the old AE Title (DCM4CHEE if unchanged from the default), and new AE Title as parameters.

This will update the following configurations:

1. update the retrieve AET of file systems, associated to the current retrieve AET of this node
2. update retrieveAETs of all instances, series and studies that have files on these filesystems
3. update the entry for the retrieve AE in the AE Configuration
4. update the AE Title of all services listed by attribute OtherServiceAETitleAttributesToUpdate

## Optional: Configure image compression

At default configuration, received images are stored as received - in particular, no compression is performed. Lossless compression of received uncompressed images can be activated by attribute "CompressionRules" in the configuration page for the Storage SCP Service (service=StoreScp). E.g. set it to "JLSL", to compress all type of images received from any Storage SCU using JPEG-LS Lossless codec.

## Security

### Note

all these recommendations are automitically applied from the version 4.0.0

### Recommendations 

Limit the server accessibility as dcm4chee 2.x runs on the old JBoss 4.2.3.

To protect the server against the known exploits (see https://github.com/joaomatosf/jexboss):

1. Remove the folder deploy/management
2. Remove the folder deploy/http-invoker.sar
3. Remove the folder deploy/jboss-web.deployer/ROOT.war
4. Rename the folder deploy/jmx-console.war by deploy/xxxxx.war (will change the web context of jmx-console)
5. Redirect all the web context to https:
    a. Change the configuration and certificates in deploy/jboss-web.deployer/server.xml
    b. Modify web.xml in deploy/dcm4chee-web-ear-3.0.7-psql.ear and deploy/jmx-console.war:

```
   <security-constraint>
     ...
     <user-data-constraint>
       <transport-guarantee>CONFIDENTIAL</transport-guarantee>
     </user-data-constraint>
   </security-constraint>

```

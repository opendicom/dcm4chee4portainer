#!/bin/bash

#--- Variables de configuracion---#

# Directorio donde crear los respaldos
DST="/data_dst/RespaldosJBOSS"

JBOSS_DIR="/data_src/jboss"

# Cantidad de respaldos a retener
RETENTION=7

# --------------------------------------------- #
date=$(date +%Y%m%d)
file=$(basename $JBOSS_DIR)



# Reviso existencia directorio destino
echo -n "Comprobando directorio destino...   "
if [ ! -d "$DST" ] 
then
    echo "ERROR"
	echo "Directorio $DST no existe"
    exit 1 
fi
echo "OK"

# Reviso retencion de datos
cd $DST
echo -n "Aplicando politica de retencion..."
CurrentFileCount=$(ls | wc -l)
if [ $CurrentFileCount -ge $RETENTION ]; then
   archivoaborrar=$(find -type f -name "$file*" -printf '%T+ %P\n' | sort | head -n1 | cut -f2 -d' ')
   rm -f $archivoaborrar
   echo "OK"
   echo "Borrado archivo $DST$archivoaborrar"
fi
echo "OK"


# Creo el respaldo
cd $JBOSS_DIR
cd ..
tar -czf $DST/$file-$date.tar.gz $JBOSS_DIR
#!/bin/bash

#--- Variables de configuracion---#

# Directorio donde crear los respaldos
DST="/data_dst/RespaldosMySQL"

# Parametros de acceso MySQL
DBHOST='localhost'
DBUSER='dbuser'
DBPASS='dbpassword'
DBNAME='basededatos'

# Cantidad de respaldos a retener
RETENTION=7

# --------------------------------------------- #
date=$(date +%Y%m%d)
file=$DBNAME


# Reviso existencia directorio destino
echo -n "Comprobando directorio destino...   "
if [ ! -d "$DST" ] 
then
    echo "ERROR"
	echo "Directorio $DST no existe"
    exit 1 
fi
echo "OK"

# Reviso conexion a MySQL
echo -n "Comprobando conexion a mysql...  "
mysql --user="$DBUSER" --password="$DBPASS" -h "$DBHOST" -e exit 2>/dev/null
if [ $? != 0 ]; then
   echo "ERROR"
   echo "No se pudo establecer conexion con MySQL"
   exit 1
fi
echo "OK"

# Reviso existencia de db
echo -n "Comprobando existencia de la db... "
resu=$(mysql --user=$DBUSER --password=$DBPASS -h $DBHOST --disable-column-names -B -e "SHOW DATABASES LIKE '$DBNAME'")
if [ "$resu" != "$DBNAME" ];then
   echo "ERROR"
   echo "No no encuentra la base de datos $DBNAME"
   exit 1
fi
echo "OK"


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
echo -n "Creando dump de la base de datos...  "
mysqldump --opt --single-transaction --user="$DBUSER" --password="$DBPASS" -h "$DBHOST" $DBNAME | gzip -c > $DST/$file-$date.sql.gz
if [ $? != 0 ]; then
	echo "ERROR"
	echo "Hubo algun problema en el dump de la base de datos"
	exit 1
fi
echo "OK"
exit 0


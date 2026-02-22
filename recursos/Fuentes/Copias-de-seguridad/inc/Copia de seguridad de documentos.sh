#!/bin/sh

# Basic snapshot-style rsync backup script 
DISPOSITIVO="004063A2364D3CD9"
FECHA="+%d-de-%B-de-%Y-hora-%H-minuto-%M-segundo-%S"
# Config
OPT="-aPh"
LINK="--link-dest=/media/$USER/$DISPOSITIVO/Copia-de-seguridad-de-documentos/capturas/última/" 
SRC="$HOME/Documentos/"
SNAP="/media/$USER/$DISPOSITIVO/Copia-de-seguridad-de-documentos/capturas/"
LAST="/media/$USER/$DISPOSITIVO/Copia-de-seguridad-de-documentos/capturas/última/"
date=`date $FECHA`

# Run rsync to create snapshot
rsync $OPT $LINK $SRC ${SNAP}$date

# Remove symlink to previous snapshot
rm -f $LAST

# Create new symlink to latest snapshot for the next backup to hardlink
ln -s $LAST ${SNAP}$date

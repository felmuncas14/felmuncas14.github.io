#!/bin/sh

# Basic snapshot-style rsync backup script 
FECHA="+%d-de-%B-de-%Y-hora-%H-minuto-%M-segundo-%S"
# Config
OPT="-aPh"
LINK="--link-dest=/media/$USER/004063A2364D3CD9/Copia-de-seguridad-de-escritorio/capturas/última" 
SRC="$HOME/Escritorio/"
SNAP="/media/$USER/004063A2364D3CD9/Copia-de-seguridad-de-escritorio/capturas/"
LAST="/media/$USER/004063A2364D3CD9/Copia-de-seguridad-de-escritorio/capturas/última"
date=`date $FECHA`

# Run rsync to create snapshot
rsync $OPT $LINK $SRC ${SNAP}$date

# Remove symlink to previous snapshot
rm -f $LAST

# Create new symlink to latest snapshot for the next backup to hardlink
ln -s ${SNAP}$date $LAST

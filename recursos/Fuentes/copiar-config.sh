# Felipe Muñoz Fernández,
#
# Fuentes: 
# - MadHatter: serverfault.com/questions/
# 212439/linux-mv-or-cp-specific-files-from-a-text-list-of-diles
# - choroba: unix.stackexchange.com/questions/86722/how-do-i-loop-through-only-directories
# -in-bash
# - Stéphane Chazelas: unix.stackexchange.com/questions/635778/how-to-expand
# -variables-inside-read

###############################################################################
# Programa que recorre todos los directorios en la misma carpeta, y que busca #
# en cada uno de ellos un archivo NOMBRE_LISTA, en el que aparecen separados  #
# por saltos de línea todos los archivos que se desean guardar en la carpeta  #
# (que se encuentra dentro de ese mismo directorio) CARPETA_INC. Advertencia: #
# hay que añadir un salto de línea extra al final de los archivos si por      #
# alguna razón fallase para copiar un archivo de un inc.txt nuevo	      #
#
# Esto me sirve para así poder guardar los archivos de configuración junto    #
# con el código en LaTeX para poder pasármelos a la máquina virtual y que     #
# allí pueda también compilar los documentos. La idea es que este programa    #
# sea llamado por el Makefile con el objetivo que uso para cuando compilo en  #
# el ordenador principal.						      #
###############################################################################

NOMBRE_LISTA=inc.txt
CARPETA_INC=inc

for dir in */; do
	while read -r archivo; do
		cp "$(echo "$archivo" | envsubst)" "$dir$CARPETA_INC/"
	done < $dir$NOMBRE_LISTA
done

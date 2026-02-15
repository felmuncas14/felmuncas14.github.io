# Propiedad de Felipe Muñoz Casasola
# This is free and unencumbered software released into the public domain.

# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.

# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

# For more information, please refer to <https://unlicense.org/>
# Realizado gracias a makefiletutorial.com

###############################################################################
# Compila con LaTeX los proyectos bajo la carpeta especificada. Considerando
# que cada carpeta es un proyecto, con el nombre del proyecto siendo el nombre
# de dicha carpeta. Actualmente, estos nombres no pueden llevar espacios.
#
# Se le especifica una carpeta de salida donde almacenar todos los archivos
# generados, donde cada uno tiene el nombre del proyecto que lo ha generado.
# Automáticamente limpia los archivos auxiliares de LaTeX, aunque actualmente
# LaTeX no elimina, por ejemplo, los archivos auxiliares generados por minted.
# Por tanto, es posible que quede algún archivo residual de compilación dentro
# de los proyectos.
###############################################################################

# Compilador
ltx=latexmk
# Opciones para el compilador
OPCIONES=-pdf -pdfxelatex=xelatex
# Opción para limpiar
LIMPIAR=-C

# Si el siguiente comentario lo pongo a la derecha de DIR_FNT, el Makefile
# deja de funcionar, parece que se traga los espacios en la variable.

# Directorio con los proyectos en LaTeX
DIR_FNT = recursos/Fuentes
# Archivo principal de los proyectos en LaTeX
LTX_PR = principal.tex
# Directorio de salida en el que almacenar los documentos
DIR_SALIDA = recursos/PDFs

# Archivo PDF de salida del compilador
LTX_PDF=$(LTX_PR:%.tex=%.pdf)
# Archivos fuentes a compilar
FUENTES = $(shell find $(DIR_FNT) -name 'principal.tex')
# Ahora tengo que quedarme con el nombre de los archivos finales en PDF, que
# será el nombre del proyecto de LaTeX (el nombre de la carpeta que guarda
# el proyecto). Nota importante: dependiendo del número de subdirectorios
# requerido para llegar al archivo principal.tex será necesario modificar
# el valor de -f que se le pasa a cut, deberé arreglarlo algún día.
SALIDAS_SIN_PDF = $(shell find $(DIR_FNT) -name 'principal.tex' | cut -d / -f 3)
SALIDAS = $(SALIDAS_SIN_PDF:%=%.pdf)

###############################################################################

.PHONY: all
all: com

# Compila los proyectos de LaTeX.
.PHONY: com
com: $(SALIDAS)

%.pdf: $(DIR_FNT)/%
	$(ltx) $(OPCIONES) -output-directory="$<" "$</$(LTX_PR)"
	mv "$</$(LTX_PDF)" "$(DIR_SALIDA)/$@"
	$(ltx) $(LIMPIAR) $(OPCIONES) -output-directory="$<" "$</$(LTX_PR)"

pre: com
	jekyll serve

# Limpia las posibles huellas que pudieran llevar a comprometer algún
# metadato.
limpiar:
	find -type d -name _minted -exec rm -r '{}' \;
# Compila el proyecto y actualiza el repositorio
pub: com limpiar
	git add .
	git commit -m "Actualizo los archivos."
	git push


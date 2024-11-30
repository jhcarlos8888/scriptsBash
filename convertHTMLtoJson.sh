#!/bin/bash

# Verificar si se pasó un archivo como argumento
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 archivo.html"
    exit 1
fi

# Leer el archivo HTML
html_file="$1"

# Verificar si el archivo existe
if [ ! -f "$html_file" ]; then
    echo "El archivo $html_file no existe."
    exit 1
fi

# Escapar caracteres especiales para JSON
json_string=$(<"$html_file" sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/\\n/g' \
    -e 's/"/\\"/g' -e 's/\t/\\t/g')

# Generar el campo JSON
echo "{ \"htmlContent\": \"$json_string\" }"

#!/bin/bash

# Configuración SMTP
SMTP_SERVER="smtp.gmail.com"
SMTP_PORT="587"
USERNAME_EMAIL=" "
PASSWORD_EMAIL=" "
TO=" "
CC=" "
SUBJECT="Asunto del correo"
BODY="Este es el cuerpo del mensaje."

# Crear archivo temporal para el correo
TEMP_EMAIL=$(mktemp) || exit 1

# Crear el contenido del correo
{
  echo "From: $USERNAME"
  echo "To: $TO"
  echo "Cc: $CC"
  echo "Subject: Solicitud despliegue"
  echo
  echo "Despliegue de imagen"
} > "$TEMP_EMAIL"

# Construir el comando curl dinámicamente
curl_command="curl --url \"smtp://${SMTP_SERVER}:${SMTP_PORT}\" \
     --ssl-reqd \
     --mail-from \"$USERNAME_EMAIL\" \
     --mail-rcpt \"$TO\""

# Procesar las direcciones en CC y agregarlas como destinatarios
IFS=',' read -ra ADDR <<< "$CC"
for cc_email in "${ADDR[@]}"; do
    curl_command+=" --mail-rcpt \"$cc_email\""
done

# Añadir el resto del comando curl
curl_command+=" --user \"$USERNAME_EMAIL:$PASSWORD_EMAIL\" -T \"$TEMP_EMAIL\""

# Ejecutar el comando curl
eval "$curl_command"

# Eliminar el archivo temporal
rm -f "$TEMP_EMAIL"

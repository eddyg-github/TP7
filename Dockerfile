# Usa la imagen oficial de Nginx como base
FROM nginx:latest

# Configura la zona horaria a Buenos Aires
RUN ln -snf /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime && echo "America/Argentina/Buenos_Aires" > /etc/timezone

# Copia el archivo HTML desde el contexto de build al directorio de Nginx
COPY saludo.html /usr/share/nginx/html/saludo.html

# Expone el puerto 80 para acceder al servicio web
EXPOSE 80

# Comando por defecto para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]

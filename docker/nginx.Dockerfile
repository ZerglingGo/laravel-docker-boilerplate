# Application
FROM nginx:latest
WORKDIR /var/www/html

COPY --from=localhost:5000/php /var/www/html/public/ ./public/

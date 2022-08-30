# Composer Installation
FROM composer:2 as vendor
WORKDIR /var/www/html

COPY ./app/composer.json ./app/composer.lock ./app/artisan ./

RUN composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --no-dev \
    --prefer-dist \
    --optimize-autoloader

COPY ./app/ .

# RUN composer dump-autoload \
#     --no-dev \
#     --optimize \
#     --classmap-authoritative

# Frontend Installation
FROM node:lts as frontend
WORKDIR /var/www/html

COPY ./app/package.json ./app/vite.config.js ./

RUN npm install

COPY ./app/resources/ ./resources/

RUN npm run build

# Application
FROM php:8.1-fpm
WORKDIR /var/www/html

# Install PHP dependencies
RUN apt-get update -y && apt-get install -y libpng-dev libzip-dev zlib1g-dev cron supervisor && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    mkdir -p /usr/src/php/ext/redis && \
    curl -L https://github.com/phpredis/phpredis/archive/5.3.7.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 && \
    echo 'redis' >> /usr/src/php-available-exts && \
    docker-php-ext-install -j$(nproc) bcmath gd opcache pcntl pdo_mysql redis zip

COPY --from=vendor /var/www/html/vendor/ ./app/vendor/
COPY --from=frontend /var/www/html/public/ ./app/public/

COPY ./app/ .

RUN chmod -R 777 storage bootstrap/cache

RUN php artisan view:cache

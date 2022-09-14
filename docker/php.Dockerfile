# Application
FROM php:8.1-fpm

# Install PHP dependencies
RUN apt-get update -y && apt-get install -y libpng-dev libzip-dev zlib1g-dev cron supervisor && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    mkdir -p /usr/src/php/ext/redis && \
    curl -L https://github.com/phpredis/phpredis/archive/5.3.7.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 && \
    echo 'redis' >> /usr/src/php-available-exts && \
    docker-php-ext-install -j$(nproc) bcmath gd opcache pcntl pdo_mysql redis zip

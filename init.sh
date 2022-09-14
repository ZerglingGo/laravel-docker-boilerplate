if [ -d "app" ]; then
    echo "app Directory exists. Already initialized project?"
    exit 1
fi

sudo docker run --rm -it \
    --volume "$(pwd):/app" \
    --user $(id -u):$(id -g) \
    composer:2 \
    sh -c " \
        composer create-project laravel/laravel app && \
        cd app && \
        composer install \
            --ignore-platform-reqs \
            --no-interaction \
            --no-plugins \
            --no-scripts \
            --no-dev \
            --prefer-dist \
            --optimize-autoloader && \
        composer dump-autoload \
            --no-dev \
            --optimize \
            --classmap-authoritative
    "

sudo chmod -R 777 app/bootstrap/cache app/storage

sudo docker run --rm -it \
    --volume "$(pwd):/app" \
    --user $(id -u):$(id -g) \
    --workdir "/app/app" \
    node:lts \
    sh -c " \
        npm install
    "

if [ $? -eq 0 ]; then
    git init
    git add .
    git commit -m 'Initial Laravel'

    echo -e "\n============================================\n\e[1;32m\tCompleted initialize Laravel\e[0m\n============================================\n"

    echo -e '======== \e[1;33mUseful aliases\e[0m ========'
    echo -e "alias ld-artisan='sudo docker-compose --env-file=app/.env run php php artisan'"
    echo -e "alias ld-composer='sudo docker run --rm -it --volume \"$(pwd):/app\" --user $(id -u):$(id -g) --workdir /app/app composer:2 composer'"
    echo -e "alias ld-npm='sudo docker run --rm -it --volume \"$(pwd):/app\" --user $(id -u):$(id -g) --workdir /app/app -p=5173:5173 node:lts npm'"
    echo -e "alias ld-npx='sudo docker run --rm -it --volume \"$(pwd):/app\" --user $(id -u):$(id -g) --workdir /app/app node:lts npx'"
    echo -e '============================================='

    echo -e '\n\e[1;33mPlease edit your ./app/.env file Before running ./build.sh\e[0m'
fi

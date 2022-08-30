if [ -d "app" ]; then
    echo "app Directory exists. Already initialized project probably."
    exit 1
fi

docker run --rm -it \
    --volume "$(pwd):/app" \
    --user $(id -u):$(id -g) \
    composer create-project laravel/laravel app

if [ $? -eq 0 ]; then
    echo -e "\n============================================\n\e[1;32m\tCompleted initialize laravel\e[0m\n============================================\n"

    echo -e 'Please edit your ./app/.env file Before running ./build.sh'

    git init
    git add .
    git commit -m 'Initial laravel'
fi

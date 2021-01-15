VERSION=$(cat ./dist/VERSION)
export SERVER_PATH=$(cat ./dist/SERVER_PATH)

GIT_BRANCH_NAME=$(sh -c 'git branch --no-color 2> /dev/null' | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/' -e 's/\//\_/g')

if [ "$(whoami)" != "root" ]; then
  echo "Please run this script as root ."
  exit 1
fi

if [ "$1" != ${GIT_BRANCH_NAME} ]; then
  echo "Your current branch is ${GIT_BRANCH_NAME},but it's $1 for your arg,Please confirm or use <git checkout branch_name> to switch your branch "
  exit 2
fi

if [ ! -n "$VERSION" ]; then
  echo "VERSION IS NULL"
  exit 3
fi

if [ ! -n "$SERVER_PATH" ]; then
  echo "SERVER_PATH IS NULL"
  exit 3
fi

echo "you are sure you wanna to build for \e[31m branch:<${GIT_BRANCH_NAME}> \e[0m and \e[31m verson:<$VERSION> \e[0m?"
read -p "[y/n]" input
if [ ! -n "$input" ]; then
  echo "your input is NULL"
  exit 4
elif [ $input != "y" ]; then
  echo "exit success"
  exit 4
fi

VERSION=$VERSION
if [ ! -n "$2" ]; then
  PORT=9900
else
  PORT=$2
fi

if [ ! -n "$3" ]; then
  COMPOSE_PROJECT_NAME="$(basename "$PWD")-${GIT_BRANCH_NAME}-$(basename $(dirname "$PWD"))"
else
  COMPOSE_PROJECT_NAME=$3
fi

echo "VERSION=${VERSION}" > .env
echo "PORT=${PORT}" >> .env
echo "COMPOSE_PROJECT_NAME=${COMPOSE_PROJECT_NAME}" >> .env
echo "SERVER_PATH=${SERVER_PATH}" >> .env

 
envsubst '${SERVER_PATH}' < ./default.template > ./default.conf

name=project-name/front/${COMPOSE_PROJECT_NAME}

nginx_name=nginx
nginx_version=1.16.1

# docker login 
docker build --build-arg NGINX_BASE=$nginx_name:$nginx_version -t $name:$VERSION .
# docker push $name:$VERSION

read -p "Do you wanna use <docker-compose up -d> to run image?[y/n]" isRun
if [ ! -n "$isRun" ]; then
  echo "your input is NULL"
  exit 4
elif [ $isRun != "y" ]; then
  echo "exit success"
  exit 4
fi
docker-compose up -d

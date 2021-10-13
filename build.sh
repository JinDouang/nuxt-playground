#!/usr/bin/env bash

## variable
NUXT_IMAGE_NAME=nuxt-playground

# build nuxt app image
buildImage () {
  # checking if docker image already exists
  if [[ $(docker image inspect --format='{{index .RepoTags 0}}' nuxt-playground) == $NUXT_IMAGE_NAME:latest ]];
    then
        # cleanup
        clean
    else
        echo "$NUXT_IMAGE_NAME does not exist, building a new one"
  fi
  docker image build -t $NUXT_IMAGE_NAME .
}

# clean nuxt app image
clean() {
  # checking if docker image already exists
  if [[ $(docker image inspect --format='{{index .RepoTags 0}}' nuxt-playground) == $NUXT_IMAGE_NAME:latest ]];
    then
        # cleanup
        docker-compose down && docker rmi -f $NUXT_IMAGE_NAME
    else
        echo "$NUXT_IMAGE_NAME has already been cleaned or does not exist"
  fi
}

# start nuxt for dev
startNuxt() {
    npm run start:docker
}

# build nuxt app (.nuxt output)
buildNuxtApp() {
    docker-compose run --rm nuxt-build
}

for param in "$@"
do
  case $param in
    build)
      buildImage
      ;;
    clean)
      clean
      ;;
    start)
      startNuxt
      ;;
    buildNuxtApp)
      buildNuxtApp
      ;;
    *)
      echo "Invalid argument : $param"
  esac
  if [ ! $? -eq 0 ]; then
    exit 1
  fi
done

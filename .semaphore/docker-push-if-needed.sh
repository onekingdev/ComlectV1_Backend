#!/usr/bin/env bash
echo "${0##*/}: GIT BRANCH IS: $SEMAPHORE_GIT_BRANCH"

case "$SEMAPHORE_GIT_BRANCH" in
  staging)
    echo "${0##*/}: Pushing Docker images for Staging"
    heroku container:login
    docker tag complect_web registry.heroku.com/complect-docker-staging/web
    docker tag complect_worker registry.heroku.com/complect-docker-staging/worker
    docker push registry.heroku.com/complect-docker-staging/web
    docker push registry.heroku.com/complect-docker-staging/worker
    ;;

  master)
    echo "${0##*/}: Pushing Docker images for Production"
    heroku container:login
    docker tag complect_web registry.heroku.com/complect-docker-production/web
    docker tag complect_worker registry.heroku.com/complect-docker-production/worker
    docker push registry.heroku.com/complect-docker-production/web
    docker push registry.heroku.com/complect-docker-production/worker
    ;;

  *)
    echo "${0##*/}: Skipping pushing Docker images"
esac
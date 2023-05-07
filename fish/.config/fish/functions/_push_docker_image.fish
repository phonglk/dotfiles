function push_docker_image
  set TAG $argv[1]
  set NAME ( basename (git rev-parse --show-toplevel) )
  echo "Going to tag and push $NAME:$TAG from $NAME:latest"
  read
  docker tag $NAME:latest us.gcr.io/ruckussgdc-rsa-builder/$NAME:$TAG
  docker push us.gcr.io/ruckussgdc-rsa-builder/$NAME:$TAG
end


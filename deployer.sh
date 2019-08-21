#!/bin/bash
set -e
echo "I'm custom deployer"
echo args="$@"
echo Deployer environment:
env | grep -i deployer || :

case $1 in
   "deploy")
                echo "deployer.deploy"
                cd $2
                needCI=$(git diff --stat master@{1} master package-lock.json)
                if [[ $needCI = "" ]]
                  then echo "only build"
                  npm run build
                else
                  echo "ci and build"
                  npm ci
                  npm run build
                fi
                cp -r ./build /usr/share/nginx/html
                service nginx stop
                service nginx start
                ;;
   "deploy-all")
                echo "deployer.deploy-all"
                ;;
   "start")
                echo "deployer.start"
                cd $2
                ;;
   "stop")
                echo "deployer.stop"
                cd $2
                service nginx stop
                rm ./build
                ;;
   *) echo "Sorry, not sure what you mean"
                exit 1
                ;;
esac
#!/bin/bash

set -e

DIR=$(dirname "$0")
packageVersion=$( cat ./swagger-config/config-java.json | jq -r ".artifactVersion" )

echo "Going to update Java SDK..."

eval "$(ssh-agent -s)" #start the ssh agent
chmod 600 $DIR/java-repo.pem # this key should have push access
ssh-add $DIR/java-repo.pem

git clone git@github.com:square/connect-java-sdk.git
cd connect-java-sdk

RELEASE_BRANCH=release/$packageVersion
if [ `git branch -r | grep -i "^\s*origin/${RELEASE_BRANCH}$"` ];
then
    git checkout $RELEASE_BRANCH
else
    git checkout -b $RELEASE_BRANCH
    git push -u origin $RELEASE_BRANCH
fi

if [ "${TRAVIS_BRANCH}" = "master" ];
then
    BRANCH_NAME=$RELEASE_BRANCH
else
    BRANCH_NAME=travis-ci/$TRAVIS_BRANCH
    if [ `git branch -r | grep -i "^\s*origin/${BRANCH_NAME}$"` ];
    then
        git checkout $BRANCH_NAME
    else
        git checkout -b $BRANCH_NAME
    fi
fi

echo "Copying files..."
rm -rf docs src/main
cp -r ../swagger-out/java/docs .
cp -r ../swagger-templates/java/static ./src/main
cp -r ../swagger-out/java/src/main ./src/
rm ./src/main/AndroidManifest.xml
cp ../swagger-out/java/build.gradle .
cp ../swagger-out/java/build.sbt .
cp ../swagger-out/java/gradle.properties .
cp ../swagger-out/java/pom.xml .
cp ../swagger-out/java/settings.gradle .
cp ../swagger-out/java/README.md .

git add --all .
git commit -m "From connect-api-specification: ${TRAVIS_COMMIT_MESSAGE}"
git push -u origin $BRANCH_NAME

#!/bin/bash

set -e

DIR=$(dirname "$0")
packageVersion=$( cat ./swagger-config/config-python.json | jq -r ".packageVersion" )

echo "Going to update Python SDK..."

eval "$(ssh-agent -s)" #start the ssh agent
chmod 600 $DIR/python-repo.pem # this key should have push access
ssh-add $DIR/python-repo.pem

git clone git@github.com:square/connect-python-sdk.git
cd connect-python-sdk

if [ "${TRAVIS_BRANCH}" = "master" ];
then
    BRANCH_NAME=release/$packageVersion
else
    BRANCH_NAME=travis-ci/$TRAVIS_BRANCH
fi

if [ `git branch -r | grep "${BRANCH_NAME}"` ];
then
    git checkout $BRANCH_NAME
else
    git checkout -b $BRANCH_NAME
fi

echo "Copying files..."
rm -rf docs lib
cp -r ../swagger-out/python/docs .
cp -r ../swagger-out/python/squareconnect .
cp ../swagger-out/python/requirements.txt .
cp ../swagger-out/python/test-requirements.txt .
cp ../swagger-out/python/setup.py .
cp ../swagger-out/python/tox.ini .
cp ../swagger-out/python/README.md .

git add .
git commit -m "From connect-api-specification: ${TRAVIS_COMMIT_MESSAGE}"
git push -u origin $BRANCH_NAME

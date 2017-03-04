#!/bin/bash

set -e

DIR=$(dirname "$0")
packageVersion=$( cat ./swagger-config/config-python.json | jq -r ".packageVersion" )
BRANCH_NAME=release/$packageVersion

echo "Going to update Python SDK..."

eval "$(ssh-agent -s)" #start the ssh agent
chmod 600 $DIR/python-repo.pem # this key should have push access
ssh-add $DIR/python-repo.pem

git clone git@github.com:square/connect-python-sdk.git
cd connect-python-sdk
if [ `git branch -r | grep "${BRANCH_NAME}"` ]
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
git commit -m "Pushed by Travis CI from connect-api-specification. Commit: ${TRAVIS_COMMIT}"

# only push to sdk repo when it's merged into master
if [ "${TRAVIS_PULL_REQUEST_BRANCH}" = "" -a "${TRAVIS_BRANCH}" = "master" ];
then
    git push -u origin $BRANCH_NAME
else
    echo "Skip push because of pull request."
fi

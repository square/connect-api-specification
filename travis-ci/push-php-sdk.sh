#!/bin/bash

set -e

DIR=$(dirname "$0")
packageVersion=$( cat ./swagger-config/config-php.json | jq -r ".artifactVersion" )
BRANCH_NAME=release/$packageVersion

echo "Going to update PHP SDK..."

eval "$(ssh-agent -s)" #start the ssh agent
chmod 600 $DIR/php-repo.pem # this key should have push access
ssh-add $DIR/php-repo.pem

git clone git@github.com:square/connect-php-sdk.git
cd connect-php-sdk
if [ `git branch -r | grep "${BRANCH_NAME}"` ]
then
    git checkout $BRANCH_NAME
else
    git checkout -b $BRANCH_NAME
fi

echo "Copying files..."
rm -rf docs lib
cp -r ../swagger-out/php/SquareConnect/docs .
cp -r ../swagger-out/php/SquareConnect/lib .
cp ../swagger-out/php/SquareConnect/autoload.php .
cp ../swagger-out/php/SquareConnect/composer.json .
cp ../swagger-out/php/SquareConnect/README.md .

git add .
git commit -m "Pushed by Travis CI from connect-api-specification. Commit: ${TRAVIS_COMMIT}"

# only push to sdk repo when it's merged into master
if [ "${TRAVIS_PULL_REQUEST_BRANCH}" = "" -a "${TRAVIS_BRANCH}" = "master" ];
then
    git push -u origin $BRANCH_NAME
else
    echo "Skip pull request."
fi


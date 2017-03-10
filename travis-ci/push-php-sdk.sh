#!/bin/bash

set -e

DIR=$(dirname "$0")
packageVersion=$( cat ./swagger-config/config-php.json | jq -r ".artifactVersion" )

echo "Going to update PHP SDK..."

eval "$(ssh-agent -s)" #start the ssh agent
chmod 600 $DIR/php-repo.pem # this key should have push access
ssh-add $DIR/php-repo.pem

git clone git@github.com:square/connect-php-sdk.git
cd connect-php-sdk

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
cp -r ../swagger-out/php/SquareConnect/docs .
cp -r ../swagger-out/php/SquareConnect/lib .
cp ../swagger-out/php/SquareConnect/.travis.yml .
cp ../swagger-out/php/SquareConnect/autoload.php .
cp ../swagger-out/php/SquareConnect/composer.json .
cp ../swagger-out/php/SquareConnect/README.md .

git add .
git commit -m "From connect-api-specification: ${TRAVIS_COMMIT_MESSAGE}"
git push -u origin $BRANCH_NAME


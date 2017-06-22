#!/bin/bash

set -e

DIR=$(dirname "$0")
packageVersion=$( cat ./swagger-config/config-ruby.json | jq -r ".gemVersion" )

echo "Going to update Ruby SDK..."

eval "$(ssh-agent -s)" #start the ssh agent
chmod 600 $DIR/ruby-repo.pem # this key should have push access
ssh-add $DIR/ruby-repo.pem

git clone git@github.com:square/connect-ruby-sdk.git
cd connect-ruby-sdk

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
rm -rf docs lib
cp -r ../swagger-out/ruby/docs .
cp -r ../swagger-out/ruby/lib .
cp ../swagger-out/ruby/.rspec .
cp ../swagger-out/ruby/Gemfile .
cp ../swagger-out/ruby/Rakefile .
cp ../swagger-out/ruby/README.md .
cp ../swagger-out/ruby/square_connect.gemspec .

git add --all .
git commit -m "From connect-api-specification: ${TRAVIS_COMMIT_MESSAGE}"
git push -u origin $BRANCH_NAME

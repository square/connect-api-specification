#!/bin/bash

set -e

DIR=$(dirname "$0")
packageVersion=$( cat ./swagger-config/config-ruby.json | jq -r ".gemVersion" )
BRANCH_NAME=release/$packageVersion

echo "Going to update Ruby SDK..."

eval "$(ssh-agent -s)" #start the ssh agent
chmod 600 $DIR/ruby-repo.pem # this key should have push access
ssh-add $DIR/ruby-repo.pem

git clone git@github.com:square/connect-ruby-sdk.git
cd connect-ruby-sdk
if [ `git branch -r | grep "${BRANCH_NAME}"` ]
then
    git checkout $BRANCH_NAME
else
    git checkout -b $BRANCH_NAME
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

git add .
git commit -m "Pushed by Travis CI from connect-api-specification. Commit: ${TRAVIS_COMMIT} | ${TRAVIS_COMMIT_MESSAGE}"

# only push to sdk repo when it's merged into master
if [ "${TRAVIS_PULL_REQUEST_BRANCH}" = "" -a "${TRAVIS_BRANCH}" = "master" ];
then
    git push -u origin $BRANCH_NAME
else
    echo "Skip push because of pull request."
fi

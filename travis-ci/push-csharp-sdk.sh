#!/bin/bash

set -e

DIR=$(dirname "$0")
packageVersion=$( cat ./swagger-config/config-csharp.json | jq -r ".packageVersion" )
BRANCH_NAME=release/$packageVersion

echo "Going to update C# SDK..."

# only push to sdk repo when it's merged into master
if [ "${TRAVIS_PULL_REQUEST_BRANCH}" = "" -a "${TRAVIS_BRANCH}" = "master" ];
||||||| merged common ancestors
# only push to sdk repo when it's only from pull request
if [ "${TRAVIS_PULL_REQUEST}" = "false" ];
then
    eval "$(ssh-agent -s)" #start the ssh agent
    chmod 600 $DIR/csharp-repo.pem # this key should have push access
    ssh-add $DIR/csharp-repo.pem

    git clone git@github.com:square/connect-csharp-sdk.git
    cd connect-csharp-sdk
    git checkout $BRANCH_NAME

    echo "Copying files..."
    rm -rf docs src/Square.Connect
    cp -r ../swagger-out/csharp/docs .
    cp -r ../swagger-out/csharp/src/Square.Connect ./src/Square.Connect
    cp ../swagger-out/csharp/.travis.yml .
    cp ../swagger-out/csharp/.gitignore .
    cp ../swagger-out/csharp/.swagger-codegen-ignore .
    cp ../swagger-out/csharp/README.md .
    cp ../swagger-out/csharp/Square.Connect.sln .
    cp ../swagger-out/csharp/build.sh .
    cp ../swagger-out/csharp/mono_nunit_test.sh .

    git add .
    git commit -m "Pushed by Travis CI from connect-api-specification. Commit: ${TRAVIS_COMMIT}"
    git push -u origin $BRANCH_NAME
else
    echo "Skip pull request."
fi

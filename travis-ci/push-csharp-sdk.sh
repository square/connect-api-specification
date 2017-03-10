#!/bin/bash

set -e

DIR=$(dirname "$0")
packageVersion=$( cat ./swagger-config/config-csharp.json | jq -r ".packageVersion" )


echo "Going to update C# SDK..."

eval "$(ssh-agent -s)" #start the ssh agent
chmod 600 $DIR/csharp-repo.pem # this key should have push access
ssh-add $DIR/csharp-repo.pem

git clone git@github.com:square/connect-csharp-sdk.git
cd connect-csharp-sdk

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
git commit -m "From connect-api-specification: ${TRAVIS_COMMIT_MESSAGE}"
git push -u origin $BRANCH_NAME

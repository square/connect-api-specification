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
rm -rf docs src/Square.Connect
cp -r ../NOTES.md .
cp -r ../swagger-out/csharp/docs .
cp -r ../swagger-out/csharp/src/Square.Connect ./src/Square.Connect
cp ../swagger-out/csharp/.travis.yml .
cp ../swagger-out/csharp/.gitignore .
cp ../swagger-out/csharp/.swagger-codegen-ignore .
cp ../swagger-out/csharp/README.md .
cp ../swagger-out/csharp/Square.Connect.sln .
cp ../swagger-out/csharp/build.sh .
cp ../swagger-out/csharp/mono_nunit_test.sh .

git add --all .
git commit -m "From connect-api-specification: ${TRAVIS_COMMIT_MESSAGE}"
git push -u origin $BRANCH_NAME

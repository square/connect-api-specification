#!/bin/bash

set -e

DIR=$(dirname "$0")
BRANCH_NAME=travis/build_$TRAVIS_BUILD_NUMBER

# only push to sdk repo when it's only from pull request
if [ "${TRAVIS_PULL_REQUEST}" = "false" ];
then
    openssl aes-256-cbc -K $encrypted_b0a304ce21a6_key -iv $encrypted_b0a304ce21a6_iv -in $DIR/csharp-repo.enc -out $DIR/csharp-repo.pem -d
    eval "$(ssh-agent -s)" #start the ssh agent
    chmod 600 $DIR/csharp-repo.pem # this key should have push access
    ssh-add $DIR/csharp-repo.pem

    git clone git@github.com:square/connect-csharp-sdk.git
    cd connect-csharp-sdk
    git checkout -b $BRANCH_NAME
    rm -rf *
    cp -r ../swagger-out/csharp/* .
    git add .
    git commit -m "Pushed by Travis CI from connect-api-specification. Commit: ${TRAVIS_COMMIT}"
    git remote add deploy git@github.com:square/connect-csharp-sdk.git
    git push -u deploy $BRANCH_NAME
else
    echo "Skip pull request."
fi

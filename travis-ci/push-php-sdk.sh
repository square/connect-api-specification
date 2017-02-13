<<<<<<< 0f958e6dcfaee42cc1c9ea645c5646880ecb067b
#!/bin/bash

set -e

DIR=$(dirname "$0")
packageVersion=$( cat ./swagger-config/config-php.json | jq -r ".artifactVersion" )
BRANCH_NAME=release/$packageVersion

echo "Going to update PHP SDK..."

# only push to sdk repo when it's merged into master
if [ "${TRAVIS_PULL_REQUEST_BRANCH}" = "" -a "${TRAVIS_BRANCH}" = "master" ];
then
    eval "$(ssh-agent -s)" #start the ssh agent
    chmod 600 $DIR/php-repo.pem # this key should have push access
    ssh-add $DIR/php-repo.pem

    git clone git@github.com:square/connect-php-sdk.git
    cd connect-php-sdk
    git checkout $BRANCH_NAME

    echo "Copying files..."
    rm -rf docs lib
    cp -r ../swagger-out/php/SquareConnect/docs .
    cp -r ../swagger-out/php/SquareConnect/lib .
    cp -r ../swagger-out/php/SquareConnect/.travis.yml .
    cp -r ../swagger-out/php/SquareConnect/autoload.php .
    cp -r ../swagger-out/php/SquareConnect/composer.json .
    cp -r ../swagger-out/php/SquareConnect/README.md .

    git add .
    git commit -m "Pushed by Travis CI from connect-api-specification. Commit: ${TRAVIS_COMMIT}"
    git push -u origin $BRANCH_NAME
else
    echo "Skip pull request."
fi
||||||| merged common ancestors
=======
#!/bin/bash

set -e

DIR=$(dirname "$0")
packageVersion=$( cat ./swagger-config/config-php.json | jq -r ".artifactVersion" )
BRANCH_NAME=release/$packageVersion

echo "Going to update PHP SDK..."

# only push to sdk repo when it's only from pull request
if [ true -o "${TRAVIS_PULL_REQUEST}" = "false" ];
then
    openssl aes-256-cbc -K $encrypted_b0a304ce21a6_key -iv $encrypted_b0a304ce21a6_iv -in $DIR/php-repo.enc -out $DIR/php-repo.pem -d
    eval "$(ssh-agent -s)" #start the ssh agent
    chmod 600 $DIR/php-repo.pem # this key should have push access
    ssh-add $DIR/php-repo.pem

    git clone git@github.com:square/connect-php-sdk.git
    cd connect-php-sdk
    git checkout $BRANCH_NAME

    echo "Copying files..."
    rm -rf docs lib
    cp -r ../swagger-out/php/SquareConnect/docs .
    cp -r ../swagger-out/php/SquareConnect/lib .
    cp -r ../swagger-out/php/SquareConnect/.travis.yml .
    cp -r ../swagger-out/php/SquareConnect/autoload.php .
    cp -r ../swagger-out/php/SquareConnect/composer.json .
    cp -r ../swagger-out/php/SquareConnect/README.md .

    git add .
    git commit -m "Pushed by Travis CI from connect-api-specification. Commit: ${TRAVIS_COMMIT}"
    git push -u origin $BRANCH_NAME
else
    echo "Skip pull request."
fi
>>>>>>> CI: Add PHP travis support.

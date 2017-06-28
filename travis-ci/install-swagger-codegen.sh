#!/bin/bash

SWAGGER_DIR=./swagger-codegen
SWAGGER_PATCHES_DIR=`pwd`/travis-ci/swagger-codegen-patches

# download from swagger-codegen from github
git clone https://github.com/swagger-api/swagger-codegen.git $SWAGGER_DIR
cd $SWAGGER_DIR
if [ -n "${SWAGGER_CODEGEN_SHA+1}" ]
then
    echo "Using Swagger version \`${SWAGGER_CODEGEN_SHA}\`."
    git checkout -f $SWAGGER_CODEGEN_SHA
    SWAGGER_CODEGEN_PATCH_FILE="$SWAGGER_PATCHES_DIR/$SWAGGER_CODEGEN_SHA.patch"
    if [ -f $SWAGGER_CODEGEN_PATCH_FILE ]
    then
        echo "Applying patch $SWAGGER_CODEGEN_PATCH_FILE"
        git apply $SWAGGER_CODEGEN_PATCH_FILE
    fi
else
    echo "Using lastest Swagger verion."
fi

# build
echo "Building swagger-codegen cli..."
mvn -q clean package -Dmaven.test.skip=true

# set $SWAGGER_CMD
export SWAGGER_CMD="java -jar $SWAGGER_DIR/modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"

cd ..


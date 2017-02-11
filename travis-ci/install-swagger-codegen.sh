#!/bin/bash

SWAGGER_DIR=./swagger-codegen

# download from swagger-codegen from github
git clone https://github.com/swagger-api/swagger-codegen.git $SWAGGER_DIR
cd $SWAGGER_DIR
if [ -n "${SWAGGER_CODEGEN_SHA+1}" ]
then
    echo "Using Swagger version \`${SWAGGER_CODEGEN_SHA}\`."
    git checkout $SWAGGER_CODEGEN_SHA
else
    echo "Using lastest Swagger verion."
fi

# build
echo "Building swagger-codegen cli..."
mvn -q clean package -Dmaven.test.skip=true

# set $SWAGGER_CMD
export SWAGGER_CMD="java -jar $SWAGGER_DIR/modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"

cd ..


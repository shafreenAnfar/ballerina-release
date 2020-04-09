#!/bin/sh
echo ".....Building BBE Site....."

BASEDIR=$(dirname $0)
# SITE_VERSION is the version of the Ballerina that these BBEs are belongs to. ex: v1-1 or v1-0
SITE_VERSION=$1
# BBE_GEN_DIR is the location where the generated files will be placed.
BBE_GEN_DIR=$2
# Ballerina version to be checkout from git. ex: v1.2.0
BAL_VERSION=$3
# If true, Generate BBE with jekyll front matter. If false, Generate BBE without jekyll front matter.
GEN_FOR_JEKYLL=$4

rm -rf $BBE_GEN_DIR
mkdir -p $BBE_GEN_DIR
mkdir -p $BBE_GEN_DIR/withfrontmatter
mkdir -p $BBE_GEN_DIR/withoutfrontmatter

go get github.com/russross/blackfriday
rm -rf target/dependencies/ballerina-examples

#get BBE from the language master branch
rm -rf ballerina-lang
git clone https://github.com/ballerina-platform/ballerina-lang
echo "checkout Ballerina lang repo: $BAL_VERSION"
git --git-dir=ballerina-lang/.git --work-tree=ballerina-lang/ checkout $BAL_VERSION
mkdir -p target/dependencies/ballerina-examples/

# move and rename examples/index.json to all-bbes.json
rm -rf tools/all-bbes.json
cp ballerina-lang/examples/index.json tools/all-bbes.json

mv ballerina-lang/examples target/dependencies/ballerina-examples/examples/
rm -rf ballerina-lang

#get BBE from BallerinaX
rm -rf docker
git clone https://github.com/ballerinax/docker
echo "checkout BallerinaX docker repo: $BAL_VERSION"
git --git-dir=docker/.git --work-tree=docker/ checkout $BAL_VERSION
mkdir -p target/dependencies/ballerina-examples/examples
mv docker/docker-extension-examples/examples/* target/dependencies/ballerina-examples/examples/
rm -rf docker

rm -rf kubernetes
git clone https://github.com/ballerinax/kubernetes
echo "checkout BallerinaX kubernetes repo: $BAL_VERSION"
git --git-dir=kubernetes/.git --work-tree=kubernetes/ checkout $BAL_VERSION
mkdir -p target/dependencies/ballerina-examples/examples
mv kubernetes/kubernetes-extension-examples/examples/* target/dependencies/ballerina-examples/examples/
rm -rf kubernetes

rm -rf jdbc
git clone https://github.com/ballerinax/jdbc
echo "checkout BallerinaX jdbc repo: $BAL_VERSION"
git --git-dir=jdbc/.git --work-tree=jdbc/ checkout $BAL_VERSION
mkdir -p target/dependencies/ballerina-examples/examples
mv jdbc/jdbc-extension-examples/examples/* target/dependencies/ballerina-examples/examples/
rm -rf jdbc

rm -rf awslambda
git clone https://github.com/ballerinax/awslambda
echo "checkout BallerinaX aws lambda repo: $BAL_VERSION"
git --git-dir=awslambda/.git --work-tree=awslambda/ checkout $BAL_VERSION
mkdir -p target/dependencies/ballerina-examples/examples
mv awslambda/awslambda-examples/examples/* target/dependencies/ballerina-examples/examples/
mkdir -p target/dependencies/ballerina-examples/examples/awslambda-deployment

mv target/dependencies/ballerina-examples/examples/aws-lambda-deployment/aws_lambda_deployment.bal target/dependencies/ballerina-examples/examples/awslambda-deployment/awslambda_deployment.bal
mv target/dependencies/ballerina-examples/examples/aws-lambda-deployment/aws_lambda_deployment.description target/dependencies/ballerina-examples/examples/awslambda-deployment/awslambda_deployment.description
mv target/dependencies/ballerina-examples/examples/aws-lambda-deployment/aws_lambda_deployment.out target/dependencies/ballerina-examples/examples/awslambda-deployment/awslambda_deployment.out

rm -rf awslambda

ABSOLUTE_PATH=pwd

go run $ABSOLUTE_PATH/tools/generate.go "target/dependencies/ballerina-examples" $SITE_VERSION $BBE_GEN_DIR $GEN_FOR_JEKYLL
echo "....Completed building BBE Site...."

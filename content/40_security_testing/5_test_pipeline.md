+++
title = "Test Pipeline"
chapter = false
weight = 5
+++

### AWS CodePipeline Workflow

A pipeline models our workflow from end to end. Within our pipeline we can have stages, and you can think of stages as groups of actions. An action or a plug-in is what acts upon the current revision that is moving through your pipeline. This is where the actual work happens in your pipeline. Stages can then be connected by transitions and in our console we represent these by an arrow between each stage. Our pipeline will consist of *three* stages:

![CICD](/images/pipeline-view.png)

The *Source* stage monitors for changes to our source code repository. When a change is made, we will transition to the following stage. In this case, our *Build* stage. Here we will use CodeBuild to run various tests within our pipeline. The process will check for various security issues and fail the build if any are found. These various phases are defined within our *BuildSpec* which will be found in the *buildspec.yml* in the source code directory. A sample of this file is below:

<pre>
version: 0.2
phases:
  install:
    runtime-versions:
      docker: 18
      python: 3.7
      ruby: 2.6
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - aws --version
      - $(aws ecr get-login --region $AWS_DEFAULT_REGION --no-include-email)
      - REPOSITORY_URI=$(aws ecr describe-repositories --repository-name modernization-workshop --query=repositories[0].repositoryUri --output=text)
      - COMMIT_HASH=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
      - IMAGE_TAG=${COMMIT_HASH:=latest}
      - PWD=$(pwd)   
      - echo Setting CodeCommit Credentials
      - git config --global credential.helper '!aws codecommit credential-helper $@'
      - git config --global credential.UseHttpPath true
      - git init
      - git remote add origin https://git-codecommit.us-west-2.amazonaws.com/v1/repos/modernization-workshop
      - git fetch
      - git checkout -f "$CODEBUILD_RESOLVED_SOURCE_VERSION"
      - git submodule init
      - git submodule update --recursive            
  build:
    commands:
      - echo Build started on `date`
      - echo Building the Docker image...
      - cd java-app
      - docker build -t $REPOSITORY_URI:latest .
      - docker tag $REPOSITORY_URI:latest $REPOSITORY_URI:$IMAGE_TAG
  post_build:
    commands:
      - echo Build completed on `date`
      - echo Pushing the Docker images...
      - docker push $REPOSITORY_URI:latest
      - docker push $REPOSITORY_URI:$IMAGE_TAG
      - echo Writing image definitions file...
      - echo Source DIR ${CODEBUILD_SRC_DIR}
      - printf '[{"name":"modernization-workshop","imageUri":"%s"}]' $REPOSITORY_URI:$IMAGE_TAG > ${CODEBUILD_SRC_DIR}/imagedefinitions.json
artifacts:
  files: imagedefinitions.json
</pre>

Our particular tests will be part of the build stage in the *buildspec.yml* file.  The tests will run prior to building the Docker image.  This particular point within the build stage is chosen as it allows feedback at the earliest point within the CI/CD pipeline for the type of test that is instrumented. Once the security testing is complete and successful, our build stage starts our Docker image build.  When the new Docker image has been successfully built and stored in ECR, we transition to our final stage where we deploy the image to our AWS Fargate cluster. During the *Deploy* stage, we will then consume the **imagedefinitions.json** output from the *post_build* process to sping up a new container using our newly created image into our existing cluster.

{{% notice info %}}
It is not covered in this workshop, but additional testing such as penetration test and other black box testing methods can be instrumented in the *post_build* phase within the *buildspec.yml*.  The *post_build* phase is where you would place any testing and instructions that are completed after a Docker image has been built.  
{{% /notice %}}

+++
title = "Secrets Scanning"
chapter = false
weight = 10
+++

In this stage you are going to test for secrets accidentally saved in your repository.  For this stage you'll be leveraging trufflehog, a popular open source project for finding secrets accidentally committed in repositories. It essentially searches through git repositories for secrets, digging deep into commit history and branches. It identifies secrets by running entropy checks as well as high signal regex checks. 

To get started, lets open up buildspec.yml in the left hand pane of Cloud9 and add TruffleHog scanning.

Add the following under pre_build commands:
```
- echo Installing TruffleHog
- pip install TruffleHog
```

Add the following under build commands:
```
- echo Running TruffleHog Secrets Scan
- trufflehog --regex --max_depth 1000 $APP_SOURCE_REPO_URL
```

The file should look like the following.  Note that the traffleHog scan is the first step in the build phase.  

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
      - echo Installing TruffleHog
      - pip install TruffleHog   
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
      - echo Running TruffleHog Secrets Scan
      - trufflehog --regex --max_depth 1 $APP_SOURCE_REPO_URL
      - echo Build started on `date`
      - echo Building the Docker image...
      - cd app
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

Now **SAVE** the file and run the following to push changes to our CodeCommit repository and go to CodePipeline in the console to watch our CI/CD process.

```bash
cd ~/environment/modernization-workshop/
git add .
git commit -m "Updating trufflehog max_depth value"
git push origin master
```

Once CodePipeline detects a change to your repo it will start a new process.  This time the build will fail.  The modernization-workshop repo has secrets in it's commit history, so the build will exit out with a status of 1, causing the build to fail.  While still on the Pipeline screen if you click on the **Details** button under Failed message it will take you to the build logs where you can review the failure. Click on it now and click **Link to execution details**

Near the bottom of the log the output will look similiar to this
![Truffle Hog Secret Found](/images/trufflehog-fail.png)

Let's change the buildspec.yml again so that our build passes. You typically want to set this value to a low number during your CI/CD process so only the latest commits are scanned. If you are running trufflehog offline on your local machine you may want to scan the entire commit history as you don't want to leak secrets into your repo.  We will set this back to a value of 1 so only the current commit is scanned for secrets. 

We want to change the line that has 
<pre>
- trufflehog --regex --max_depth 1000 $APP_SOURCE_REPO_URL
</pre>

to this
```bash
- trufflehog --regex --max_depth 1 $APP_SOURCE_REPO_URL
```

Now save the file and run the following to push changes to our CodeCommit repository and go to CodePipeline in the console to watch our CI/CD process.

```bash
cd ~/environment/modernization-workshop/
git add .
git commit -m "Updating trufflehog max_depth value"
git push origin master
```

If you watch CodePipeline now the CI/CD process should now succeed. 

For more information about truffleHog <https://github.com/dxa4481/truffleHog>




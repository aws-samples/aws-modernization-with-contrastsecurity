+++
title = "Deploy WebGoat to ECS Fargate"
chapter = false
weight = 20
+++

### Build and push WebGoat
Now we will build WebGoat, a purposely vulnerable web application, using the Dockerfile we copied into the `modernization-workshop` root directory, tag it and push it to ECR.

```bash
cd ~/environment/modernization-workshop
docker build -t modernization-workshop .

docker tag modernization-workshop:latest $(aws ecr describe-repositories --repository-name modernization-workshop --query=repositories[0].repositoryUri --output=text):latest


eval $(aws ecr get-login --no-include-email)
docker push $(aws ecr describe-repositories --repository-name modernization-workshop --query=repositories[0].repositoryUri --output=text):latest
```

If you watch the screen you should see the docker image build process animating the terminal

{{% notice info %}}
If successfully, you should see the message as below.
{{% /notice %}}

<pre>
The push refers to repository [1234567891011.dkr.ecr.us-west-2.amazonaws.com/modernization-workshop]
8d2f7b95f78d: Pushed 
82852e5eaa9d: Pushed 
9df07df94e41: Pushed 
aa90bcce39de: Pushed 
d9ff549177a9: Pushed 
latest: digest: sha256:4229b5fe142f6d321ef2ce16ff22070e410272ee140e7eec51540a823dcd315a size: 1369
</pre>

### Deploy WebGoat to Fargate Service
Now we are going to delete the existing ECS Fargate CloudFormation stack so we can deploy a new stack with WebGoat, a purposely vulnerable web application, instrumented with Contrast Security. We will use the rest of the existing insfrastructuree, such as the pipeline.

Let's delete the current ECS stack.
```bash
aws cloudformation delete-stack --stack-name WorkshopECS
```

Then create the new stack.
```bash
cd ~/environment/modernization-workshop/modules/40_contrast_security
aws cloudformation create-stack --stack-name WorkshopECS --template-body file://webgoat-ecs-fargate.yaml --parameters file://ecs-parameters.json --capabilities CAPABILITY_NAMED_IAM

until [[ `aws cloudformation describe-stacks --stack-name "WorkshopECS" --query "Stacks[0].[StackStatus]" --output text` == "CREATE_COMPLETE" ]]; do  echo "The stack is NOT in a state of CREATE_COMPLETE at `date`";   sleep 30; done && echo "The Stack is built at `date` - Please proceed"
```

{{% notice info %}}
This step takes approximately 3 minutes and if successfully, you should see the message as below.
{{% /notice %}}

<pre>
The stack is NOT in a state of CREATE_COMPLETE at Sun Aug  4 05:34:25 UTC 2019
The stack is NOT in a state of CREATE_COMPLETE at Sun Aug  4 05:34:55 UTC 2019
The stack is NOT in a state of CREATE_COMPLETE at Sun Aug  4 05:35:26 UTC 2019
The stack is NOT in a state of CREATE_COMPLETE at Sun Aug  4 05:35:57 UTC 2019
The stack is NOT in a state of CREATE_COMPLETE at Sun Aug  4 05:36:27 UTC 2019
The stack is NOT in a state of CREATE_COMPLETE at Sun Aug  4 05:36:58 UTC 2019
The Stack is built at Sun Aug  4 05:37:28 UTC 2019 - Please proceed
</pre>

To test, run the following query and copy the URL you obtain from the output into the address bar of a web browser.  You should see something similar to the image below.

```bash
echo http://$(aws elbv2 describe-load-balancers --names="Modernization-Workshop-LB" --query="LoadBalancers[0].DNSName" --output=text)/WebGoat
```

![WebGoat UI](/images/contrast/wg_0.png)

### Push WebGoat to Pipeline
We already have the pipeline setup that triggers off of changes ot the repository. To deploy WebGoat within the pipeline, all you need to do is run the following commands in Cloud9's terminal.

```bash
cd ~/environment/modernization-workshop
echo 'contrast_security.yaml' >> .gitignore && echo 'ecs-parameters.json' >> .gitignore
git add .
git commit -m "Changed pipeline to build WebGoat"
git push origin master
```

# Getting Started and Workshop Developer Guide
- [Getting Started and Workshop Developer Guide](#getting-started-and-workshop-developer-guide)
  - [Introduction](#introduction)
  - [Purpose of a Workshop](#purpose-of-a-workshop)
  - [High Level Overview of Building a Workshop](#high-level-overview-of-building-a-workshop)
  - [Getting a Feel of a Workshop](#getting-a-feel-of-a-workshop)
  - [Available Building Blocks](#available-building-blocks)
    - [Sample Repo](#sample-repo)
    - [Documentation](#documentation)
      - [Install Hugo](#install-hugo)
      - [Runing Hugo](#runing-hugo)
      - [Editing](#editing)
    - [CloudFormation Stacks & Templates](#cloudformation-stacks--templates)
    - [Scripts](#scripts)
    - [buildspec.yml](#buildspecyml)
    - [Sample Application](#sample-application)
  - [When You Are Done with Creating the Workshop](#when-you-are-done-with-creating-the-workshop)
  - [FAQ's](#faqs)

## Introduction
So you have decided to build a workshop.  The contents in this repo are here to help you quickly put together a workshop that people can consume to help them learn about products and services.  This repo contains sample content that can be changed or deleted to customize the workshop to your requirements.  Think of the included content or artifacts as building blocks to make creating a workshop easier.

## Purpose of a Workshop
The overall purpose of a workshop is to educate users about how to use your products or services.  What better way to learn than to let customers get hands on with building or instrumenting products or services in an actual AWS enviroment. A workshop format is used because it scales well, meaning you can deliver the content and message whenever and wherever the customer happens to be, whether the customer is at work, home, or at an AWS event they can get hands on and learn about building products and solutions. 

## High Level Overview of Building a Workshop
* Determine the message and what you want the customer to learn.  Example: I want potential customers to learn how easy it is to instrument our testing product into their build pipeline.  
* Think from a high level what componets or systems will be needed. These are the building blocks.
* Determine the workflow.  Note that we have inlcuded a lot of different components that can be used as-is, don't reinvent the wheel. 
* Change/Add/Remove content to create the workshop.
* Test the workshop.  Have several people go through the workshop to make sure all instructions, artifacts, etcetera are included and working.  
* Publish the workshop.  The workshop repo will be published at GitHub under aws-samples.  The name of the repo will vary based on the content of the workshop. Static HTML files will be stored in an S3 bucket with a DNS name pointing to the site.  When all is said and done you will have a name such as myworkshop.awsworkshop.io pointing to your workshop and an aws-samples repo hosted on GitHub.

## Getting a Feel of a Workshop
Go through the example in this sample repo, included is a working example of a workshop and flow.  Follow the directions below to clone the repo, run hugo, and view the example content.  

## Available Building Blocks

### Sample Repo
Clone this repo and push it to a repo on your own GitHub account.  
```
git clone https://github.com/jamesbland123/workshop-sample.git
```

> **Create a repo in your GitHub account and follow the instructions under "Push an existing repository from the commandline"**

### Documentation
To make the creation of web page documentation easier, we utilize tool called Hugo.  You will write your documentation/instructions using markdown language and Hugo will create static html content that can be served via S3.  Hugo additional applies a theme so that the site will have an AWS look and feel. 

#### Install Hugo
```
macOS: `brew install hugo`

Windows: `choco install hugo -confirm`
```

> For more information about installing and using Hugo, visit https://gohugo.io/getting-started/installing/ 

#### Runing Hugo
From within the root of the repo
``` 
$ hugo server
```
Using a browser go to http://localhost:1313 to view the site.  Hugo is dynamic, so as you edit the content the page in the browser will change.  Allowing you to view in real-time what the content will look like.

#### Editing 
Hugo uses the content stored in `content` to build web pages.  If you look under the directory there is a file _index.md.  This is the startig point of the documentation and is the equivalent of index.html.  Each folder becomes the high level naviagation.  The numbers are there to create an ordering of the navigation.  You will want to look at each and every file in the content directory tree and edit.

**Tips**
* To create a new page, copy another document and rename it.  The name is only important to the builders, but the actual name that shows in the navigation is the title at the top of the document.  
* If you want to create a new page between 10 and 20 you can use any number in the name as long as it's sequentially between 10 and 20.  Don't forget to appropriately set the weight in the top section.
* Use special tags such as {{% notice warning %}} {{% /notice %}} and {{% notice note %}} {{% /notice %}}. These are not markdown, but templates within Hugo to add CSS styling.
* Place all images in {repo_root}/static/images.  There are several examples of using images in the sample content.
* Provide users with sample output in `<pre> </pre>` tags so that the copy to clipboard function is not there.  No reason to copy example output to the clipboard.
* DO NOT assume that the user has any expose to AWS or your product.  Everything needs to be explained and all command or areas in the UI you want the user to go to needs to be provided.  Screen shots or examples work well for this, especially on busy UI's.  

### CloudFormation Stacks & Templates
In `/cfn` there is a directory pulled from a submodule called `vpc-with-cloud9`.  This stack template and nested stacks are publically available for usage in your workshop.  They are included here so you can see what resources are in the stacks and what resources are exported.  The template creates a basic VPC and cloud9 instance for the workshop.  

This link https://console.aws.amazon.com/cloudformation/home?region=us-west-2#/stacks/new?stackName=UnicornDevSecOpsWorkshop&templateURL=https://modernization-workshop-west-2.s3-us-west-2.amazonaws.com/devops/cfn/modernization-workshop.yaml launches the stack in the users account.  

Other CloudFormation templates are included in the directory for creating an ECS service, CodeCommit repo, RDS, and Code Pipeline.  Feel free to use these examples or delete and create your own.

### Scripts
In `/scripts` there are a couple of helper scripts.  resize.sh increases the size of the Cloud9 storage.  getting_started.sh is an example script to automate installation of pre-reqs for users.

### buildspec.yml
Sample CodeBuild buildspec.yml

### Sample Application
`/app` Sample Java EE 7 Petstore App.  See https://github.com/jamesbland123/agoncal-application-petstore-ee7

## When You Are Done with Creating the Workshop
* Cleanup unused images and files
* Verify that the workshop properly removes all resources from the AWS account
* Have several people test
* Notify your friendly AWS SA to review

## FAQ's 
Q. **Why do you use Cloud9?**

A. When conducting workshops it is often difficult to determine the state of the users workstation and validate that all dependencies and requirements are installed.  With Cloud9 we get a capable IDE and shell access to the AWS account.  Git, aws-cli, programming languages, and many other tools are pre-installed which allows us to start everyone from a known state and not have to fumble around with missing components from someones workstation.  

Q. **Can I change the License**

A. We rather you not.  The site will be posted at aws-samples and the license included in the sample is MIT, which is meant to be simple and open source friendly.  

Q. **What if I don't want to use other tools, such as Jenkins or Terraform as examples?**

A.  Great. We actually encourage you to use other tools and services as you may expect customers to use this in their environment.  Note that if you choose to use additional or alternative tools that it's easy for the end user to follow and does not detract from your main message.  As an example, if your main message is application security scanning, does it make a difference whether you use Jenkins or CodeBuild, or does the usage of one or the other add unnecessary complexity that has nothing to do with your message?  So don't reinvent the wheel and if there is already an example of instrumenting testing in CodeBuild, I would use that as the tool has nothing to do with your message.  But if your main message is instrumenting security scanning on Jenkins, then yes, use Jenkins.


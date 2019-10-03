+++
title = "Contrast Setup"
chapter = false
weight = 10
+++

### Setup Environment for WebGoat
We will now setup the environment for the Contrast Security module.

Copy the files from the `~/environment/modernization-workshop/modules/40_contrast_security/root_files` to the `~/environment/modernization-workshop` root directory.

```bash
cp ~/environment/modernization-workshop/modules/40_contrast_security/root_files/* ~/environment/modernization-workshop
```

This will copy the following three files to the root of the `modernization-workshop` directory:
* Dockerfile
* contrast_security.yaml.tpl
* entrypoint.sh
* buildspec.yaml

### Copy Contrast Credentials to Cloud9
Drag and drop the previously downloaded `contrast_security.yaml` file from your local workstation into the `~/environment/modernization-workshop/modules/40_contrast_security` directory within the Cloud9 IDE.

### Create CloudFormation ECS Parameters File
Now we will use this file to create a `ecs-parameters.json` file that will be used during the ECS CloudFormation stack creation in the next step. To create this file, we will use the following command to run the provided `credential_helper.py` helper script to convert the YAML file into a JSON file that CloudFormation will be able to understand.

```bash
cd ~/environment/modernization-workshop/modules/40_contrast_security
python credential_helper.py
```

{{% notice info %}}
If successful, you should see a similar message to the one below.
{{% /notice %}}

<pre>
##### Opening contrast_security.yaml #####
##### Converting to CloudFormation parameters file #####
##### Creating ecs-parameters.json file #####
##### Done... Completed successfully. #####
</pre>

This helper script creates an `ecs-parameters.json` file in the `~/environment/modernization-workshop` directory. Verify that this file is in the `~/environment/modernization-workshop/modules/40_contrast_security` directory.

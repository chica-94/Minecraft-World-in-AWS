# Deploy a Minecraft World in AWS
```
 _____                     __                               _                            __ _
/__   \___ _ __ _ __ __ _ / _| ___  _ __ _ __ ___     /\/\ (_)_ __   ___  ___ _ __ __ _ / _| |_
  / /\/ _ \ '__| '__/ _` | |_ / _ \| '__| '_ ` _ \   /    \| | '_ \ / _ \/ __| '__/ _` | |_| __|
 / / |  __/ |  | | | (_| |  _| (_) | |  | | | | | | / /\/\ \ | | | |  __/ (__| | | (_| |  _| |_
 \/   \___|_|  |_|  \__,_|_|  \___/|_|  |_| |_| |_| \/    \/_|_| |_|\___|\___|_|  \__,_|_|  \__|
```

![alt text](assets/img/cover.png)


## Description
Rather than spending hours following a guide on how to set up a Minecraft server, you can deploy one using this Terraform module on AWS.

The module adds a startup script to automatically launch the Minecraft server whenever the EC2 instance is turned on.

You will also need to provide the Minecraft Server [JAR Download URL](https://www.minecraft.net/en-us/download/server).

## Requirements
- [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) (tested on 1.1.3).
- [Install the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).
- [Configure the AWS CLI with an access key ID and secret access key](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html).



## Features

- Specify a URL to download the Minecraft server jar. By default, this is 1.21.4
- Choose an AWS region to deploy to. Defaults to us-west-1 (N. California).
- Choose an EC2 instance type. Defaults to t2.micro, which is the smallest type that can support the server. Charges apply.
- EC2 instance connect support for SSH access.
- Static IP address support.
- Hardened networking rules.


### EULA
This module automatically agrees to the [Minecraft EULA](https://www.minecraft.net/en-us/eula). By deploying this module, you agree to the terms in it.


## Steps
- Run `terraform init`.
- Run `terraform apply`.
- Copy the IP output by the previous command into Minecraft.
- Wait a minute for the server to spin up.
- Play.
- Irrecoverably shut everything down with `terraform destroy`.
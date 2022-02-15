# Install Jenkins using Docker and Terraform on Ubuntu in Azure Cloud.

Register in Azure and find out the last version of Ubuntu in your Region.

    az login
    az vm image list-skus --location eastus --publisher Canonical --offer UbuntuServer --output table

Install scripts from GitHub on your local computer:

    mkdir jenkins
    cd jenkins
    git clone https://github.com/sergeyanover/jenkins-docker-terraform-azure.git
    cd jenkins-docker-terraform-azure

Generate SSH public and private keys with puttygen.exe and save them in the folder "keys".
Edit file terraform.tfvars in folder "terraform" and put your public key like "ssh-rsa …" into it as a value of my_public_key. 
In addition, you should set your current IP address or your network in ip_admin.

    terraform init
    terraform plan -out main.tfplan
    terraform apply main.tfplan

Open Jenkins in a browser: https//xx.xx.xx.xx:8080 with a temporarily pair "admin - password" which you should change later.


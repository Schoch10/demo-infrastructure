# Foodtruck Demo Infrastructure

Repo houses terraform code used to build the infrastructure which runs the Foodtruck demo application. The Terraform documentation is pretty easy to follow: https://www.terraform.io/docs/index.html

We use the concept of stacks and modules to help us build our infrastructure in a modular manner. Stacks can be thought of as logical building blocks. A single stack can be made up of a number of modules. Modules are a standard Terraform feature, outlined here: https://www.terraform.io/docs/modules/index.html

As an example, consider the "Networking" stack, which lives at terraform/stacks/networking. The "Networking" stack is comprised of 4 modules: VPC, Public Subnet, Private Subnet and Bastion.


### Setup:

Before you attempt to create infrastructure using the Terraform code in this repo, you will need to configure the following on your local machine:

**1. A version of Terraform**

Terraform is an open source product which evolves very quickly. I'm currently running Terraform version 0.7.13. All release versions can be found here: https://releases.hashicorp.com/terraform/

Once you download the correct terraform file for your OS, make sure that it is contained in your PATH. As usual, the easy way to check that terraform is configured correctly is to enter "terraform -version" in your shell/command prompt which should return information about the downloaded version.

**2. Install and configure AWS Command Line Interface (CLI)**

Follow the steps outlined in this document to install the AWS CLI: http://docs.aws.amazon.com/cli/latest/userguide/installing.html

Next, you need to generate an Access Key/Secret Access Key combination. Follow the section titled "To create, modify, or delete a user's access keys" from this document: http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html

Finally, configure the AWS CLI to use the credentials above by following this document: http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html


### Example Usage

Once you are happy that you have both Terraform installed and the AWS CLI configured correctly, you can build infrastructure from this repo:

1. Clone the repo locally (git clone https://github.com/Schoch10/demo-infrastructure.git)

2. Terraform is called using a wrapper script, found at demo/terraform/deploy.sh inside the cloned repo

3. deploy.sh takes 4 arguments: -g, -t, -s, -a
   
   **-g** = geo (Example: uk or us)

   **-t** = target (Example: dev/stg)

   **-s** = stack (Example: networking)

   **-a** = action (Example: plan or apply)


4. As an example, to see a plan of the dev Networking stack in the us, our command would be:

   ```sh
   $ demo/terraform/deploy.sh -g us -t dev -s networking -a plan
   ```
   
# Infrastructure as Code with Terraform

A simple workflow for deployment adheres closely to the following steps:

- Scope - Confirm what resources need to be created for a given project.
- Author - Create the configuration file in HCL based on the scoped parameters.
- Initialize - Run terraform init in the project directory with the configuration files. This downloads the correct provider plug-ins for the project.
- Plan & Apply - Run terraform plan to verify creation process and then terraform apply to create real resources as well as the state file that compares future changes in your configuration files to what actually exists in your deployment environment.

Objectives

In this lab, you learn how to perform the following tasks:

1. Infrastructure as Code with Terraform
   1. Task 1. Build infrastructure
      1. Terraform block

## Task 1. Build infrastructure

Terraform comes pre-installed in Cloud Shell. With Terraform already installed, you can dive right in and create some infrastructure.

Start by creating your example configuration to a file named main.tf. Terraform recognizes files ending in .tf or .tf.json as configuration files and loads them when it runs.

1. Create the main.tf file:
   
 ```bash
 touch main.tf
  ```  
2. In the Editor, add the following content to the main.tf file.

 ```yaml
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {

  project = "PROJECT ID"
  region  = "REGION"
  zone    = "ZONE"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}
 ```

### Terraform block

The terraform {} block is required so Terraform knows which provider to download from the Terraform Registry. In the configuration above, the google provider's source is defined as hashicorp/google which is shorthand for registry.terraform.io/hashicorp/google.

You can also assign a version to each provider defined in the required_providers block. The version argument is optional, but recommended. It is used to constrain the provider to a specific version or a range of versions in order to prevent downloading a new provider that may possibly contain breaking changes. If the version isn't specified, Terraform automatically downloads the most recent provider during initialization.

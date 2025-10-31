# Build Infrastructure with Terraform on Google Cloud

## Interact with Terraform Modules
 
## GSP751

What is a Terraform module?
A Terraform module is a set of Terraform configuration files in a single directory. Even a simple configuration consisting of a single directory with one or more .tf files is a module. When you run Terraform commands directly from such a directory, it is considered the root module. So in this sense, every Terraform configuration is part of a module. You may have a simple set of Terraform configuration files like this:

```shell
├── LICENSE
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
```  
In this case, when you run Terraform commands from within the minimal-module directory, the contents of that directory are considered the root module.

Calling modules
Terraform commands only directly use the configuration files in one directory, which is usually the current working directory. However, your configuration can use module blocks to call modules in other directories. When Terraform encounters a module block, it loads and processes that module's configuration files.

A module that is called by another configuration is sometimes referred to as a "child module" of that configuration.

Local and remote modules
Modules can be loaded from either the local filesystem or a remote source. Terraform supports a variety of remote sources, including the Terraform Registry, most version control systems, HTTP URLs, and Terraform Cloud or Terraform Enterprise private module registries.

Module best practices
In many ways, Terraform modules are similar to the concepts of libraries, packages, or modules found in most programming languages, and they provide many of the same benefits. Just like almost any non-trivial computer program, real-world Terraform configurations should almost always use modules to provide the benefits mentioned above.

It is recommended that every Terraform practitioner use modules by following these best practices:

- Start writing your configuration with a plan for modules. Even for slightly complex Terraform configurations managed by a single person, the benefits of using modules outweigh the time it takes to use them properly.

- Use local modules to organize and encapsulate your code. Even if you aren't using or publishing remote modules, organizing your configuration in terms of modules from the beginning significantly reduces the burden of maintaining and updating your configuration as your infrastructure grows in complexity.

- Use the public Terraform Registry to find useful modules. This way you can quickly and confidently implement your configuration by relying on the work of others.

- Publish and share modules with your team. Most infrastructure is managed by a team of people, and modules are an important tool that teams can use to create and maintain infrastructure. As mentioned earlier, you can publish modules either publicly or privately. You explore how to do this in a later lab in this series.


### Task 1. Use modules from the Registry

- Create a Terraform configuration
1. To start, run the following commands in Cloud Shell to clone the example simple project from the Google Terraform modules GitHub repository and switch to the v6.0.1 branch:



```shell
git clone https://github.com/terraform-google-modules/terraform-google-network
cd terraform-google-network
git checkout tags/v6.0.1 -b v6.0.1
``` 
This ensures that you're using the correct version number.
2. On the Cloud Shell toolbar, click Open Editor.
3. In the Editor, navigate to terraform-google-network/examples/simple_project, and open the main.tf file. Your main.tf configuration should look like this:

```shell
module "test-vpc-module" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 6.0"
  project_id   = var.project_id 
  network_name = "my-custom-mode-network"
  mtu          = 1460

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "us-west1"
    },
    {
      subnet_name           = "subnet-02"
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name               = "subnet-03"
      subnet_ip                 = "10.10.30.0/24"
      subnet_region             = "us-west1"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_filter   = "false"
    }
  ]
}
```
This configuration includes one important block:

module "test-vpc-module" defines a Virtual Private Cloud (VPC), which provides networking services for the rest of your infrastructure.

- Set values for module input variables

Some input variables are required, which means that the module doesn't provide a default value; an explicit value must be provided in order for Terraform to run correctly.

Within the module "test-vpc-module" block, review the input variables you are setting. Each of these input variables is documented in the Terraform Registry. The required inputs for this module are:

- network_name: The name of the network being created
- project_id: The ID of the project where this VPC is created
- subnets: The list of subnets being created
In order to use most modules, you need to pass input variables to the module configuration. The configuration that calls a module is responsible for setting its input values, which are passed as arguments to the module block. Aside from source and version, most of the arguments to a module block set variable values.

On the Terraform Registry page for the Google Cloud network module, an Inputs tab describes all of the input variables that module supports.

- Define root input variables

The updated default argument for the project_id variable in the variables.tf configuration file now looks something like this:

```shell
variable "project_id" {
  description = "The project ID to host the network in"
  default     = "qwiklabs-gcp-01-f5caae78140a"
}
``` 
The added network_name variable in the configuration file variables.tf now looks like this:

```shell
variable "network_name" {
  description = "The name of the network to be created"
  default     = "example-vpc"
}
``` 

Navigate to the main.tf configuration file. 
You decide to use Gemini Code Assist to help you update the network_name argument to use the variable you just defined by setting the value to var.network_name and update the subnet regions from us-west1 to us-east1.

```yaml
variable "project_id" {
  description = "The project ID to host the network in"
  default     = "qwiklabs-gcp-01-f5caae78140a"
  }

variable "network_name" {
  description = "The name of the network to be created"
  default     = "example-vpc"
}
```


Add the following to the **main.tf** file:
```yaml
# [START vpc_custom_create]
module "test-vpc-module" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 6.0"
  project_id   = var.project_id # Replace this with your project ID in quotes
  network_name = "my-custom-mode-network"
  mtu          = 1460

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "us-east1"
    },
    {
      subnet_name           = "subnet-02"
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = "us-east1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name               = "subnet-03"
      subnet_ip                 = "10.10.30.0/24"
      subnet_region             = "us-east1"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_filter   = "false"
    }
  ]
}
# [END vpc_custom_create]
```
Run `terraform init` in Cloud Shell in the root directory to initialize terraform.

- Define root output values
  
```yaml
output "network_name" {
  value       = module.test-vpc-module.network_name
  description = "The name of the VPC being created"
}

output "network_self_link" {
  value       = module.test-vpc-module.network_self_link
  description = "The URI of the VPC being created"
}

output "project_id" {
  value       = module.test-vpc-module.project_id
  description = "VPC project id"
}

output "subnets_names" {
  value       = module.test-vpc-module.subnets_names
  description = "The names of the subnets being created"
}

output "subnets_ips" {
  value       = module.test-vpc-module.subnets_ips
  description = "The IP and cidrs of the subnets being created"
}

output "subnets_regions" {
  value       = module.test-vpc-module.subnets_regions
  description = "The region where subnets will be created"
}

output "subnets_private_access" {
  value       = module.test-vpc-module.subnets_private_access
  description = "Whether the subnets will have access to Google API's without a public IP"
}

output "subnets_flow_logs" {
  value       = module.test-vpc-module.subnets_flow_logs
  description = "Whether the subnets will have VPC flow logs enabled"
}

output "subnets_secondary_ranges" {
  value       = module.test-vpc-module.subnets_secondary_ranges
  description = "The secondary ranges associated with these subnets"
}

output "route_names" {
  value       = module.test-vpc-module.route_names
  description = "The routes associated with this VPC"
}

```
In Cloud Shell, navigate to your simple_project directory:
```bash
cd ~/terraform-google-network/examples/simple_project
```
Initialize your Terraform configuration:
```bash
terraform init
```
Create your VPC:
```bash
terraform apply
```
## Output:

```bash
Outputs:
network_name = "example-vpc"
network_self_link = "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-01-a68489b0625b/global/networks/example-vpc"
project_id = "qwiklabs-gcp-01-f5caae78140a"
route_names = []
subnets_flow_logs = [
  false,
  true,
  true,
]
subnets_ips = [
  "10.10.10.0/24",
  "10.10.20.0/24",
  "10.10.30.0/24",
]
subnets_names = [
  "subnet-01",
  "subnet-02",
  "subnet-03",
]
....
....
```

### Task 2. Build a module

In the last task, you used a module from the Terraform Registry to create a VPC network in Google Cloud. Although using existing Terraform modules correctly is an important skill, every Terraform practitioner also benefits from learning how to create modules. We recommend that you create every Terraform configuration with the assumption that it may be used as a module, because this helps you design your configurations to be flexible, reusable, and composable.

As you may already know, Terraform treats every configuration as a module. When you run terraform commands, or use Terraform Cloud or Terraform Enterprise to remotely run Terraform, the target directory containing Terraform configuration is treated as the root module.

In this task, you create a module to manage Compute Storage buckets used to host static websites.

Module structure
Terraform treats any local directory referenced in the source argument of a module block as a module. A typical file structure for a new module is:
```bash
├── LICENSE
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
```
Note: None of these files are required or has any special meaning to Terraform when it uses your module. You can create a module with a single .tf file or use any other file structure you like.
Each of these files serves a purpose:

- LICENSE contains the license under which your module will be distributed. When you share your module, the LICENSE file will let people using it know the terms under which it has been made available. Terraform itself does not use this file.
  
- README.md contains documentation in markdown format that describes how to use your module. Terraform does not use this file, but services like the Terraform Registry and GitHub will display the contents of this file to visitors to your module's Terraform Registry or GitHub page.
- main.tf contains the main set of configurations for your module. You can also create other configuration files and organize them in a way that makes sense for your project.
- variables.tf contains the variable definitions for your module. When your module is used by others, the variables will be configured as arguments in the module block. Because all Terraform values must be defined, any variables that don't have a default value will become required arguments. A variable with a default value can also be provided as a module argument, thus overriding the default value.
- outputs.tf contains the output definitions for your module. Module outputs are made available to the configuration using the module, so they are often used to pass information about the parts of your infrastructure defined by the module to other parts of your configuration.
Be aware of these files and ensure that you don't distribute them as part of your module:

- terraform.tfstate and terraform.tfstate.backup files contain your Terraform state and are how Terraform keeps track of the relationship between your configuration and the infrastructure provisioned by it.
- The .terraform directory contains the modules and plugins used to provision your infrastructure. These files are specific to an individual instance of Terraform when provisioning infrastructure, not the configuration of the infrastructure defined in .tf files.
- *.tfvarsfiles don't need to be distributed with your module unless you are also using it as a standalone Terraform configuration because module input variables are set via arguments to the module block in your configuration.

Create a module
1. Navigate to your home directory and create your root module by constructing a new main.tf configuration file. Then create a directory called modules that contains another folder called gcs-static-website-bucket. You work with three Terraform configuration files inside the gcs-static-website-bucket directory: website.tf, variables.tf, and outputs.tf.
```bash
cd ~
touch main.tf
mkdir -p modules/gcs-static-website-bucket
```

2. Navigate to the module directory and run the following commands to create three empty files:
```bash
cd modules/gcs-static-website-bucket
touch website.tf variables.tf outputs.tf
```
3. Inside the gcs-static-website-bucket directory, run the following command to create a file called README.md with the following content:
 ```bash
tee -a README.md <<EOF
# GCS static website bucket

This module provisions Cloud Storage buckets configured for static website hosting.
EOF
```  
4. Create another file called LICENSE with the following content:
```bash
tee -a LICENSE <<EOF
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
EOF
```
Your current module directory structure should now look like this:
```bash
main.tf
modules/
└── gcs-static-website-bucket
    ├── LICENSE
    ├── README.md
    ├── website.tf
    ├── outputs.tf
    └── variables.tf
```
5. Add this Cloud Storage bucket resource to your website.tf file inside the modules/gcs-static-website-bucket directory:

```yaml
resource "google_storage_bucket" "bucket" {
  name               = var.name
  project            = var.project_id
  location           = var.location
  storage_class      = var.storage_class
  labels             = var.labels
  force_destroy      = var.force_destroy
  uniform_bucket_level_access = true

  versioning {
    enabled = var.versioning
  }

  dynamic "retention_policy" {
    for_each = var.retention_policy == null ? [] : [var.retention_policy]
    content {
      is_locked        = var.retention_policy.is_locked
      retention_period = var.retention_policy.retention_period
    }
  }

  dynamic "encryption" {
    for_each = var.encryption == null ? [] : [var.encryption]
    content {
      default_kms_key_name = var.encryption.default_kms_key_name
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = lookup(lifecycle_rule.value.action, "storage_class", null)
      }
      condition {
        age                   = lookup(lifecycle_rule.value.condition, "age", null)
        created_before        = lookup(lifecycle_rule.value.condition, "created_before", null)
        with_state            = lookup(lifecycle_rule.value.condition, "with_state", null)
        matches_storage_class = lookup(lifecycle_rule.value.condition, "matches_storage_class", null)
        num_newer_versions    = lookup(lifecycle_rule.value.condition, "num_newer_versions", null)
      }
    }
  }
}
```
6. Navigate to the variables.tf file in your module and add the following code:
```yaml
variable "name" {
  description = "The name of the bucket."
  type        = string
}

variable "project_id" {
  description = "The ID of the project to create the bucket in."
  type        = string
}

variable "location" {
  description = "The location of the bucket."
  type        = string
}

variable "storage_class" {
  description = "The Storage Class of the new bucket."
  type        = string
  default     = null
}

variable "labels" {
  description = "A set of key/value label pairs to assign to the bucket."
  type        = map(string)
  default     = null
}


variable "bucket_policy_only" {
  description = "Enables Bucket Policy Only access to a bucket."
  type        = bool
  default     = true
}

variable "versioning" {
  description = "While set to true, versioning is fully enabled for this bucket."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "When deleting a bucket, this boolean option will delete all contained objects. If false, Terraform will fail to delete buckets which contain objects."
  type        = bool
  default     = true
}

variable "iam_members" {
  description = "The list of IAM members to grant permissions on the bucket."
  type = list(object({
    role   = string
    member = string
  }))
  default = []
}

variable "retention_policy" {
  description = "Configuration of the bucket's data retention policy for how long objects in the bucket should be retained."
  type = object({
    is_locked        = bool
    retention_period = number
  })
  default = null
}

variable "encryption" {
  description = "A Cloud KMS key that will be used to encrypt objects inserted into this bucket"
  type = object({
    default_kms_key_name = string
  })
  default = null
}

variable "lifecycle_rules" {
  description = "The bucket's Lifecycle Rules configuration."
  type = list(object({
    # Object with keys:
    # - type - The type of the action of this Lifecycle Rule. Supported values: Delete and SetStorageClass.
    # - storage_class - (Required if action type is SetStorageClass) The target Storage Class of objects affected by this Lifecycle Rule.
    action = any

    # Object with keys:
    # - age - (Optional) Minimum age of an object in days to satisfy this condition.
    # - created_before - (Optional) Creation date of an object in RFC 3339 (e.g. 2017-06-13) to satisfy this condition.
    # - with_state - (Optional) Match to live and/or archived objects. Supported values include: "LIVE", "ARCHIVED", "ANY".
    # - matches_storage_class - (Optional) Storage Class of objects to satisfy this condition. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, STANDARD, DURABLE_REDUCED_AVAILABILITY.
    # - num_newer_versions - (Optional) Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition.
    condition = any
  }))
  default = []
}
```
7. Add an output to your module in the outputs.tf file inside your module:
```yaml
output "bucket" {
  description = "The created storage bucket"
  value       = google_storage_bucket.bucket
}
```
Like variables, outputs in modules perform the same function as they do in the root module but are accessed in a different way. A module's outputs can be accessed as read-only attributes on the module object, which is available within the configuration that calls the module.
Next, update the **main.tf** file so that the terraform block looks like the following. Fill in your GCP Project ID for the bucket argument definition.

8. Return to the main.tf in your root directory and add a reference to the new module:
   
```yaml
module "gcs-static-website-bucket" {
  source = "./modules/gcs-static-website-bucket"

  name       = var.name
  project_id = var.project_id
  location   = "us-east1"

  lifecycle_rules = [{
    action = {
      type = "Delete"
    }
    condition = {
      age        = 365
      with_state = "ANY"
    }
  }]
}
```
9. In your root directory, create an outputs.tf file for your root module:
```bash
cd ~
touch outputs.tf
```

10.  Add the following code in the outputs.tf file::
```yaml
output "bucket-name" {
  description = "Bucket names."
  value       = "module.gcs-static-website-bucket.bucket"
}
```
11. Add the following code in the variables.tf file.
```yaml
variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
  default     = "qwiklabs-gcp-01-f5caae78140a"
}

variable "name" {
  description = "Name of the buckets to create."
  type        = string
  default     = "qwiklabs-gcp-01-f5caae78140a"
}
```
- Install the local module
1. Install the module and provision the bucket:
```bash
terraform init
terraform apply
```
- Upload files to the bucket
  1. Download the sample contents to your home directory:
```bash
cd ~
curl https://raw.githubusercontent.com/hashicorp/learn-terraform-modules/master/modules/aws-s3-static-website-bucket/www/index.html > index.html
curl https://raw.githubusercontent.com/hashicorp/learn-terraform-modules/blob/master/modules/aws-s3-static-website-bucket/www/error.html > error.html
```

2. Copy the files over to the cloud storage bucket qwiklabs-gcp-01-f5caae78140a:
```bash
gsutil cp *.html gs://qwiklabs-gcp-01-f5caae78140a
```

3. In a new tab in your browser, go to the website https://storage.cloud.google.com/YOUR-BUCKET-NAME/index.html, replacing YOUR-BUCKET-NAME with the name of your storage bucket qwiklabs-gcp-01-f5caae78140a.
You should see a basic HTML web page that says Nothing to see here.

4. Destroy your Terraform resources:
```bash
terraform destroy
```
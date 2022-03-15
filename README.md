terraform_oci_web
===

## Overview
Build the base of the web system on OCI.
Default value is Always free.

It creates the following resources:

***Network***
- VCN
- Public Subnet
- Private Subnet
- Internet Gateway
- Nat Gateway
- Network Security Group
- Load Balancer 

***Compute***
- Instance VM.Standard.E2.1.Micro

***Security***
- Bation Service

<img src=https://github.com/yuki9431/Demo/blob/master/terraform_oci_web/oci-web.png>


## Usage
```bash
$ git clone https://github.com/yuki9431/terraform_oci_web.git
```

Create a terraform.tfvars by referring to [terraform.tfvars_sample](./terraform.tfvars_sample).

```bash
$ vi terraform.tfvars
```

OCI Parameters can be customized by editing *.tf.
Apply at the end

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

## Requirement
```HCL
terraform {
  required_version = ">= 1.0"
  required_providers {
    oci = {
      version = ">= 4.0.0"
    }
  }
}
```

## URLs
- [Oracle Cloud Infrastructure Documentation: Terraform Provider](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm)

- [Oracle Cloud Infrastructure Documentation: Set Up OCI Terraform](https://docs.oracle.com/en-us/iaas/developer-tutorials/tutorials/tf-provider/01-summary.htm)

## Author
[Dillen H. Tomida](https://twitter.com/t0mihir0)


## License
This software is licensed under the MIT license, see [LICENSE](./LICENSE) for more information.

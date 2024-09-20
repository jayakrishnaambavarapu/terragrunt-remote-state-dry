terraform {
  source = "tfr://registry.terraform.io/jayakrishnaambavarapu/ambavarapu-vpcmodule/aws//modules/subnets?version=1.0.0"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
   config_path = "/home/ubuntu/terragrunt/remote-state-terragrunt-dry/vpc/"
}

dependencies {
  paths = ["/home/ubuntu/terragrunt/remote-state-terragrunt-dry/vpc/"]
}

inputs = {
  cidr = "10.0.1.0/24"
  vpc-id = dependency.vpc.outputs.jayakrishna-vpc-result.id
}

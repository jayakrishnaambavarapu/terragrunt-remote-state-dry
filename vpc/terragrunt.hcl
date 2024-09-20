terraform {
   source = "tfr://registry.terraform.io/jayakrishnaambavarapu/ambavarapu-vpcmodule/aws?version=1.0.0"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  cidr = "10.0.0.0/16"
}

# if we want to use only one generate block for both provider and backend s3  then we can use the below terragrunt configuration.

/*generate "provider-backend" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  profile = "jayakrishna-trusted-user"
  region = "eu-north-1"
  assume_role {
    role_arn = "arn:aws:iam::976806633434:role/terragrunt-role" 

  }

}
terraform {
  backend "s3" {
    bucket         = "ambavarapu-bucket"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "my-lock-table"
    profile = "jayakrishna-trusted-user"
    assume_role = {
       role_arn = "arn:aws:iam::976806633434:role/terragrunt-role"
    }

  }
}
EOF
}
*/

# if we want to use two generate blocks for provider and backend then we can use the below terragrunt configuration.
/*
generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  profile = "jayakrishna-trusted-user"
  region = "eu-north-1"
  assume_role {
    role_arn = "arn:aws:iam::976806633434:role/terragrunt-role"

  }

}
EOF
}

generate "backend" {
  path = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "s3" {
    bucket         = "ambavarapu-bucket"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "my-lock-table"
    profile = "jayakrishna-trusted-user"
    assume_role = {
       role_arn = "arn:aws:iam::976806633434:role/terragrunt-role"
    }

  }
}
EOF
}

*/

#Note: by using this generate block to store tfstate files in s3 bucket, before running terragrunt apply commands s3 bucket & dynamo db table needs to be created. 
# by using remote_state block  it will automatically generate s3 bucket and dynamo db table if they don't exist.





# how to use remote_state block in terragrunt for storing and locking tfstate files in s3 bucket and locking the files using dynamodb

# remote_state block:


generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  profile = "jayakrishna-trusted-user"
  region = "eu-north-1"
  assume_role {
    role_arn = "arn:aws:iam::976806633434:role/terragrunt-role"

  }

}
EOF
}

remote_state {

  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket = "ambavarapu-jk-bucket"
    key = "${path_relative_to_include()}/terraform.tfstate"
    region = "eu-north-1"
    profile = "jayakrishna-trusted-user"
    dynamodb_table = "my-lock-table"
    assume_role =  {
       role_arn = "arn:aws:iam::976806633434:role/terragrunt-role"
    }
  }
}


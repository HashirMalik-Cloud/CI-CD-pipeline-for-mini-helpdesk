terraform {
  backend "s3" {
    bucket         = "hashir-tf-remote-state"
    key            = "mini-helpdesk/dev/infra.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

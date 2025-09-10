bucket         = "hashir-tf-remote-state"   # bucket from bootstrap
key            = "mini-helpdesk/dev/infra.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-state-locks"
encrypt        = true

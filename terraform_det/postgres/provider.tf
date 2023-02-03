terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.23.1"
    }
  }
  backend "s3" {
    bucket = "terraform-life"
    key    = "kastriot_ahmeti/terraform.tfstate"
    region = "us-east-1"
    endpoint = "blob.gjirafa.dev"
    access_key = "384CXGUJPPWDTJKKLCSX"
    secret_key = "waqOwHxaH8rP5xoyad5873c8lWxkwj2tqcntjBYz"
    skip_credentials_validation = true
    force_path_style            = true
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

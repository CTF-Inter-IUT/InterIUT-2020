terraform {
  required_providers {
    docker = {
      source = "terraform-providers/docker"
    }
    local = {
      source = "hashicorp/local"
    }
    null = {
      source = "hashicorp/null"
    }
  }
  required_version = ">= 0.13"
}

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    
    ct = {
      source  = "poseidon/ct"
      version = "0.13.0"
    }
    
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}

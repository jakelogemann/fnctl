terraform {
# backend "s3" {
#   bucket  = "nixos-terraform-state"
#   encrypt = true
#   key     = "targets/terraform"
#   region  = "eu-west-1"
# }

  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "digitalocean" {}
provider "cloudflare" {}

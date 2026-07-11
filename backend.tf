terraform {
  backend "s3" {
    bucket       = "terraguard-tfstate-dpakks"
    key          = "terraguard/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true
  }
}

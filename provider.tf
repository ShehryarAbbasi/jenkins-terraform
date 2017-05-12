# Specify the provider and access details
provider "aws" {
  access_key =  "${var.access_key}"
  region     = "${var.region}"
  profile    = "_AWS_OWNED_MikeAdmin"
 // shared_credentials_file = ""
}

terraform {
  backend "s3" {
    bucket = "com.mikes.src.00play.us-east-2"
    key    = "/common/jenkins.tfstate"
    region = "us-east-2"
  }
}
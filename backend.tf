terraform {
  backend "s3" {
    bucket = "pentaho-01-bucket"
    key    = "remote.tfstate"
    region = "us-east-1"
  }
}

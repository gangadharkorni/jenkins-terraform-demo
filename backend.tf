terraform {
  backend "s3" {
    bucket = "pentaho-01-bucket"
    key    = "remote.tfstate"
    region = "ap-south-1"
  }
}

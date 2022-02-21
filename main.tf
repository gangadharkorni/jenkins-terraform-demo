provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIA4VEXDOEIQLMQPOMA"
  secret_key = "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"
}

## creating new ec2 instance

resource "aws_instance" "pentaho" {
  count = 4
  ami           = "ami-0ffc7af9c06de0077"
  instance_type = "t2.small"
  vpc_security_group_ids = ["${aws_security_group.terra_security_group.id}"]


  tags = {
    Name = "pentaho${count.index}-ec2"
  }
}
resource "aws_security_group" "terra_security_group" {
  name        = "terra_security_group"
  description = "create a security group for ec2 instance"
  vpc_id      = "vpc-0f0d85950d7cd8c57"

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


 egress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "terra_security_group"
  }
}
## creating ebs volume


resource "aws_ebs_volume" "terra" {
  availability_zone = "ap-south-1a"
  size              = 1

  tags = {
    Name = "ter_ebs"
  }
}

## s3 bucket

#resource "aws_s3_bucket" "penthaho_bucket" {
#  bucket = "penthaho-bucket"

 #tags = {
  # Name        = "penthaho_new_bucket"
  # Environment = "Dev"
  #}
#}



## elastic ip
resource "aws_eip" "ip" {
  count    = 4
  instance = "${element(aws_instance.pentaho.*.id, count.index)}"
  vpc      = true
}



## route 53

# resource "aws_route53_record" "penthaho_route" {
 # zone_id = "$[aws_route53_zone.primary.zone_id]"
  #name    = "penthaho_route.dev.com"
  #type    = "A"
  #ttl     = "300"
#}
resource "aws_route53_zone" "primary" {
  name = "pentaho_route.dev.com"
}
resource "aws_route53_record" "dns_a" {
  zone_id = "${aws_route53_zone.primary.id}"
  name    = "examplerecord"
  type    = "A"
  ttl     = "30"

  records =   "${aws_eip.ip.*.public_ip}"
}
## dynamodb table


#resource "aws_dynamodb_table" "my_first_table" {
  #name        = "terraformlock"
  #billing_mode = "PAY_PER_REQUEST"
  #hash_key       = "employee-id"
  #attribute {
 #   name = "employee-id"
  #  type = "S"
 # }
#}



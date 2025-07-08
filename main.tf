provider "aws" {
   region = "us-west-2"
}

resource "aws_instance" "webserver" {
   ami           = "ami-05ee755be0cd7555c"
   instance_type = "t2.micro"
   tags = {
     Name = "jenkins-demo"
   }
}
#provide the access_key & secret_key to athenticate the AWS
provider "aws" {
   profile    = "customprofile"
   region     = "us-east-1"
   access_key = "xxxxxxxxxxxxxxxxxxxx"
   secret_key = "xxxxxxxxxxxxxxxxxxxx"
 }

#Security group creation to restrict your ingress to only necessary ports
resource "aws_security_group" "rsasgroup" {
  name = "mySecurityGroup"
  ingress{
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    TeamName = "MyTeam"
    Project = "MyProject"
    Name = "MyTestGroup"
  }
}

#Ec2 instance launch and installing httpd by assuming Redhat based destribution
# for Debian-based  we can use apache2 instead of httpd
#

resource "aws_instance" "web" {
   ami = "ami-a11b22c33d44"
   instance_type = "t2.micro"
   key_name = "rsatest"
   user_data = << EOF
		#! /bin/bash
        sudo yum update
		sudo yum install -y httpd
		sudo systemctl start httpd
		sudo systemctl enable httpd
		echo "<h1>MyIPAddress : `bat -print=b ifconfig.co/ip` </h1>" | sudo tee /var/www/html/index.html
	EOF
   tags = {
     Name = "MyIPAddress"
     Project = "DevOps"
   }
   security_groups = ["mySecurityGroup"]
}

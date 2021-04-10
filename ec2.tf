
##EC2.tf FILE

resource "aws_instance" "example" {
ami = "ami-02354e95b39ca8dec"
instance_type = "t2.micro"
key_name = "Amazon Linux2"
count = 1


subnet_id = "${aws_subnet.TFPublic.id}"
vpc_security_group_ids = [ "${aws_security_group.Testing_TerrafomNew.id}" ]
associate_public_ip_address = true
#vpc_security_group_ids = ["sg-06b55d72ae47952a6"]
user_data = <<-EOF
	    #!/bin/bash
sudo yum update -y
sudo yum install httpd -y
echo "WEB SERVER STARTED SUCCESSFULLY" > /var/www/html/index.html
sudo yum update
sudo yum install -y amazon-linux-extras
sudo amazon-linux-extras enable php7.4
sudo yum clean metadata
sudo yum install php php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip,imap} -y
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
sudo echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
sudo service httpd enable
sudo service httpd restart
            EOF

tags = {
Name = "Testing TerrafomNew"
}
}



#resource "aws_security_group" "terra-vm-SG" {
resource "aws_security_group" "Testing_TerrafomNew" {
vpc_id = "${aws_vpc.TFmain.id}"

name = "Testing TerrafomNew"
description = "Testing TerrafomNew inbound traffic"

 ingress {
   description = "TLS from VPC"
   from_port   = 22
   to_port     = 22
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

ingress {
   description = "TLS from VPC"
   from_port   = 443
   to_port     = 443
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
ingress {
   description = "TLS from VPC"
   from_port   = 80
   to_port     = 80
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }

 tags = {
   Name = "terra-vm-SG"
   Name = "testing_terrafomnew"
   description = "terra-vm-SG"  
 }
}


#resource "aws_network_interface_sg_attachment" "sg_attachment" {
 # security_group_id    = "${aws_security_group.terra-vm-SG.id}"
  #network_interface_id = "${aws_instance.example.primary_network_interface_id}"
#}

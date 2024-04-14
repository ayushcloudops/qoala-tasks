resource "aws_instance" "ec2-1" {
    ami                                  =  "ami-0a1b648e2cd533174"
    associate_public_ip_address          =  true
    availability_zone                    =  "ap-south-1a"
    instance_initiated_shutdown_behavior =  "stop"
    instance_type                        =  "t3.medium"
    key_name                             =  "akash"
    subnet_id                            =  var.subnet_id
    tags = {
        Name                             =  "ec2-qoala"
  }
    user_data = <<EOF
    #!/bin/bash
    sudo apt update
    sudo apt install nginx
    EOF
}
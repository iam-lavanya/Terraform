provider "aws" {
    region = "us-east-1"
  
}
resource "aws_instance" "ansible-managed-ec2" {
    ami = "ami-0005e0cfe09cc9050"
    instance_type = "t2.micro"
    associate_public_ip_address = "true"

    }
output "op1"{
value = aws_instance.ansible-managed-ec2.public_ip
}
    
resource "local_file" "inventory" {
    content  = aws_instance.ansible-managed-ec2.public_ip
    filename = "inventory"
}

resource "null_resource" "nullremote1" {
depends_on = [aws_instance.ansible-managed-ec2] 
connection {
 type     = "ssh"
 user     = "ec2-user"
 private_key = "${file("Docker.pem")}"
 host = "54.161.204.225"
} 
provisioner "file" {
    source      = "inventory"
    destination = "/home/ec2-user/ansi_terraform/inventory"
       }
         provisioner "remote-exec" {
    inline = [
      "cd /home/ec2-user/ansi_terraform/",
      "ansible-playbook -i inventory playbook.yml"
    ]
      
} 
}
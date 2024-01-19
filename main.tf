resource "local_file" "ip" {
    content  = aws_instance.os1.public_ip
    filename = "ip.txt"
}
provisioner "remote-exec" {
 inline = [
 "cd /root/ansible_terraform/aws_instance/",
 "ansible-playbook instance.yml"
]
}
resource "local_file" "ip" {
    content  = aws_instance.os1.public_ip
    filename = "ip.txt"
}
#connecting to the Ansible control node using SSH connection
resource "null_resource" "nullremote1" {
depends_on = [aws_instance.os1] 
connection {
 type     = "ssh"
 user     = "root"
 password = "${var.password}"
     host= "${var.host}" 
}
#copying the ip.txt file to the Ansible control node from local system 
provisioner "file" {
    source      = "ip.txt"
    destination = "/root/ansible_terraform/aws_instance/ip.txt"
       }
}
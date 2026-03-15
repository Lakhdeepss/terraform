provider "aws" {
  region = "ap-southeast-2"
}


resource "aws_key_pair" "terraform-key" {
  key_name   = "terraform-key"
  public_key = file("C:\\Users\\DELL\\.ssh\\id_rsa.pub")
}

resource "aws_security_group" "ssh" {
  name = "ssh"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access from anywhere"
  }

}
resource "aws_instance" "terraform_instance" {
  ami                    = "ami-0312bcacbe51d03c8"
  instance_type          = "t3.small"
  key_name               = aws_key_pair.terraform-key.key_name
  vpc_security_group_ids = [aws_security_group.ssh.id]

  tags = {
    Name = "Terraform-instance"
  }

}

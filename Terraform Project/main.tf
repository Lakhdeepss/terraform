resource "aws_vpc" "terraform_vpc" {
  cidr_block = var.cidr
}


resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

}


resource "aws_subnet" "sub2" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.terraform_vpc.id

}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "web_Sg" {
  name   = "web_sg"
  vpc_id = aws_vpc.terraform_vpc.id

  ingress {
    description = "tls from vpc"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "ssh from vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    description = "all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "web_sg"
  }
}

resource "aws_s3_bucket" "s3b" {
  bucket = "lakhdeep-terraform-s3-bucket-123"

}








resource "aws_instance" "webserver1" {
  ami                    = "ami-0ec10929233384c7f"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.sub1.id
  vpc_security_group_ids = [aws_security_group.web_Sg.id]
  user_data_base64       = base64encode(file("userdata.sh"))
}
resource "aws_instance" "webserver2" {
  ami                    = "ami-0ec10929233384c7f"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.sub2.id
  vpc_security_group_ids = [aws_security_group.web_Sg.id]
  user_data_base64       = base64encode(file("userdata.sh"))
}


resource "aws_lb" "my_lb" {
  name               = "my-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_Sg.id]
  subnets            = [aws_subnet.sub1.id, aws_subnet.sub2.id]
  tags = {
    name = "my-lb"
  }
}


resource "aws_lb_target_group" "tG" {
  name     = "myTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.terraform_vpc.id

  health_check {
    path = "/"
    port = "traffic-port"

  }
}

resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.tG.arn
  target_id        = aws_instance.webserver1.id
  port             = 80

}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.tG.arn
  target_id        = aws_instance.webserver2.id
  port             = 80

}


resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tG.arn
  }
}

output "loadBalancerOutput" {
  value = aws_lb.my_lb.dns_name

}


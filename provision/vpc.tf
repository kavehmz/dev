resource "aws_vpc" "dev_vpc" {
  cidr_block = "172.16.0.0/16"

  enable_dns_hostnames = true
  tags = {
    Name = "dev"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "dev"
  }
}

resource "aws_default_route_table" "default_route" {
  default_route_table_id = aws_vpc.dev_vpc.default_route_table_id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
    }

  tags = {
    Name = "dev"
  }
}


resource "aws_subnet" "dev_us_east_1a" {
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "dev"
  }
}

resource "aws_security_group" "all_access" {
  name = "all_access"
  description = "All Access"
  vpc_id = "${aws_vpc.dev_vpc.id}"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
  }
}
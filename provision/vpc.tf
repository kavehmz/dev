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

resource "aws_subnet" "dev_us_east_1a" {
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "dev"
  }
}

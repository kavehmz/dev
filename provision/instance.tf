data "aws_ami" "debian" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-10-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["136693071363"]
}


resource "aws_instance" "dev" {
  count         = 0
  ami           = data.aws_ami.debian.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.dev_us_east_1a.id
  # public_dns = true

  associate_public_ip_address = true

  # a bug is preventing me to create the security group in TF in arm arch.
  vpc_security_group_ids = ["sg-007ae9d2199ea1f25", "sg-09bafcc41daecda49"]

  key_name = "Kaveh"

  tags = {
    Name = "dev"
  }
}

output "dev_ip" {
  value = aws_instance.dev.*.public_ip
}

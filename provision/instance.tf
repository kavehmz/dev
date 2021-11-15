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

# resource "aws_instance" "dev" {
resource "aws_spot_instance_request" "dev" {
  count = var.dev_count

  wait_for_fulfillment = true
  spot_type            = "one-time"

  ami           = data.aws_ami.debian.id
  instance_type = "m1.large"

  subnet_id     = aws_subnet.dev_us_east_1a.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.all_access.id]
  key_name = "dev"

  root_block_device {
    volume_size = 20
    tags = {
      "Name" = "dev${count.index}"
    }
  }

  ephemeral_block_device {
    device_name  = "xvdb"
    no_device    = false
    virtual_name = "ephemeral0"
  }

  user_data = file("scripts/base.sh")
}

resource "aws_ec2_tag" "dev_tags" {
  count = var.dev_count
  resource_id = aws_spot_instance_request.dev[count.index].spot_instance_id
  key         = "Name"
  value       = "dev${count.index}"
}

resource "aws_ec2_tag" "dev_root_tags" {
  count = var.dev_count
  resource_id = aws_spot_instance_request.dev[count.index].root_block_device.0.volume_id
  key         = "Name"
  value       = "dev${count.index}"
}


output "dev_ip" {
  value = aws_spot_instance_request.dev.*.public_ip
}

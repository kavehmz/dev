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
  wait_for_fulfillment = true
  spot_type            = "one-time"

  count         = var.dev_count
  ami           = data.aws_ami.debian.id
  instance_type = "m1.large"
  subnet_id     = aws_subnet.dev_us_east_1a.id

  associate_public_ip_address = true


  vpc_security_group_ids = [aws_security_group.all_access.id]

  key_name = "Kaveh"

  tags = {
    Name = "dev"
  }

  user_data = file("scripts/base.sh")

  ephemeral_block_device {
    device_name  = "xvdb"
    no_device    = false
    virtual_name = "ephemeral0"
  }

  provisioner "file" {
    source      = "scripts/kind-build.sh"
    destination = "~/kind-build.sh"

    connection {
      type     = "ssh"
      user     = "admin"
      private_key = file("~/.ssh/id_rsa")
      host = self.public_ip
    }
  }
}


output "dev_ip" {
  value = aws_spot_instance_request.dev.*.public_ip
}

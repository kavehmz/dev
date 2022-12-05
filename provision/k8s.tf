resource "aws_spot_instance_request" "dev_k8s_server" {
  count = var.k8s_enabled ? 1 : 0

  wait_for_fulfillment = true
  spot_type            = "one-time"

  ami           = data.aws_ami.debian.id
  instance_type = "m1.large"

  subnet_id                   = aws_subnet.dev_us_east_1a.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.all_access.id]

  key_name = "dev"
  tags = {
    Name = "dev_k8s_server"
  }
}


output "dev_k8s_server_ip" {
  value = aws_spot_instance_request.dev_k8s_server.*.public_ip
}


resource "aws_spot_instance_request" "dev_k8s_workders" {
  count = var.k8s_enabled ? var.dev_k8s_workders_count : 0

  wait_for_fulfillment = true
  spot_type            = "one-time"

  ami           = data.aws_ami.debian.id
  instance_type = "m1.large"

  subnet_id                   = aws_subnet.dev_us_east_1a.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.all_access.id]

  key_name = "dev"
  tags = {
    Name = "dev"
  }
}

output "dev_k8s_workers_ip" {
  value = aws_spot_instance_request.dev_k8s_workders.*.public_ip
}

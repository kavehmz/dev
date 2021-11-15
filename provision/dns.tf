resource "cloudflare_record" "dev" {
  count   = var.dev_count
  zone_id = var.cloudflare_zone_id
  name    = "dev${count.index}"
  value   = aws_spot_instance_request.dev[count.index].public_ip
  type    = "A"
  ttl     = 120
}

resource "cloudflare_record" "dev_k8s_server" {
  count   = var.k8s_enabled ? 1: 0
  zone_id = var.cloudflare_zone_id
  name    = "k8s-server"
  value   = aws_spot_instance_request.dev_k8s_server[count.index].public_ip
  type    = "A"
  ttl     = 120
}

resource "cloudflare_record" "dev_k8s_workers" {
  count   = var.k8s_enabled ? var.dev_k8s_workders_count: 0
  zone_id = var.cloudflare_zone_id
  name    = "k8s-workder${count.index}"
  value   = aws_spot_instance_request.dev_k8s_workders[count.index].public_ip
  type    = "A"
  ttl     = 120
}

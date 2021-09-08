resource "cloudflare_record" "dev" {
  count   = var.devcount
  zone_id = var.cloudflare_zone_id
  name    = "dev${count.index}"
  value   = aws_spot_instance_request.dev[count.index].public_ip
  type    = "A"
  ttl     = 120
}

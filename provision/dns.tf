resource "cloudflare_record" "foobar" {
    count   = var.devcount
    zone_id = var.cloudflare_zone_id
    name    = "dev${count.index}"
    value   = aws_instance.dev[count.index].public_ip
    type    = "A"
    ttl     = 120
}

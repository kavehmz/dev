variable cloudflare_email {
    type = string
}

variable cloudflare_api_token {
    type = string
    sensitive = true
}

variable cloudflare_zone_id {
    type = string
    sensitive = true
}

variable "devcount" {
    type = number
    default = 1
}

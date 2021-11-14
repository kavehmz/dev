variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_zone_id" {
  type      = string
  sensitive = true
}

variable "dev_count" {
  type    = number
  default = 1
}

variable "dev_k8s_workders_count" {
  type    = number
  default = 1
}


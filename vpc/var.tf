variable "availability_zone_names" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1a"]
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  type        = bool
  default     = true 
}


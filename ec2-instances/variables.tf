variable "ssh_cidr" {
  description = "CIDR block allowed to connect to EC2 over SSH"
  type        = string
  default     = "0.0.0.0/0"
}
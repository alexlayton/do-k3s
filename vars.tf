variable "api_token" {
  description = "DigitalOcean API token"
  type        = string
}

variable "public_key" {
  description = "Public SSH key to add to all droplets"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key" {
  description = "Private SSH key"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "data_dir" {
  description = "Directory to store kubeconfig"
  type        = string
  default     = "data"
}

variable "server_size" {
  description = "Server droplet size e.g. s-1vcpu-1gb"
  type        = string
  default     = "s-1vcpu-1gb"
}

variable "worker_size" {
  description = "Worker droplet size e.g. s-1vcpu-1gb"
  type        = string
  default     = "s-1vcpu-1gb"
}

variable "worker_count" {
  description = "Number of worker droplets to create"
  type        = number
  default     = 3
}

variable "image" {
  description = "Image slug to use on all droplets e.g. ubuntu-21-10-x64"
  type        = string
  default     = "ubuntu-21-10-x64"
}

variable "region" {
  description = "Region to locate all droplets"
  type        = string
  default     = "lon1"
}

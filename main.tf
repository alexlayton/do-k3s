terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.api_token
}

resource "digitalocean_ssh_key" "default" {
  name       = "k3s-ssh-key"
  public_key = file(var.public_key)
}

resource "digitalocean_vpc" "default" {
  name   = "k3s-vpc"
  region = var.region
}

resource "random_string" "node_token" {
  length  = 16
  special = true
}

resource "digitalocean_droplet" "server" {
  image    = var.image
  name     = "k3s-server"
  region   = var.region
  size     = var.server_size
  vpc_uuid = digitalocean_vpc.default.id
  ssh_keys = [
    digitalocean_ssh_key.default.fingerprint
  ]

  connection {
    type        = "ssh"
    host        = self.ipv4_address
    user        = "root"
    private_key = file(var.private_key)
  }

  provisioner "remote-exec" {
    inline = [
      "curl -sfL https://get.k3s.io | K3S_TOKEN=${random_string.node_token.result} sh -"
    ]
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -i ${var.private_key} root@${self.ipv4_address}:/etc/rancher/k3s/k3s.yaml ${var.data_dir}/k3s.yaml"
  }

  provisioner "local-exec" {
    command = "sed -i '' 's/127.0.0.1/${self.ipv4_address}/' ${var.data_dir}/k3s.yaml"
  }
}

resource "digitalocean_droplet" "workers" {
  count    = var.worker_count
  image    = var.image
  name     = "k3s-worker-${count.index + 1}"
  region   = var.region
  size     = var.worker_size
  vpc_uuid = digitalocean_vpc.default.id
  ssh_keys = [
    digitalocean_ssh_key.default.fingerprint
  ]
  depends_on = [
    digitalocean_droplet.server
  ]

  connection {
    type        = "ssh"
    host        = self.ipv4_address
    user        = "root"
    private_key = file(var.private_key)
  }

  provisioner "remote-exec" {
    inline = [
      "curl -sfL https://get.k3s.io | K3S_URL=https://${digitalocean_droplet.server.ipv4_address_private}:6443 K3S_TOKEN=${random_string.node_token.result} sh -"
    ]
  }
}

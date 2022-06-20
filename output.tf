output "server" {
  value = digitalocean_droplet.server.ipv4_address
}

output "workers" {
  value = digitalocean_droplet.workers[*].ipv4_address
}

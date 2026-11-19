provider "docker" {
  host = "ssh://${var.ssh_user}@${var.ssh_host}"
  ssh_opts = [
    "-o", "StrictHostKeyChecking=no",
    "-o", "UserKnownHostsFile=/dev/null",
    "-i", "${path.cwd}/keys/authorized_key",
  ]
}

# Pulls the image
resource "docker_image" "ubuntu_nginx" {
  name = "ubuntu/nginx:latest"
}

# Create a container
resource "docker_container" "foo" {
  name  = "foo"
  image = docker_image.ubuntu_nginx.image_id

  ports {
    internal = 80
    external = 80
  }
}

provider "docker" {
  host = "ssh://${var.ssh_user}@${var.ssh_host}"
  ssh_opts = [
    "-o", "StrictHostKeyChecking=no",
    "-o", "UserKnownHostsFile=/dev/null",
    "-i", "${path.cwd}/keys/authorized_key",
  ]
}

resource "terraform_data" "upload_nginx" {
  triggers_replace = [
    filesha256("${path.cwd}/../../nginx/default.conf"),
    filesha256("${path.cwd}/../../nginx/html/index.html"),
    filesha256("${path.cwd}/../../nginx/html/404.html"),
    filesha256("${path.cwd}/../../nginx/html/style.css")
  ]

  connection {
    type        = "ssh"
    user        = var.ssh_user
    host        = var.ssh_host
    private_key = file("${path.cwd}/keys/authorized_key")
  }

  provisioner "file" {
    source      = "${path.cwd}/../../nginx"
    destination = "/home/${var.ssh_user}"
  }
}

resource "docker_image" "nginx" {
  name          = data.docker_registry_image.nginx.name
  pull_triggers = [data.docker_registry_image.nginx.sha256_digest]
}

resource "docker_container" "nginx" {
  name  = "nginx"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = 80
  }

  # Montage du dossier contenant index.html, 404.html et style.css
  mounts {
    type   = "bind"
    target = "/usr/share/nginx/html"
    source = "/home/${var.ssh_user}/nginx/html"
  }

  # Remplacement de la config par défaut d'Nginx
  mounts {
    type   = "bind"
    target = "/etc/nginx/conf.d/default.conf"
    source = "/home/${var.ssh_user}/nginx/default.conf"
  }
}

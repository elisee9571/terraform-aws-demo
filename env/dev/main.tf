module "networking" {
  source = "../../modules/networking"

  env          = "dev"
  project_name = var.project_name
}

module "docker" {
  source = "../../modules/docker"

  ssh_host = module.networking.instance_public_ip
}

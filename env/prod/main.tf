module "networking" {
  source = "../../modules/networking"

  env          = "prod"
  project_name = var.project_name
}

module "docker" {
  source = "../../modules/docker"

  ssh_host = module.networking.instance_public_ip
}

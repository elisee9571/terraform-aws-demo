module "networking" {
  source = "../../modules/networking"

  env          = "staging"
  project_name = var.project_name
}

module "docker" {
  source = "../../modules/docker"

  ssh_host         = module.networking.instance_public_ip
  db_name          = var.db_name
  db_user          = var.db_user
  db_password      = var.db_password
  db_root_password = var.db_root_password
}

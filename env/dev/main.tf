module "networking" {
  source = "../../modules/networking"

  env          = "dev"
  project_name = var.project_name
  owner        = var.owner
}

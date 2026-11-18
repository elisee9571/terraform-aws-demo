module "networking" {
  source = "../../modules/networking"

  env          = "prod"
  project_name = var.project_name
}

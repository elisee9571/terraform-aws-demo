module "networking" {
  source = "../../modules/networking"

  env = "staging"
  project_name = var.project_name
}

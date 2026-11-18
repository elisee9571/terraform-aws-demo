variable "env" {
  type = string
  default = "dev"

  validation {
    condition = contains(["dev", "staging", "prod"], var.env)
    error_message = "L'environnement doit comprendre ['dev', 'staging', 'prod']"
  }
}

variable "project_name" {
  type = string
  default = "demo"
}

variable "owner" {
  type = string
  default = "terraform"
}

variable "region" {
  type = string
  default = "eu-west-3"
}

variable "availability_zones" {
  type = list(string)
  default = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
}

variable "cidr_blocks" {
  type = list(string)
  default = ["10.0.0.0/16", "10.0.1.0/24"]
}

variable "instance_types" {
  type = map(string)
  default = {
    "dev" = "t3.micro",
    "staging" = "t3.micro",
    "prod" = "t3.micro"
  }
}

provider "docker" {
  # Configure Docker provider settings if required
}

resource "docker_image" "postgres" {
  name         = "postgres"
  build        = {
    context    = "${path.module}/templates/app.py"
    dockerfile = "${path.module}/templates/Dockerfile"
  }
}

resource "null_resource" "jenkins_deploy" {
  # Provision a null_resource to trigger Jenkins deployment
  triggers = {
    docker_image_id = docker_image.postgres.id
  }

  provisioner "local-exec" {
    command = "curl -X POST -u "{var.jenkins_user}":"{var.jenkins_password}" "{var.jenkins_url}"
    
  }
}

module "label" {
  source = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=tags/0.2.1"

  namespace  = "${var.namespace}"
  name       = "network"
  stage      = "${var.stage}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"
}

data "aws_availability_zones" "available" {
  state = "available"
}


data "aws_region" "current" {}

module "vpc" {
  namespace  = "${module.label.namespace}"
  stage      = "${module.label.stage}"
  name       = "${module.label.name}"
  cidr_block = "${var.cidr_block}"
}

module "subnets" {
  namespace = "${module.label.namespace}"
  stage     = "${module.label.stage}"
  name      = "${module.label.name}"

  #region              = "${var.region}"
  region              = "${data.aws_region.current.name}"
  availability_zones  = ["${slice(data.aws_availability_zones.available.names, 0, local.max_availability_zones)}"]
  vpc_id              = "${module.vpc.vpc_id}"
  igw_id              = "${module.vpc.igw_id}"
  cidr_block          = "${var.cidr_block}"
  nat_gateway_enabled = "false"
}


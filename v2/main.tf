// les credentials AWS sont dev variables environnement

//define provider

provider "aws" {
  region = "eu-central-1"
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
  alias      = "production"
}


terraform {
  backend "s3" {
    bucket               = "nicocaill13-terraform-state"
    workspace_key_prefix = "api"
    key                  = "state"
    region               = "eu-central-1"
  }
  required_providers {
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.0"
    }
  }
}

module "get-aws-ami" {
  source = "./modules/get-aws-ami"
  env    = "${var.AMI} ${var.ENV}"
}

// create ec2 on public subnet
module "public-ec2" {
  source                 = "./modules/create-aws-ec2"
  key_name               = var.ENV == "production" ? var.key_name.prod : var.key_name.dev
  ami_id                 = module.get-aws-ami.ami_id
  subnet                 = (var.PUBLIC == false) ? var.subnet_private.1 : var.subnet_public.1
  vpc_security_group_ids = (var.PUBLIC == false) ? [var.vpc_security_group_ids.1] : [var.vpc_security_group_ids.0]
  env_tag                = var.ENV
  slug_tag               = "${var.SLUG} ${var.ENV}"
  name_tag               = var.NAME
  instance_type          = var.INSTANCE
}

// update the source
resource "null_resource" "ssh_manager" {
  depends_on = [module.public-ec2]
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = <<EOT
    ./modules/create-aws-ec2/check22.sh ${module.public-ec2.privateIp}   
    rsync -avz --exclude '.git*' --exclude '.git/' --exclude 'terraform/' --exclude 'tests/' --exclude 'src/' \
      --exclude 'dist/tests/' --exclude 'apidoc.json' --exclude 'eslintrc.json' --exclude 'tsconfig.json' \
      --exclude 'README.md.json'  --exclude 'Dockerfile'  --exclude 'docker-compose-dev.yml' --delete \
      -e "ssh -o StrictHostKeyChecking=no -i ~/${(var.ENV == "production") ? var.key_name.prod : var.key_name.dev}.pem" \
      ../ github@${module.public-ec2.privateIp}:/var/www/project
    EOT  
  }
}

// créer un load balancer
module "create-aws-load-balancer" {
  source             = "./modules/create-aws-load-balancer"
  vpc_id             = "vpc-bb1c8cd1"
  name               = module.public-ec2.tags_name
  load_balancer_name = module.public-ec2.tags_name
  internal           = false
  security_group     = [var.vpc_security_group_ids.0]
  subnet             = [var.subnet_public.0, var.subnet_public.1, var.subnet_public.2]
  env                = var.ENV
  instance_id        = module.public-ec2.instanceId
  arn                = module.create-aws-load-balancer.target_group_arn
  depends_on         = [module.public-ec2]
}

module "generate-account" {
  source     = "./modules/create-encrypt-account"
  depends_on = [module.public-ec2]
  acme_email = "nicolas.c@smilers.com"
  providers = {
    acme.production = acme.production
  }
}

module "create-dns" {
  source          = "./modules/create-dns-name"
  depends_on      = [module.generate-account]
  dns_domain_name = var.DOMAIN
  env             = var.ENV
  alias           = var.ALIAS
  dns_cname_value = module.create-aws-load-balancer.dns_name
}

module "create-tls" {
  source          = "./modules/create-tls-certificat"
  depends_on      = [module.create-dns]
  account_key_pem = module.generate-account.registration_private_key_pem
  common_name     = module.create-dns.fqdn_domain_name
  providers = {
    acme.production = acme.production

  }
}

module "create-https-listener" {
  source            = "./modules/create-https-listener"
  depends_on        = [module.create-tls]
  certificate_body  = module.create-tls.certificate_pem
  certificate_chain = module.create-tls.certificate_issuer_pem
  private_key       = module.create-tls.certificate_private_key_pem
  arn               = module.create-aws-load-balancer.arn
  id                = module.create-aws-load-balancer.dns_name
  target_group_arn  = module.create-aws-load-balancer.target_group_arn
  env               = var.ENV
  alias             = var.ALIAS
  dns_domain_name   = "smilers-backend.com"
}

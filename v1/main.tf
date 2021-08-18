// on définit les credentials AWS
provider "aws" {
  region = "eu-west-1"
  access_key = var.accessKey
  secret_key = var.secretKey
}

// récupère la dernière AMI grace au balise
// définit le nom de la nouvelle AMI à créer selon nomenclature KC
module "get-aws-ami"{
  source = "./modules/get-aws-ami"
  env = var.env
}

// récupère EC2 en fonction
// créé un nouveau EC2
// effectue les opérations de maj des sources
module "create-aws-ec2"{
  source = "./modules/create-aws-ec2"
  env = var.env
  key_name = var.key_name
  ami_id = module.get-aws-ami.ami_id
  subnet = var.subnet
  vpc_security_group_ids = var.vpc_security_group_ids
  isDocker = var.isDocker
  name = var.name
  directory = var.directory
}

// créé AMI depuis le EC2 à jour
// attends que la connection SSH soit OK
module "create-aws-ami"{
  source = "./modules/create-aws-ami"
  name = module.get-aws-ami.ami_name
  env = var.env
  source_instance_id = module.create-aws-ec2.ec2CreatingId
  host = module.create-aws-ec2.ec2CreatingIp
  depends_on = [module.create-aws-ec2]
}

// retourne les Targets group ou l'autoscaling
module "get-elb-tg"{
  source = "./modules/get-elb-tg"
  tagName = module.create-aws-ec2.ec2RunningTagName
  nbTarget = var.nbTarget
  port = var.port
}

// Ce module ne s'éxecute que si l'instance n'est pas sous un autoscaling
// envoie le nouveau EC2 dans n TG
// retire l'ancien EC2 de n TG
module "create-elb-tg"{
  count = module.get-elb-tg.testAws.result.autoscaling == "none" ? 1 : 0
  source = "./modules/create-elb-tg"
  arn = module.get-elb-tg.arn
  target = module.create-aws-ec2.ec2CreatingId
  oldTarget = module.create-aws-ec2.ec2RunningId
  depends_on = [module.create-aws-ami, module.get-elb-tg]
}

// Ce module ne s'éxecute que si l'instance n'est pas sous un autoscaling
// remove ancien EC2
module "delete-aws-ec2-tg"{
  count = module.get-elb-tg.testAws.result.autoscaling == "none" ? 1 : 0
  source = "./modules/delete-aws-ec2"
  instance = module.create-aws-ec2.ec2RunningId
  depends_on = [module.create-elb-tg]
}

// Ce module ne s'éxecute que si l'instance est sous un autoscaling
// Remove EC2 après création AMI
module "delete-aws-ec2-autoscaling"{
  count = module.get-elb-tg.testAws.result.autoscaling != "none" ? 1 : 0
  source = "./modules/delete-aws-ec2"
  instance = module.create-aws-ec2.ec2CreatingId
  depends_on = [module.create-aws-ami]
}

// Ce module ne s'éxecute que si l'instance est sous un autoscaling
module "get-aws-asg"{
  count = module.get-elb-tg.testAws.result.autoscaling != "none" ? 1 : 0
  source = "./modules/get-aws-asg"
  name = module.create-aws-ec2.ec2RunningTagName
  depends_on = [module.delete-aws-ec2-autoscaling]
}


// Module créer une conf de lancement
module "create-aws-asg"{
  count = module.get-elb-tg.testAws.result.autoscaling != "none" ? 1 : 0
  source = "./modules/create-aws-asg"
  instanceType = module.create-aws-ec2.ec2CreatingInstanceType
  amiId = module.create-aws-ami.amiId
  name = module.get-aws-asg.0.launchConfigurationName
  autoscalingName = module.get-aws-asg.0.autoscalingName
  securityGroups = module.get-aws-asg.0.launchConfigurationSG
  ebsBlockDevice = module.get-aws-asg.0.ebsBlockDevice
  autoscalingVpc = module.get-aws-asg.0.autoscalingVpc
  ec2RunningIds = module.create-aws-ec2.ec2RunningIds
  depends_on = [module.get-aws-asg]
}

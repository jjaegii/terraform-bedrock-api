module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  # VPC 모듈에서 태그를 직접 처리합니다
}

module "ec2" {
  source          = "./modules/ec2"
  vpc_id          = module.vpc.vpc_id
  subnet_id       = module.vpc.public_subnet_ids[0]
  instance_type   = var.instance_type
  key_name        = var.key_name
  create_key_pair = var.create_key_pair
  public_key_path = var.public_key_path
  startup_script  = file("${path.module}/../src/ec2_startup_script.sh")
  default_tags    = var.default_tags
  # EC2 모듈에서 태그를 직접 처리합니다
}

module "lambda" {
  source               = "./modules/lambda"
  vpc_id               = module.vpc.vpc_id
  subnet_ids           = module.vpc.private_subnet_ids
  ec2_instance_id      = module.ec2.instance_id
  lambda_function_code = "${path.module}/../src/lambda_function.py"
  default_tags         = var.default_tags
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.s3_bucket_name
  # S3 모듈에서 태그를 직접 처리합니다
}

resource "null_resource" "download_and_upload_model" {
  depends_on = [module.s3]

  provisioner "local-exec" {
    command = "python3 ${path.module}/../src/download_and_upload_model.py ${var.huggingface_model_name} ${module.s3.bucket_name}"
  }
}
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.default_tags, {
    Name = "allow_ssh"
  })
}

resource "aws_key_pair" "gpu_key" {
  count      = var.create_key_pair ? 1 : 0
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "gpu_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.create_key_pair ? aws_key_pair.gpu_key[0].key_name : var.key_name
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  user_data = var.startup_script

  tags = merge(var.default_tags, {
    Name = "ML-GPU-Instance"
  })

  root_block_device {
    volume_size = 100 # GB
  }

  lifecycle {
    create_before_destroy = true
  }
}
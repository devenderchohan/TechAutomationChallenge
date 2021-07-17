#Default security group with open ssh will be created by the terraform here , we can create custom security groups and
#custom vpcs to further strengthen the security posture.
#get the default vpcs and subnets for creating the aws_db_subnet_group resource.
data "aws_vpc" "default" {
  default = true
}
data "aws_subnet_ids" "subnetids" {
  vpc_id = data.aws_vpc.default.id
}
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = data.aws_subnet_ids.subnetids.ids
}
#create a open for ssh security group with egress to all.
#ingress also can be allowed from selected CIDR range or IPs to restrict attack surface.
#For increasing security an ALB in public zone can be attached to EC2 in private subnet , WAF and DDOS can be enabled on cloudfront anda attached to LB as source.
#for simplicity creating below SG.

resource "aws_security_group" "custom-sg" {
  name        = "custom-SG"
  description = "Security group for instance"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    // the cidr blocks can be modified to include custom cidr ranges only for security purpose.
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "Allow Access to database"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    // the cidr blocks can be modified to include custom cidr ranges only for security purpose.
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "custom-SG"
  }
}
#Create the EC2 instance.
resource "aws_instance" "instance" {
  ami           = var.ami
  instance_type = var.instance-type
  #installs the docker, docker compose in the instance on start up.
  user_data = file("../ubuntu-docker.sh")
  vpc_security_group_ids = [aws_security_group.custom-sg.id]
  key_name  = var.key_name
  tags = {
    Name       = var.instance-name
    Created-By = "Terraform-automation"
  }
}


resource "aws_db_instance" "data" {
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  publicly_accessible = true
  name                 = var.name
  username             = var.username
  password             = var.password
  identifier = "app-postgres-db"
  skip_final_snapshot  = true
  port                 = 5432
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  tags = {
    Name = var.name
  }
  vpc_security_group_ids = [aws_security_group.custom-sg.id]
}
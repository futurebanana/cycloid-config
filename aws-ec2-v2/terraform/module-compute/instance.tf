resource "aws_instance" "ec2" {
  ami           = data.aws_ami.flatcar.id
  instance_type = var.vm_instance_type

  vpc_security_group_ids  = [aws_security_group.ec2.id]

  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  disable_api_termination     = false
  user_data = "eyJpZ25pdGlvbiI6eyJ2ZXJzaW9uIjoiMy4zLjAifSwicGFzc3dkIjp7InVzZXJzIjpbeyJncm91cHMiOlsic3VkbyIsImRvY2tlciJdLCJob21lRGlyIjoiL2hvbWUva2oiLCJuYW1lIjoia2oiLCJzc2hBdXRob3JpemVkS2V5cyI6WyJzc2gtcnNhIEFBQUFCM056YUMxeWMyRUFBQUFEQVFBQkFBQUNBUUNmaE0vcEh1VEJzUlhzYndrUmVkSUlrcGFDSGM1WXdJc2kzZGV5NTVUUWtiZ0V2eTh0NWtPa2h3czZnNld0ZzByZEQ4c3FkTzJQL1VKdk1ESXRucXYxazAwZ2N6NjhjMTlsMTJ3VkRuT01BWFd2dERWOTE4M3RYeWtPUnZOQ1ZiZlJCMFBRaStWVHZxRnkyL1dtTEMxbGhwaHRIVFpUVUc3aVBRYlNVWi9TU0w2V2ZSOEFTWTh2dnRvVVcrR2lsTDM2SkY5S2F1eVdzVy94d041MmNrV3BoK0lseWRCQTVsb054YnlYQnRVTVNHbE5zWXNVN3BFbEkvNXo2SWZTQ0VCWERmSXFNYUpTcmptTzRCZkxHRE9YUjVpamNubFR5M1pqemhPaDVjUkpCQ2NHTVlaNkpUZzFPcW54VzRUMGpFc3ZrZW1xZXFibkdia25aVlk5WHVUL1RTM29VbFhYb05iWTd3UURKNlhaQk9HcUJQc2lYV3BVSHh1d1lpVlRTbURKeUNnckk0eW55NmxVWjg2ZUlKRDVicWIyWHFXQlM4a2JZR0VhSlVDVFFpNmtjeWw5SXlrV3VvY0hZU3dyMnZNNXZBWUtyV1pGeUtGbWwxVEMxd1E3Z3hzcCsyWStzUEd3NlVuV3M5cy9wdk03V2lpcWcrTUR3SS9IbE8rZy9CVHc1UTFzNmxLdkZ5bHFUczFPeTl1VVByOHgyak92eWxTd2QxU1RSc3RudjBuSXpVZnJCcUE5QUVtWHdSN1R0Sm9YaEc2RmYxSHFiMWxQYWxiSm9yYjJ6REkzS0RzNThrTXVFLy9pMms5Zko1Q0kzWEJmS0ZoTGhrL21FNXVUZGNKRnFQWGJWNFB2ZDZiM3puRzBmSHRKeUtYYXJZbUU0RnNSNmx2aEwwTWlOdz09IHh4YW54LWVnLW5vIl0sInNoZWxsIjoiL2Jpbi9iYXNoIn1dfX0i"

  root_block_device {
    volume_size           = var.vm_disk_size
    delete_on_termination = true
  }

  lifecycle {
    ignore_changes = [ami]
  }
}

# This is a trick to get the updated public IP address even after a change
data "aws_instance" "ec2" {
  instance_id = aws_instance.ec2.id
}

resource "aws_security_group" "ec2" {
  name        = "${var.cyorg}-${var.cypro}-${var.cyenv}-${var.cycom}"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "egress-all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2.id
}

resource "aws_security_group_rule" "ingress-http" {
    type              = "ingress"
    description       = "Allow 80/TCP from internet"
    security_group_id = aws_security_group.ec2.id
    cidr_blocks       = ["0.0.0.0/0"]
    protocol          = "tcp"
    from_port         = 80
    to_port           = 80
}

resource "aws_security_group_rule" "ingress-https" {
    type              = "ingress"
    description       = "Allow 80/TCP from internet"
    security_group_id = aws_security_group.ec2.id
    cidr_blocks       = ["0.0.0.0/0"]
    protocol          = "tcp"
    from_port         = 443
    to_port           = 443
}
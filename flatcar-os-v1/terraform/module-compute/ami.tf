data "aws_ami" "flatcar" {

  # create filter using name and var.flatcar_version
  filter {
    name   = "name"
    values = ["Flatcar-stable-${var.flatcar_version}-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  most_recent = true
  
  # image_id = "ami-0cfb6dafd550274db"
  owners = ["679593333241"] # Flatcar Container Linux by Kinvolk
}

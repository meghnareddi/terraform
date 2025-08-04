resource "aws_instance" "mr_ec2" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name        = "${var.ec2_name}-${count.index + 1}"
    Environment = var.environment
  }
}
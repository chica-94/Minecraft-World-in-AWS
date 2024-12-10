data "aws_availability_zones" "available" {
    state = "available"
}

data "aws_iam_policy" "cloud_watch_agent" {
  name = "CloudWatchAgentServerPolicy"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_ami" "amazon_linux_2" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.*"]
  }
}
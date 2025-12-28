
variable "subnetpub_cidr" {
    description = "CIDR block for the Subnet"
    type = string
  
}

variable "subnetpvt_cidr" {
    description = "CIDR block for the Subnet"
    type = string
}
variable "ec2_ami" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "ec2_instance_type" {
  description = "Instance type for EC2 instance"
  type        = string
  
}
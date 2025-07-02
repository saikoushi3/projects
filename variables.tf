# --- EC2 Instances ---
# Note: Using Amazon Linux 2 is recommended for kubeadm compatibility.
variable "ami_id" {
  description = "AMI for EC2 instances"
  default     = "ami-000ec6c25978d5999" # Amazon Linux 2 AMI ID for us-east-1
}

variable "ami_idd" {
  description = "AMI for EC2 instances"
  default     = "ami-0a7d80731ae1b2435" # ubuntu AMI ID for us-east-1
}

variable "key_name" {
  description = "Your EC2 key pair name"
  default     = "key-pair" # CHANGE THIS
}
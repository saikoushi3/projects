# --- EC2 Instances ---
# Note: Using Amazon Linux 2 is recommended for kubeadm compatibility.
variable "ami_id" {
  description = "AMI for EC2 instances"
  default     = "ami-05ffe3c48a9991133" # Amazon Linux 2 AMI ID for us-east-1
}

variable "key_name" {
  description = "Your EC2 key pair name"
  default     = "key-pair" # CHANGE THIS
}
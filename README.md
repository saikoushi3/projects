# 🚀 k8s-cluster-ansible

An end-to-end DevOps project to provision, configure, and deploy a Node.js application to a Kubernetes cluster using **Terraform**, **Ansible**, **Jenkins**, and **Docker**.

---

## 📁 Project Structure

├── jenkins-setup/ # Ansible role to install and configure Jenkins
├── k8s_master/ # Ansible role to configure Kubernetes master
├── k8s_workers/ # Ansible role to configure Kubernetes worker nodes
├── terraform/ # Terraform templates to provision EC2 instances
├── inventory.ini # Ansible inventory file (IP addresses of Jenkins/master/worker nodes)
├── setup.yml # Main Ansible playbook
├── deployment.yml # Kubernetes Deployment manifest for Node.js app
├── service.yml # Kubernetes Service manifest
├── Dockerfile # Dockerfile to containerize the Node.js app
├── Jenkinsfile # Jenkins pipeline definition
├── server.js # Node.js application entry point
└── package.json # Node.js project metadata



---

## 🛠️ Prerequisites

Ensure the following tools are installed on your system:

- Terraform
- Ansible
- AWS CLI (with configured credentials)
- Docker
- kubectl
- Jenkins (can be provisioned using Ansible)

---

## 🔧 Setup Instructions

### 1. 🚀 Infrastructure Provisioning (Terraform)

Navigate to the `terraform/` directory and run:

```bash
cd terraform
terraform init
terraform apply


This will create EC2 instances for:

Jenkins Server

Kubernetes Master Node

Kubernetes Worker Nodes

\
2. 🧩 Configuration (Ansible)
Use inventory.ini to define your target hosts (Jenkins/master/worker IPs).

Run the full playbook:

bash
Copy
Edit


ansible-playbook -i inventory.ini setup.yml


This playbook will:

Install Docker & Jenkins on Jenkins server

Setup Kubernetes on master and worker nodes

Install kubectl and required tools

3. ⚙️ Jenkins Pipeline (CI/CD)
Your Jenkins server will:

Checkout code from GitHub

Build Docker image of the Node.js app

Push image to Docker Hub

Deploy the app to your Kubernetes cluster

Make sure Jenkins is:

Running on the Jenkins EC2 instance

Properly configured with required plugins and credentials

Using the Jenkinsfile for pipeline execution



4. 📦 Kubernetes Deployment
The deployment.yml and service.yml will:

Deploy the Dockerized Node.js app

Expose it via a LoadBalancer or NodePort (as configured)

💡 Tips
Make sure your EC2 instances have correct security group rules (ports for SSH, Jenkins UI, Kubernetes API, etc.)

Use ansible-playbook --tags <tag> for running specific roles

Ensure Jenkins has Docker and kubectl installed or available via Ansible



# Check node connectivity
ansible all -i inventory.ini -m ping

# Run only Jenkins setup
ansible-playbook -i inventory.ini setup.yml --tags jenkins

# Check Kubernetes nodes
kubectl get nodes



👨‍💻 Author
Koushi Dev

📄 License
This project is open-source under the MIT License.

🧠 New to DevOps? This repository is designed to help you learn the complete flow from provisioning to CI/CD on Kubernetes using best practices.



Let me know if you want to [add images/badges](f), customize for another cloud, or generate a quickstart video script!




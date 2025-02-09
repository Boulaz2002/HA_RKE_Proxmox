#!/bin/bash

PROJECT_ROOT="HA_K8S-root"

# Create main directories
mkdir -p $PROJECT_ROOT/{terraform,ansible,kubernetes,scripts,docs}

# Terraform structure
mkdir -p $PROJECT_ROOT/terraform/{cloud-init,modules/proxmox-vm}

# Ansible structure
mkdir -p $PROJECT_ROOT/ansible/{playbooks,roles}

# Kubernetes structure
mkdir -p $PROJECT_ROOT/kubernetes/{manifests,helm-charts}

# Documentation
touch $PROJECT_ROOT/docs/{architecture.md,setup-guide.md,troubleshooting.md,README.md}

# Scripts
touch $PROJECT_ROOT/scripts/{setup-env.sh,cleanup.sh,README.md}
chmod +x $PROJECT_ROOT/scripts/*.sh

# Terraform files
touch $PROJECT_ROOT/terraform/{main.tf,variables.tf,outputs.tf,providers.tf,terraform.tfvars,README.md}

# Ansible files
touch $PROJECT_ROOT/ansible/{inventory.ini,README.md}
touch $PROJECT_ROOT/ansible/playbooks/{install-rke2.yml,configure-haproxy.yml,join-nodes.yml}

# Kubernetes files
touch $PROJECT_ROOT/kubernetes/manifests/{rke2-config.yml,rancher-deployment.yml,prometheus-grafana.yml,istio-config.yml}
touch $PROJECT_ROOT/kubernetes/README.md

# Create main README
touch $PROJECT_ROOT/README.md

echo "Project structure created successfully."
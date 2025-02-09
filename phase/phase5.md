# Phase 5: CI/CD Pipeline with GitOps (Automated with Ansible)

## Directory Structure

```
phase-5/
 ├── ansible/
 │   ├── roles/
 │   │   ├── gitlab/
 │   │   │   ├── tasks/
 │   │   │   │   ├── main.yml
 │   │   ├── jenkins/
 │   │   │   ├── tasks/
 │   │   │   │   ├── main.yml
 │   │   ├── argocd/
 │   │   │   ├── tasks/
 │   │   │   │   ├── main.yml
 │   │   ├── fluxcd/
 │   │   │   ├── tasks/
 │   │   │   │   ├── main.yml
 │   │   ├── helm_kustomize/
 │   │   │   ├── tasks/
 │   │   │   │   ├── main.yml
 │   ├── playbook.yml
```

## 1. Ansible Playbook

**`ansible/playbook.yml`**
```yaml
- name: Deploy CI/CD Pipeline with GitOps
  hosts: localhost
  roles:
    - gitlab
    - jenkins
    - argocd
    - fluxcd
    - helm_kustomize
```

## 2. Install GitLab

**`ansible/roles/gitlab/tasks/main.yml`**
```yaml
- name: Add GitLab Helm repo
  shell: helm repo add gitlab https://charts.gitlab.io && helm repo update

- name: Install GitLab
  shell: helm install gitlab gitlab/gitlab --namespace gitlab --create-namespace
```

## 3. Install Jenkins

**`ansible/roles/jenkins/tasks/main.yml`**
```yaml
- name: Add Jenkins Helm repo
  shell: helm repo add jenkins https://charts.jenkins.io && helm repo update

- name: Install Jenkins
  shell: helm install jenkins jenkins/jenkins --namespace jenkins --create-namespace
```

## 4. Install ArgoCD

**`ansible/roles/argocd/tasks/main.yml`**
```yaml
- name: Create ArgoCD namespace
  shell: kubectl create namespace argocd

- name: Install ArgoCD
  shell: kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

- name: Expose ArgoCD API
  shell: kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

## 5. Install FluxCD

**`ansible/roles/fluxcd/tasks/main.yml`**
```yaml
- name: Install Flux CLI
  shell: curl -s https://fluxcd.io/install.sh | sudo bash

- name: Bootstrap FluxCD on Kubernetes
  shell: flux bootstrap github --owner=my-github-username --repository=my-gitops-repo --branch=main --path=clusters/my-cluster
```

## 6. Deploy Helm & Kustomize Applications

**`ansible/roles/helm_kustomize/tasks/main.yml`**
```yaml
- name: Deploy Application via Helm
  shell: helm upgrade --install my-app ./helm-chart/ -n my-namespace

- name: Deploy Application via Kustomize
  shell: kubectl apply -k kustomize/
```

## 7. Running the Playbook

Run the playbook to deploy all components:
```sh
ansible-playbook ansible/playbook.yml
```

This setup automates the deployment of GitLab, Jenkins, ArgoCD, FluxCD, and Helm/Kustomize applications. 🚀

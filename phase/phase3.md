# Phase 3: Automating RKE2 Cluster Deployment with Ansible

## Overview
In this phase, we automate the deployment of the **RKE2 High Availability cluster** using **Ansible**. The playbooks will handle:

- Installing RKE2 on master and worker nodes
- Configuring nodes for Kubernetes
- Setting up HAProxy as a load balancer
- Deploying Rancher for Kubernetes management

---

## Project Structure
```
ansible/
├── inventory/
│   ├── hosts.yml
│
├── roles/
│   ├── rke2-master/
│   │   ├── tasks/
│   │   │   ├── install.yml
│   │   │   ├── configure.yml
│   │   │   ├── start.yml
│   │
│   ├── rke2-worker/
│   │   ├── tasks/
│   │   │   ├── install.yml
│   │   │   ├── join.yml
│   │
│   ├── haproxy/
│   │   ├── tasks/
│   │   │   ├── install.yml
│   │   │   ├── configure.yml
│   │
│   ├── rancher/
│   │   ├── tasks/
│   │   │   ├── install.yml
│
├── playbooks/
│   ├── deploy_rke2.yml
│   ├── deploy_haproxy.yml
│   ├── deploy_rancher.yml
```

---

## Inventory File (`inventory/hosts.yml`)
```yaml
all:
  hosts:
    master-1:
      ansible_host: 192.168.1.101
    master-2:
      ansible_host: 192.168.1.102
    master-3:
      ansible_host: 192.168.1.103
    worker-1:
      ansible_host: 192.168.1.104
    worker-2:
      ansible_host: 192.168.1.105
    worker-3:
      ansible_host: 192.168.1.106
    haproxy:
      ansible_host: 192.168.1.100
```

---

## Playbooks

### Deploy RKE2 (`playbooks/deploy_rke2.yml`)
```yaml
- name: Deploy RKE2 Master Nodes
  hosts: master
  roles:
    - rke2-master

- name: Deploy RKE2 Worker Nodes
  hosts: worker
  roles:
    - rke2-worker
```

### Deploy HAProxy (`playbooks/deploy_haproxy.yml`)
```yaml
- name: Deploy HAProxy Load Balancer
  hosts: haproxy
  roles:
    - haproxy
```

### Deploy Rancher (`playbooks/deploy_rancher.yml`)
```yaml
- name: Deploy Rancher
  hosts: master-1
  roles:
    - rancher
```

---

## Tasks

### RKE2 Master Install (`roles/rke2-master/tasks/install.yml`)
```yaml
- name: Download RKE2
  shell: curl -sfL https://get.rke2.io | sh -

- name: Enable RKE2 Server
  systemd:
    name: rke2-server
    enabled: yes
    state: started
```

### RKE2 Worker Join (`roles/rke2-worker/tasks/join.yml`)
```yaml
- name: Join Worker to Cluster
  shell: rke2 agent --server https://192.168.1.100:9345 --token "{{ hostvars['master-1']['rke2_token'] }}"
```

### HAProxy Configuration (`roles/haproxy/tasks/configure.yml`)
```yaml
- name: Configure HAProxy
  template:
    src: haproxy.cfg.j2
    dest: /etc/haproxy/haproxy.cfg

- name: Restart HAProxy
  systemd:
    name: haproxy
    state: restarted
```

### Rancher Installation (`roles/rancher/tasks/install.yml`)
```yaml
- name: Install Helm
  shell: curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

- name: Add Rancher Helm Repo
  shell: helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

- name: Install Rancher with Helm
  shell: >
    helm install rancher rancher-latest/rancher \
    --namespace cattle-system \
    --set hostname=rancher.example.com
```

---

## Deployment Steps
1. **Run HAProxy Playbook**
   ```sh
   ansible-playbook -i inventory/hosts.yml playbooks/deploy_haproxy.yml
   ```
2. **Run RKE2 Playbook**
   ```sh
   ansible-playbook -i inventory/hosts.yml playbooks/deploy_rke2.yml
   ```
3. **Run Rancher Playbook**
   ```sh
   ansible-playbook -i inventory/hosts.yml playbooks/deploy_rancher.yml
   ```

---

## Conclusion
This phase automated the entire RKE2 setup, including HAProxy as the load balancer and Rancher for Kubernetes management. Now, the cluster is fully functional and ready for application deployment.

Next step: **Phase 4 - Integrating additional tools (Istio, Prometheus, Kafka, etc.).** 🚀

# **Phase 2: Automating RKE2 Deployment with Ansible**

Now that the Proxmox VMs are created with Terraform and Cloud-Init, we will use **Ansible** to:

✅ Install RKE2 on master and worker nodes.  
✅ Configure HAProxy for load balancing.  
✅ Join worker nodes to the cluster.

---

## **1. Setup Ansible Directory Structure**
Create a structured directory for Ansible:

```bash
mkdir -p ansible/{roles,rke2,inventory,playbooks}
cd ansible
```

Your folder structure should look like this:

```
ansible/
├── inventory/
│   ├── hosts.yaml
├── playbooks/
│   ├── install-rke2.yaml
│   ├── configure-haproxy.yaml
│   ├── join-workers.yaml
├── roles/
│   ├── rke2-master/
│   ├── rke2-worker/
│   ├── haproxy/
```

---

## **2. Define Ansible Inventory**
Create `ansible/inventory/hosts.yaml`:

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

  children:
    masters:
      hosts:
        master-1:
        master-2:
        master-3:
    workers:
      hosts:
        worker-1:
        worker-2:
        worker-3
    loadbalancer:
      hosts:
        haproxy:
```

---

## **3. Install RKE2 on Master Nodes**
Create `ansible/playbooks/install-rke2.yaml`:

```yaml
- name: Install RKE2 on master nodes
  hosts: masters
  become: yes
  tasks:
    - name: Download RKE2 install script
      shell: curl -sfL https://get.rke2.io | sh -

    - name: Enable and start RKE2 service
      systemd:
        name: rke2-server
        enabled: yes
        state: started

    - name: Copy kubeconfig to user home
      copy:
        src: /etc/rancher/rke2/rke2.yaml
        dest: /home/ubuntu/.kube/config
        remote_src: yes
        owner: ubuntu
        group: ubuntu
        mode: '0644'
```

---

## **4. Configure HAProxy as a Load Balancer**
Create `ansible/playbooks/configure-haproxy.yaml`:

```yaml
- name: Install and configure HAProxy
  hosts: loadbalancer
  become: yes
  tasks:
    - name: Install HAProxy
      apt:
        name: haproxy
        state: present
        update_cache: yes

    - name: Configure HAProxy for RKE2 API
      copy:
        dest: /etc/haproxy/haproxy.cfg
        content: |
          defaults
            log global
            mode tcp
            option tcplog
            timeout connect 5000ms
            timeout client 50000ms
            timeout server 50000ms

          frontend rke2-api
            bind *:6443
            default_backend rke2-masters

          backend rke2-masters
            balance roundrobin
            server master-1 192.168.1.101:6443 check
            server master-2 192.168.1.102:6443 check
            server master-3 192.168.1.103:6443 check

    - name: Restart HAProxy
      systemd:
        name: haproxy
        state: restarted
```

---

## **5. Join Worker Nodes to the Cluster**
Create `ansible/playbooks/join-workers.yaml`:

```yaml
- name: Join worker nodes to the cluster
  hosts: workers
  become: yes
  tasks:
    - name: Download RKE2 install script
      shell: curl -sfL https://get.rke2.io | sh -

    - name: Enable and start RKE2 agent
      systemd:
        name: rke2-agent
        enabled: yes
        state: started

    - name: Copy kubeconfig to user home
      copy:
        src: /etc/rancher/rke2/rke2.yaml
        dest: /home/ubuntu/.kube/config
        remote_src: yes
        owner: ubuntu
        group: ubuntu
        mode: '0644'
```

---

## **6. Run Ansible Playbooks**
Run the Ansible playbooks in order:

```bash
cd ansible
ansible-playbook -i inventory/hosts.yaml playbooks/install-rke2.yaml
ansible-playbook -i inventory/hosts.yaml playbooks/configure-haproxy.yaml
ansible-playbook -i inventory/hosts.yaml playbooks/join-workers.yaml
```

---

## **Next Step: Deploy Rancher**
Now that RKE2 is up and running, we'll:
- Deploy **Rancher** on the cluster.
- Use Helm to install Rancher.
- Secure it with Let's Encrypt.

Are you ready for **Phase 3: Deploy Rancher**? 🚀


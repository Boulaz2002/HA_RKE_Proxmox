# RKE2 High Availability Cluster on Proxmox

## Architecture
Deploy an RKE2 High Availability cluster on Proxmox with the following setup:  
- **3 Master Nodes**  
- **3 Worker Nodes**  
- **1 Load Balancer** (HAProxy)  
- **Rancher** for Kubernetes cluster management  

## Tools and Components

### 1. Service Mesh & Observability
- **Istio** - Service mesh for traffic control, security, and observability.  
- **Prometheus** - Metrics collection.  
- **Grafana** - Metrics visualization.  
- **Jaeger / OpenTelemetry** - Distributed tracing.  
- **Loki** - Log aggregation.  

### 2. CI/CD & GitOps
- **GitLab** - Source code management and CI/CD.  
- **Jenkins** - Alternative CI/CD tool.  
- **ArgoCD** - GitOps-based continuous delivery.  
- **FluxCD** - Alternative GitOps tool.  

### 3. Message Broker & Event-Driven Architecture
- **Kafka** - Event-driven message streaming.  
- **RabbitMQ** - Alternative message broker.  

### 4. Infrastructure Automation & Configuration Management
- **Terraform** - Infrastructure as Code (IaC).  
- **Ansible** - Configuration management.  
- **Helm** - Kubernetes package management.  
- **Kustomize** - Kubernetes resource customization.  

### 5. Storage & Backup
- **Longhorn** - Cloud-native block storage.  
- **Velero** - Kubernetes backup and restore.  

### 6. Security & Policy Management
- **Keycloak** - Authentication and authorization.  
- **OPA Gatekeeper** - Kubernetes policy enforcement.  
- **Falco** - Runtime security.  

### 7. Networking Enhancements
- **Cilium** - eBPF-based networking and security.  
- **MetalLB** - Bare-metal load balancing (if needed).  

## Deployment Steps
1. **Set Up Proxmox** and create VMs for the cluster.  
2. **Deploy HAProxy** as a load balancer.  
3. **Install and configure RKE2** on master and worker nodes.

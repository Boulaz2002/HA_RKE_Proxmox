# Phase 4: Deploying Istio Service Mesh & Observability Stack (Automated with Ansible)

## Directory Structure

```
phase-4/
 ├── ansible/
 │   ├── playbook.yml
 │   ├── roles/
 │   │   ├── istio/
 │   │   │   ├── tasks/
 │   │   │   │   ├── main.yml
 │   │   │   │   ├── install.yml
 │   │   │   │   ├── gateway.yml
 │   │   │   ├── templates/
 │   │   │   │   ├── istio-gateway.yaml.j2
 │   │   ├── sample-app/
 │   │   │   ├── tasks/
 │   │   │   │   ├── main.yml
 │   │   │   │   ├── deploy.yml
 │   │   │   ├── templates/
 │   │   │   │   ├── my-app-deployment.yaml.j2
 │   │   │   │   ├── my-app-service.yaml.j2
 │   │   ├── observability/
 │   │   │   ├── tasks/
 │   │   │   │   ├── main.yml
 │   │   │   │   ├── loki.yml
 │   │   │   │   ├── jaeger.yml
 ├── manifests/
 │   ├── istio-gateway.yaml
 │   ├── istio-virtualservice.yaml
```

## 1. Automate Istio Installation with Ansible

**`ansible/roles/istio/tasks/install.yml`**
```yaml
- name: Download Istio
  shell: curl -L https://istio.io/downloadIstio | sh -
- name: Add Istio to PATH
  shell: export PATH="$PWD/istio-*/bin:$PATH"
- name: Install Istio with default profile
  shell: istioctl install --set profile=demo -y
```

## 2. Automate Namespace Labeling

**`ansible/roles/istio/tasks/main.yml`**
```yaml
- name: Label Default Namespace for Istio Injection
  shell: kubectl label namespace default istio-injection=enabled
```

## 3. Deploy Sample Application with Ansible

**`ansible/roles/sample-app/tasks/deploy.yml`**
```yaml
- name: Deploy MyApp
  kubernetes:
    definition: "{{ lookup('template', 'my-app-deployment.yaml.j2') }}"
- name: Create MyApp Service
  kubernetes:
    definition: "{{ lookup('template', 'my-app-service.yaml.j2') }}"
```

## 4. Automate Istio Gateway & VirtualService Deployment

**`ansible/roles/istio/tasks/gateway.yml`**
```yaml
- name: Deploy Istio Gateway
  kubernetes:
    definition: "{{ lookup('template', 'istio-gateway.yaml.j2') }}"
- name: Deploy Istio VirtualService
  kubernetes:
    definition: "{{ lookup('file', 'manifests/istio-virtualservice.yaml') }}"
```

## 5. Automate Loki Logging Deployment

**`ansible/roles/observability/tasks/loki.yml`**
```yaml
- name: Deploy Loki for Log Aggregation
  shell: kubectl apply -f https://raw.githubusercontent.com/grafana/loki/main/production/helm/loki-stack.yaml
```

## 6. Automate Jaeger Tracing Deployment

**`ansible/roles/observability/tasks/jaeger.yml`**
```yaml
- name: Create Observability Namespace
  shell: kubectl create namespace observability
- name: Install Jaeger Operator
  shell: kubectl apply -f https://github.com/jaegertracing/jaeger-operator/releases/latest/download/jaeger-operator.yaml -n observability
- name: Deploy Jaeger Instance
  kubernetes:
    definition:
      apiVersion: jaegertracing.io/v1
      kind: Jaeger
      metadata:
        name: jaeger
        namespace: observability
      spec:
        strategy: allInOne
        collector:
          options:
            log-level: debug
        ingress:
          enabled: true
```

## 7. Running the Playbook

Create a master playbook:

**`ansible/playbook.yml`**
```yaml
- hosts: localhost
  roles:
    - istio
    - sample-app
    - observability
```

Run the playbook:
```sh
ansible-playbook ansible/playbook.yml
```

## 8. Testing the Application

Find the external IP of the Istio Ingress Gateway:
```sh
kubectl get svc istio-ingressgateway -n istio-system
```

Curl the application using the external IP:
```sh
curl -H "Host: myapp.example.com" http://<EXTERNAL-IP>
```

If everything is set up correctly, you should receive a response from the Nginx server running in the Istio service mesh. 🚀

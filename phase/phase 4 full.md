# Phase 4: Deploying Istio Service Mesh & Observability Stack (Automated with Ansible)

## 1. Automate Istio Installation with Ansible

Create an Ansible playbook to install Istio:

**`install_istio.yml`**
```yaml
- name: Install Istio Service Mesh
  hosts: localhost
  tasks:
    - name: Download Istio
      shell: curl -L https://istio.io/downloadIstio | sh -
    - name: Add Istio to PATH
      shell: export PATH="$PWD/istio-*/bin:$PATH"
    - name: Install Istio with default profile
      shell: istioctl install --set profile=demo -y
```

Run the playbook:
```sh
ansible-playbook install_istio.yml
```

## 2. Automate Namespace Labeling

**`label_namespace.yml`**
```yaml
- name: Label Default Namespace for Istio Injection
  hosts: localhost
  tasks:
    - name: Label default namespace
      shell: kubectl label namespace default istio-injection=enabled
```

Run the playbook:
```sh
ansible-playbook label_namespace.yml
```

## 3. Deploy Sample Application with Ansible

Create an Ansible playbook for deploying the sample app:

**`deploy_sample_app.yml`**
```yaml
- name: Deploy Sample Application
  hosts: localhost
  tasks:
    - name: Deploy MyApp
      kubernetes:
        definition:
          apiVersion: apps/v1
          kind: Deployment
          metadata:
            name: my-app
          spec:
            replicas: 2
            selector:
              matchLabels:
                app: my-app
            template:
              metadata:
                labels:
                  app: my-app
              spec:
                containers:
                - name: my-app
                  image: nginx
                  ports:
                  - containerPort: 80

    - name: Create MyApp Service
      kubernetes:
        definition:
          apiVersion: v1
          kind: Service
          metadata:
            name: my-app
          spec:
            selector:
              app: my-app
            ports:
            - protocol: TCP
              port: 80
              targetPort: 80
```

Run the playbook:
```sh
ansible-playbook deploy_sample_app.yml
```

## 4. Automate Istio Gateway & VirtualService Deployment

**`deploy_istio_gateway.yml`**
```yaml
- name: Deploy Istio Gateway and VirtualService
  hosts: localhost
  tasks:
    - name: Deploy Istio Gateway
      kubernetes:
        definition:
          apiVersion: networking.istio.io/v1alpha3
          kind: Gateway
          metadata:
            name: my-app-gateway
            namespace: istio-system
          spec:
            selector:
              istio: ingressgateway
            servers:
            - port:
                number: 80
                name: http
                protocol: HTTP
              hosts:
              - "myapp.example.com"

    - name: Deploy Istio VirtualService
      kubernetes:
        definition:
          apiVersion: networking.istio.io/v1alpha3
          kind: VirtualService
          metadata:
            name: my-app
            namespace: default
          spec:
            hosts:
            - "myapp.example.com"
            gateways:
            - istio-system/my-app-gateway
            http:
            - route:
              - destination:
                  host: my-app.default.svc.cluster.local
                  port:
                    number: 80
```

Run the playbook:
```sh
ansible-playbook deploy_istio_gateway.yml
```

## 5. Automate Loki Logging Deployment

**`install_loki.yml`**
```yaml
- name: Deploy Loki for Log Aggregation
  hosts: localhost
  tasks:
    - name: Install Loki Stack
      shell: kubectl apply -f https://raw.githubusercontent.com/grafana/loki/main/production/helm/loki-stack.yaml
```

Run the playbook:
```sh
ansible-playbook install_loki.yml
```

## 6. Automate Jaeger Tracing Deployment

**`install_jaeger.yml`**
```yaml
- name: Deploy Jaeger for Distributed Tracing
  hosts: localhost
  tasks:
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

Run the playbook:
```sh
ansible-playbook install_jaeger.yml
```

## 7. Testing the Application

Find the external IP of the Istio Ingress Gateway:

```sh
kubectl get svc istio-ingressgateway -n istio-system
```

Curl the application using the external IP:

```sh
curl -H "Host: myapp.example.com" http://<EXTERNAL-IP>
```

If everything is set up correctly, you should receive a response from the Nginx server running in the Istio service mesh. 🚀

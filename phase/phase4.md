# Phase 4: Deploying Istio Service Mesh & Testing Application with Ansible

## 1. Install Istio

Create an Ansible playbook to install Istio:

**`install_istio.yaml`**

```yaml
- name: Install Istio
  hosts: localhost
  tasks:
    - name: Download Istio
      shell: curl -L https://istio.io/downloadIstio | sh -
    - name: Move to Istio directory
      shell: cd istio-*
    - name: Add Istioctl to PATH
      shell: export PATH="$PWD/bin:$PATH"
    - name: Install Istio with default profile
      shell: istioctl install --set profile=demo -y
```

Run the playbook:

```sh
ansible-playbook install_istio.yaml
```

## 2. Label Namespace for Istio Injection

```sh
kubectl label namespace default istio-injection=enabled
```

## 3. Deploy a Sample Application

Create an Ansible playbook for deploying the sample app:

**`deploy_app.yaml`**

```yaml
- name: Deploy Sample Application
  hosts: localhost
  tasks:
    - name: Create Deployment
      kubernetes.core.k8s:
        definition:
          apiVersion: apps/v1
          kind: Deployment
          metadata:
            name: my-app
            labels:
              app: my-app
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
    - name: Create Service
      kubernetes.core.k8s:
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
ansible-playbook deploy_app.yaml
```

## 4. Configure Istio Gateway & VirtualService

Create an Ansible playbook for configuring Istio:

**`configure_istio.yaml`**

```yaml
- name: Configure Istio Gateway and VirtualService
  hosts: localhost
  tasks:
    - name: Create Istio Gateway
      kubernetes.core.k8s:
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
    - name: Create VirtualService
      kubernetes.core.k8s:
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
ansible-playbook configure_istio.yaml
```

## 5. Testing the Application

Find the external IP of the Istio Ingress Gateway:

```sh
kubectl get svc istio-ingressgateway -n istio-system
```

Curl the application using the external IP:

```sh
curl -H "Host: myapp.example.com" http://<EXTERNAL-IP>
```

If everything is set up correctly, you should receive a response from the Nginx server running in the Istio service mesh. 🚀

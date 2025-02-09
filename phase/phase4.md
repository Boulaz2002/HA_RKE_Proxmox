# Phase 4: Deploying Istio Service Mesh & Testing Application

## 1. Install Istio

```sh
# Download Istio
curl -L https://istio.io/downloadIstio | sh -
cd istio-*/
export PATH="$PWD/bin:$PATH"

# Install Istio with default profile
istioctl install --set profile=demo -y
```

## 2. Label Namespace for Istio Injection

```sh
kubectl label namespace default istio-injection=enabled
```

## 3. Deploy a Sample Application

Create a sample deployment and service:

```yaml
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
```

```yaml
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

Apply the deployment and service:

```sh
kubectl apply -f my-app-deployment.yaml
kubectl apply -f my-app-service.yaml
```

## 4. Configure Istio Gateway & VirtualService

### Istio Gateway

```yaml
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
```

### VirtualService

```yaml
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

Apply the configurations:

```sh
kubectl apply -f istio-gateway.yaml
kubectl apply -f istio-virtualservice.yaml
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

## 6. Set Up Monitoring (Prometheus & Grafana)

### Install Prometheus and Grafana using Istio Addons

Istio provides built-in monitoring tools that include Prometheus and Grafana.

```sh
# Navigate to Istio directory
cd istio-*

# Deploy Prometheus, Grafana, and other addons
kubectl apply -f samples/addons
```

### Verify Prometheus and Grafana are Running

```sh
kubectl get pods -n istio-system
```

Ensure that `prometheus`, `grafana`, and other monitoring tools are running.

### Expose Prometheus and Grafana

Port-forward to access Prometheus:

```sh
kubectl port-forward -n istio-system svc/prometheus 9090:9090
```

Access Prometheus at: [http://localhost:9090](http://localhost:9090)

Port-forward to access Grafana:

```sh
kubectl port-forward -n istio-system svc/grafana 3000:3000
```

Access Grafana at: [http://localhost:3000](http://localhost:3000)  
(Default username/password: `admin/admin`)

### Import Istio Dashboards in Grafana

1. Open Grafana in your browser.
2. Navigate to **Dashboards > Manage**.
3. Click **Import** and use Istio’s prebuilt dashboard IDs:
   - **Istio Mesh Dashboard**: `7639`
   - **Istio Performance Dashboard**: `11829`
   - **Istio Workload Dashboard**: `7636`

After importing, you can visualize Istio metrics in Grafana. 🚀

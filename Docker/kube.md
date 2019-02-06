GCP Cloud JAM worklog
Step 1. complete the qwikilab (1 quest)

docker tag node-app:0.2 gcr.io/qwiklabs-gcp-dcee86dda6c0c6bc/node-app:0.2

docker rmi node-app:0.2 gcr.io/qwiklabs-gcp-dcee86dda6c0c6bc/node-app node-app:0.1
docker rmi node:6
docker rmi $(docker images -aq) # remove remaining images
docker images

gcloud docker -- pull gcr.io/qwiklabs-gcp-dcee86dda6c0c6bc/node-app:0.2
docker run -p 4000:80 -d gcr.io/qwiklabs-gcp-dcee86dda6c0c6bc/node-app:0.2
curl http://localhost:4000

gcloud docker -- push gcr.io/qwiklabs-gcp-dcee86dda6c0c6bc/node-app:0.2


docker run -d -p 8080:8080 gcr.io/qwiklabs-gcp-d4475a247726c42c/hello-node:v1

gcloud docker -- push gcr.io/qwiklabs-gcp-d4475a247726c42c/hello-node:v1

docker build -t gcr.io/qwiklabs-gcp-d4475a247726c42c/hello-node:v1 .


gcloud config set project qwiklabs-gcp-d4475a247726c42c

# create gke cluster

gcloud container clusters create hello-world \
                --num-nodes 2 \
                --machine-type n1-standard-1 \
                --zone us-central1-a

# create pod

kubectl run hello-node \
    --image=gcr.io/qwiklabs-gcp-d4475a247726c42c/hello-node:v1 \
    --port=8080

#check k8s info 

kubectl get pods

kubectl get deployment

kubectl cluster-info

kubectl config view

kubectl get events


# expose extenal traffic

kubectl expose deployment hello-node --type="LoadBalancer"

kubectl get services
google2202758_student@cloudshell:~ (qwiklabs-gcp-d4475a247726c42c)$ kubectl get services
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)          AGE
hello-node   LoadBalancer   10.31.243.113   35.193.88.25   8080:31216/TCP   1m
kubernetes   ClusterIP      10.31.240.1     <none>         443/TCP          10m

http://35.193.88.25:8080


# scale up services
kubectl scale deployment hello-node --replicas=4

kubectl get pods

kubectl get deployment


#Roll out an upgrade to your service

update server.js

# image build and push to gcr.io
docker build -t gcr.io/qwiklabs-gcp-d4475a247726c42c/hello-node:v2 .
gcloud docker -- push gcr.io/qwiklabs-gcp-d4475a247726c42c/hello-node:v2


# edit deployment 

kubectl edit deployment hello-node

kubectl get deployments
kubectl get pods

# Kubernetes graphical dashboard (optional)

 - To get started, run the following command to grant cluster level permissions:

kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$(gcloud config get-value account)

 - Now that you have the appropriate permissions set, run the following command to create a new dashboard service:

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml


- Now run the following command to edit the yaml representation of the dashboard service:

kubectl -n kube-system edit service kubernetes-dashboard




# create sample cluster for k8s
gcloud config set compute/zone us-central1-b

gcloud config list 

gcloud container clusters create io

# get sample source
git clone https://github.com/googlecodelabs/orchestrate-with-kubernetes.git


# create single nginx container

kubectl run nginx --image=nginx:1.10.0

kubectl get pods

kubectl get deployment

# expose the service for nginx
kubectl expose deployment nginx --port 80 --type LoadBalancer

kubectl get service

# create pod (2 container each other communicate , shared attached vol)

cat pods/monolith.yaml

apiVersion: v1
kind: Pod
metadata:
  name: monolith
  labels:
    app: monolith
spec:
  containers:
    - name: monolith
      image: kelseyhightower/monolith:1.0.0
      args:
        - "-http=0.0.0.0:80"
        - "-health=0.0.0.0:81"
        - "-secret=secret"
      ports:
        - name: http
          containerPort: 80
        - name: health
          containerPort: 81
      resources:
        limits:
          cpu: 0.2

kubectl create -f pods/monolith.yaml

kubectl describe pods monolith

# map local port to inside pod 's port
kubectl port-forward monolith 10080:80

curl http://127.0.0.1:10080

$ curl http://127.0.0.1:10080/secure
authorization failed
$ curl -u user http://127.0.0.1:10080/login
Enter host password for user 'user':
{"token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InVzZXJAZXhhbXBsZS5jb20iLCJleHAiOjE1NDgxNTI4NjQsImlhdCI6MTU0Nzg5MzY2NCwiaXNzIjoiYXV0aC5zZXJ2aWNlIiwic3ViIjoidXNlciJ9.beo7qyqxEbgqoHicknjSE-PVVReJz7jZS3EvoGK5JtE"}

$ TOKEN=$(curl http://127.0.0.1:10080/login -u user|jq -r '.token')
Enter host password for user 'user':
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   222  100   222    0     0    210      0  0:00:01  0:00:01 --:--:--   210

$ curl -H "Authorization: Bearer $TOKEN" http://127.0.0.1:10080/secure
{"message":"Hello"}


# view the logs of monolith pod

kubectl logs monolith


# login  container 
kubectl exec monolith --stdin --tty -c monolith /bin/sh


# creating a service
cat pods/secure-monolith.yaml

apiVersion: v1
kind: Pod
metadata:
  name: "secure-monolith"
  labels:
    app: monolith
spec:
  containers:
    - name: nginx
      image: "nginx:1.9.14"
      lifecycle:
        preStop:
          exec:
            command: ["/usr/sbin/nginx","-s","quit"]
      volumeMounts:
        - name: "nginx-proxy-conf"
          mountPath: "/etc/nginx/conf.d"
        - name: "tls-certs"
          mountPath: "/etc/tls"
    - name: monolith
      image: "kelseyhightower/monolith:1.0.0"
      ports:
        - name: http
          containerPort: 80
        - name: health
          containerPort: 81
      resources:
        limits:
          cpu: 0.2
          memory: "10Mi"
      livenessProbe:
        httpGet:
          path: /healthz
          port: 81
          scheme: HTTP
        initialDelaySeconds: 5
        periodSeconds: 15
        timeoutSeconds: 5
      readinessProbe:
        httpGet:
          path: /readiness
          port: 81
          scheme: HTTP
        initialDelaySeconds: 5
        timeoutSeconds: 1
  volumes:
    - name: "tls-certs"
      secret:
        secretName: "tls-certs"
    - name: "nginx-proxy-conf"
      configMap:
        name: "nginx-proxy-conf"
        items:
          - key: "proxy.conf"
            path: "proxy.conf"

kubectl create secret generic tls-certs --from-file tls/
kubectl create configmap nginx-proxy-conf --from-file nginx/proxy.conf
kubectl create -f pods/secure-monolith.yaml
(created secure pod)

$ cat services/monolith.yaml
kind: Service
apiVersion: v1
metadata:
  name: "monolith"
spec:
  selector:
    app: "monolith"
    secure: "enabled"
  ports:
    - protocol: "TCP"
      port: 443
      targetPort: 443
      nodePort: 31000
  type: NodePort

kubectl create -f services/monolith.yaml

# add firewall rule
gcloud compute firewall-rules create allow-monolith-nodeport \
  --allow=tcp:31000


$ gcloud compute instances list
NAME                               ZONE           MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP     STATUS
gke-io-default-pool-59de1409-1jsb  us-central1-b  n1-standard-1               10.128.0.4   104.197.127.51  RUNNING
gke-io-default-pool-59de1409-dqsz  us-central1-b  n1-standard-1               10.128.0.3   35.238.41.55    RUNNING
gke-io-default-pool-59de1409-hrbs  us-central1-b  n1-standard-1               10.128.0.2   35.232.9.94     RUNNING


curl -k https:/104.197.127.51:31000
->pods에 selector에 명시된 label 이없어 매치 안되기 때문에 error


# add label to pod

kubectl get pods -l "app=monolith"

$ kubectl get pods -l "app=monolith,secure=enabled"
No resources found.

kubectl label pods secure-monolith 'secure=enabled'
kubectl get pods secure-monolith --show-labels

$ kubectl describe services monolith | grep Endpoints
Endpoints:                10.4.0.9:443
$ gcloud compute instances list
NAME                               ZONE           MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP     STATUS
gke-io-default-pool-59de1409-1jsb  us-central1-b  n1-standard-1               10.128.0.4   104.197.127.51  RUNNING
gke-io-default-pool-59de1409-dqsz  us-central1-b  n1-standard-1               10.128.0.3   35.238.41.55    RUNNING
gke-io-default-pool-59de1409-hrbs  us-central1-b  n1-standard-1               10.128.0.2   35.232.9.94     RUNNING
curl -k https://35.238.41.55:31000

# Creating Deployments (auto healing and deployment demo)
auth - Generates JWT tokens for authenticated users.
hello - Greet authenticated users.
frontend - Routes traffic to the auth and hello services.

$ cd orchestrate-with-kubernetes/kubernetes/
$ cat deployments/auth.yaml

apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: auth
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: auth
        track: stable
    spec:
      containers:
        - name: auth
          image: "kelseyhightower/auth:2.0.0"
          ports:
            - name: http
              containerPort: 80
            - name: health
              containerPort: 81
          resources:
            limits:
              cpu: 0.2
              memory: "10Mi"
          livenessProbe:
            httpGet:
              path: /healthz
              port: 81
              scheme: HTTP
            initialDelaySeconds: 5
            periodSeconds: 15
            timeoutSeconds: 5
          readinessProbe:
            httpGet:
              path: /readiness
              port: 81
              scheme: HTTP
            initialDelaySeconds: 5
            timeoutSeconds: 1

kubectl create -f deployments/auth.yaml
kubectl create -f services/auth.yaml

kubectl create -f deployments/hello.yaml
kubectl create -f services/hello.yaml

kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf
kubectl create -f deployments/frontend.yaml
kubectl create -f services/frontend.yaml

kubectl get services frontend
curl -k https://<EXTERNAL-IP>


## Overview
kafka image for our own project, it does not support auto discovery or clustering yet.

## docker-compose example
```
version: "2"
services:
  zookeeper:
    image: zookeeper
    ports:
      - 2181:2181
  kafka:
    image: neowu/kafka:2.0.1
    ports:
      - 9092:9092
    environment:
      - KAFKA_ARGS=--override listeners=PLAINTEXT://:9092 --override advertised.listeners=PLAINTEXT://localhost:9092
    depends_on:
      - zookeeper
```

## Kubernetes example:
```
apiVersion: apps/v1beta1
kind: StatefulSet
metadata:
  name: zookeeper
  namespace: dev
spec:
  serviceName: zookeeper
  replicas: 1
  updateStrategy:
    type: RollingUpdate
  podManagementPolicy: Parallel
  template:
    metadata:
      labels:
        app: zookeeper
    spec:
      nodeSelector:
        pool: app
      containers:
      - name: zookeeper
        image: zookeeper
        ports:
        - containerPort: 2181
        volumeMounts:
        - name: data
          mountPath: /data
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 10Gi
---
apiVersion: v1
kind: Service
metadata:
  name: zookeeper
  namespace: dev
spec:
  clusterIP: None
  ports:
  - port: 2181
  selector:
    app: zookeeper
---
apiVersion: apps/v1beta1
kind: StatefulSet
metadata:
  name: kafka
  namespace: dev
spec:
  serviceName: kafka
  replicas: 1
  updateStrategy:
    type: RollingUpdate
  podManagementPolicy: Parallel
  template:
    metadata:
      labels:
        app: kafka
    spec:
      nodeSelector:
        pool: app
      containers:
      - name: kafka
        env:
        - name: KAFKA_HEAP_OPTS
          value: "-Xms1G -Xmx1G"
        - name: KAFKA_ARGS
          value: "--override zookeeper.connect=zookeeper-0.zookeeper:2181 --override log.retention.bytes=45000000000 --override log.retention.hours=168"
        image: neowu/kafka:2.0.1
        ports:
        - containerPort: 9092
        volumeMounts:
        - name: data
          mountPath: /data
  volumeClaimTemplates:
  - metadata:
      name: data
      annotations:
        volume.beta.kubernetes.io/storage-class: ssd
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 50Gi
---
apiVersion: v1
kind: Service
metadata:
  name: kafka
  namespace: dev
spec:
  clusterIP: None
  ports:
  - port: 9092
  selector:
    app: kafka
```

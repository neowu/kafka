## Overview
kafka image for our own projects, pls check default values in server.properties, and override by needs, e.g. clustering, partition, retention and etc

## docker-compose example
```
version: "3"
services:
  zookeeper:
    image: zookeeper:3.5.8
    ports:
    - 2181
    environment:
    - JMXDISABLE=true
    - ZOO_DATA_DIR=/data
    - ZOO_DATA_LOG_DIR=/datalog
    - ZOO_ADMINSERVER_ENABLED=false
  kafka:
    image: neowu/kafka:2.6.0
    ports:
    - 9092:9092
    environment:
    - KAFKA_ARGS=--override advertised.listeners=PLAINTEXT://localhost:9092 --override num.partitions=3
    depends_on:
    - zookeeper
```

## Kubernetes example:
```
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: zookeeper
  namespace: dev
spec:
  serviceName: zookeeper
  replicas: 1
  selector:
    matchLabels:
      app: zookeeper
  updateStrategy:
    type: OnDelete
  template:
    metadata:
      labels:
        app: zookeeper
    spec:
      nodeSelector:
        agentpool: app
      containers:
        - name: zookeeper
          image: zookeeper:3.5.8
          env:
            - name: JMXDISABLE
              value: "true"
            - name: ZOO_DATA_DIR
              value: "/data"
            - name: ZOO_DATA_LOG_DIR
              value: "/datalog"
            - name: ZOO_ADMINSERVER_ENABLED
              value: "false"
            - name: ZOO_AUTOPURGE_PURGEINTERVAL
              value: "24"
          volumeMounts:
            - name: data
              mountPath: /data
            - name: datalog
              mountPath: /datalog
          resources:
            limits:
              memory: 256Mi
  volumeClaimTemplates:
    - metadata:
        name: data
      spec:
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: 10Gi
    - metadata:
        name: datalog
      spec:
        accessModes:
          - ReadWriteOnce
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
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: kafka
  namespace: dev
spec:
  serviceName: kafka
  replicas: 1
  selector:
    matchLabels:
      app: kafka
  updateStrategy:
    type: OnDelete
  template:
    metadata:
      labels:
        app: kafka
    spec:
      nodeSelector:
        agentpool: app
      containers:
        - name: kafka
          env:
            - name: KAFKA_HEAP_OPTS
              value: "-Xms1G -Xmx1G"
            - name: KAFKA_ARGS
              value: "--override zookeeper.connect=zookeeper-0.zookeeper:2181 --override log.retention.bytes=45000000000 --override log.retention.hours=168"
          image: neowu/kafka:2.6.0
          volumeMounts:
            - name: data
              mountPath: /data
  volumeClaimTemplates:
    - metadata:
        name: data
      spec:
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: 100Gi
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

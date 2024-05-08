# xmrig

Run [xmrig] on [arm64v8:alpine] - [aakhtar3/xmrig]

- Raspberry pi 5
- Apple M series

[xmrig]: https://xmrig.com
[arm64v8:alpine]: https://hub.docker.com/r/arm64v8/alpine/
[aakhtar3/xmrig]: https://hub.docker.com/r/aakhtar3/xmrig

Create XMR [wallet] and join a [pool]

[wallet]: https://www.getmonero.org/downloads/
[pool]: https://monero.hashvault.pro/

## Docker

```bash
docker run -d \
    --name xmrig \
    -e URL=pool.hashvault.pro:443 \
    -e WALLET=abc \
    -e NODE_NAME=$(hostname) \
    --cpus="2" \
    --cpu-quota=400000 \
    --cpu-period=100000 \
    aakhtar3/xmrig
```

## Docker Compose

```bash
# docker compose -d up
version: '3.9'
services:
    xmrig:
        name: xmrig
        image: aakhtar3/xmrig
        environment:
            - URL=pool.hashvault.pro:443
            - WALLET=abc
            - NODE_NAME=node-1
        restart: always
        deploy:
          resources:
            limits:
              cpus: '2.0'
            reservations:
              cpus: '4.0'
```

## Kubernetes

```yml
# kubectl apply -f mainifest.yml
apiVersion: v1
kind: Namespace
metadata:
  name: xmrig
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: xmrig
  namespace: xmrig
  labels:
    app: xmrig
spec:
  replicas: 1
  selector:
    matchLabels:
      app: xmrig
  template:
    metadata:
      labels:
        app: xmrig
    spec:
      containers:
        - name: xmrig
          image: aakhtar3/xmrig
          env:
            - name: URL
              value: 'pool.hashvault.pro:443'
            - name: WALLET
              value: abc
            - name: NODE_NAME
              valueFrom:
                fieldRef:
                  fieldPath: spec.nodeName
          resources:
            requests:
              cpu: '2'
            limits:
              cpu: '4'
```

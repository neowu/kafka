## Overview

kafka image for our own projects, pls check default values in server.properties, and override by needs, e.g. clustering,
partition, retention and etc

## Mac with Apple Silicon

jre apline doesn't have arm64 image, build arm64 by yourself

```shell
cd kafka
docker build -t kafka:3.5.0 -f Dockerfile-arm64-arm64.
```

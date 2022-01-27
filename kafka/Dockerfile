FROM        eclipse-temurin:17-jre-alpine
ARG         KAFKA_VERSION=3.1.0
ARG         SCALA_VERSION=2.13
ENV         KAFKA_ARG=""
# disable jmx
ENV         KAFKA_JMX_OPTS=" "
# disable gc log
ENV         KAFKA_GC_LOG_OPTS=" "
# bash is required by kafka start script
# gcompat is for /lib/ld-linux-x86-64.so.2 required by kafka/snappy
RUN         apk add --no-cache curl bash gcompat
RUN         curl -SL https://dlcdn.apache.org/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz | tar xzf - -C /opt \
                && ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka
ADD         conf/server.properties /opt/kafka/config/
EXPOSE      9092
VOLUME      /data
# to refer kafka_args env, it must call bash and pass env as param
ENTRYPOINT  ["/bin/bash", "-c", "/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties ${KAFKA_ARGS}"]

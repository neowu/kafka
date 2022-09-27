FROM        eclipse-temurin:17-jre-alpine
ARG         KAFKA_VERSION=3.2.3
ENV         KAFKA_ARG=""
# disable jmx
ENV         KAFKA_JMX_OPTS=" "
# disable gc log
ENV         KAFKA_GC_LOG_OPTS=" "
ENV         LOG_DIR="/var/log/kafka"
# bash is required by kafka start script
# gcompat is for /lib/ld-linux-x86-64.so.2 required by kafka/snappy
RUN         apk add --no-cache curl bash gcompat
RUN         addgroup --gid 1000 --system kafka && adduser --system --no-create-home --ingroup kafka --uid 1000 kafka
RUN         curl -SL https://downloads.apache.org/kafka/${KAFKA_VERSION}/kafka_2.13-${KAFKA_VERSION}.tgz | tar xzf - -C /opt \
                && ln -s /opt/kafka_2.13-${KAFKA_VERSION} /opt/kafka \
                && mkdir -p /data /var/log/kafka && chown -R kafka.kafka /data /var/log/kafka
ADD         conf/server.properties /opt/kafka/config/
EXPOSE      1099
EXPOSE      9092
VOLUME      /data
USER        1000
# to refer kafka_args env, it must call bash and pass env as param
ENTRYPOINT  ["/bin/bash", "-c", "/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties ${KAFKA_ARGS}"]

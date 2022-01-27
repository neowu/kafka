FROM        eclipse-temurin:17-jre-alpine
ARG         KAFKA_VERSION=3.1.0
ARG         SCALA_VERSION=2.13
ENV         KAFKA_ARG=""
# disable jmx
ENV         KAFKA_JMX_OPTS=" "
# disable gc log
ENV         KAFKA_GC_LOG_OPTS=" "
ENV         KAFKA_NODE_ID=""
ENV         KAFKA_CLUSTER_ID=""
# bash is required by kafka start script
RUN         apk add --no-cache curl bash
RUN         curl -SL https://dlcdn.apache.org/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz | tar xzf - -C /opt \
                && ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka
EXPOSE      1099
EXPOSE      9092
EXPOSE      9093
VOLUME      /data
COPY        conf/kraft/server.properties /opt/kafka/config/kraft/
COPY        ./entrypoint.sh /
RUN         chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

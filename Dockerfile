FROM        adoptopenjdk/openjdk11:alpine-jre
ARG         KAFKA_VERSION=2.4.0
ARG         SCALA_VERSION=2.13
ENV         KAFKA_ARG=""
# disable jmx
ENV         KAFKA_JMX_OPTS=" "
# bash is required by kafka start script
RUN         apk add --no-cache curl bash
RUN         curl -SL http://www.us.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz | tar xzf - -C /opt \
                && ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka
ADD         conf/server.properties /opt/kafka/config/
EXPOSE      9092
VOLUME      /data
# to referring kafka_args env, it must call bash and pass env as param
ENTRYPOINT  ["/bin/bash", "-c", "/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties ${KAFKA_ARGS}"]

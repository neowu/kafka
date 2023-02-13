#!/bin/bash -e
if [[ -z "${KAFKA_NODE_ID}" ]]; then
    echo "env KAFKA_NODE_ID must be set" 1>&2
    exit 1
fi
if [[ -z "${KAFKA_CLUSTER_ID}" ]]; then
    echo "env KAFKA_CLUSTER_ID must be set" 1>&2
    exit 1
fi
sed -i "s/NODE_ID_VAR/${KAFKA_NODE_ID}/g" /opt/kafka/config/kraft/server.properties
/opt/kafka/bin/kafka-storage.sh format --ignore-formatted -t "${KAFKA_CLUSTER_ID}" -c /opt/kafka/config/kraft/server.properties
exec /bin/bash -c "/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/kraft/server.properties ${KAFKA_ARGS}"

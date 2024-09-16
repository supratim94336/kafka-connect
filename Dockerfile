FROM artifactory.cd-tech26.de/docker/confluentinc/cp-kafka-connect:3.3.0

# Install Confluent Hub CLI
RUN mkdir -p /opt/confluent-hub-client \
    && curl -vv -kL "https://client.hub.confluent.io/confluent-hub-client-latest.tar.gz" \
    | tar -xzv -C /opt/confluent-hub-client

# setup PATH
ENV PATH="/opt/confluent-hub-client/bin:${PATH}"

# Example connector installation
RUN confluent-hub install --no-prompt --verbose debezium/debezium-connector-postgresql:latest

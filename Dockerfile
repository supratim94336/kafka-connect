FROM confluentinc/cp-kafka-connect:7.3.1

RUN confluent-hub install --no-prompt --verbose debezium/debezium-connector-postgresql:latest

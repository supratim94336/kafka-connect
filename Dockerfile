FROM confluentinc/cp-kafka-connect:latest

RUN confluent-hub install --no-prompt --verbose debezium/debezium-connector-postgresql:latest

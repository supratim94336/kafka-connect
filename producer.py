from confluent_kafka import Producer
import json
import time

# Kafka Producer configuration
conf = {
    'bootstrap.servers': 'localhost:9092',  # Change to your broker address
    'client.id': 'python-producer'
}

# Initialize Producer instance
producer = Producer(**conf)

# Delivery report callback (optional)
def delivery_report(err, msg):
    """ Called once for each message produced to indicate delivery result.
    Triggered by poll() or flush(). """
    if err is not None:
        print(f"Message delivery failed: {err}")
    else:
        print(f"Message delivered to {msg.topic()} [{msg.partition()}]")

# Function to send message
def produce_message(topic, key, value):
    # Convert the value to a JSON string if needed
    value_json = json.dumps(value)
    
    # Produce the message
    producer.produce(topic, key=str(key), value=value_json, callback=delivery_report)

    # Wait for message to be delivered
    producer.poll(1)

# Sample data to produce to Kafka
messages = [
    {"key": "key1", "value": {"ingredient_id": 1, "ingredient_name": "Bananas", "ingredient_price": 1}},
    {"key": "key2", "value": {"ingredient_id": 2, "ingredient_name": "Apple", "ingredient_price": 2}},
    {"key": "key3", "value": {"ingredient_id": 3, "ingredient_name": "Mango", "ingredient_price": 3}},
]

topic = 'postgres.public.ingredients'  # Kafka topic name

# Produce each message to Kafka
for msg in messages:
    produce_message(topic, msg['key'], msg['value'])

# Wait for all messages to be delivered
producer.flush()

print("All messages have been delivered.")

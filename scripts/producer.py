import json
import argparse
from kafka import KafkaProducer
import config

# Set up argument parser
parser = argparse.ArgumentParser(description="Send messages to a Kafka topic.")
parser.add_argument('--mess', type=str, help="Message to send to Kafka", default="Empty message")
args = parser.parse_args()

# Kafka topic
topic_name = "test"

# Create Kafka producer
p = KafkaProducer(
    bootstrap_servers=[config.kafka_ip]
)
json_mess = json.dumps({"id": "n/a", "message": args.mess})

# Send message to Kafka
p.send(topic_name, json_mess.encode("utf-8")) 
p.flush()

print("Message sent:", args.mess)

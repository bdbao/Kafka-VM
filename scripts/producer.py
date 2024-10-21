import json
from kafka import KafkaProducer
import config

topic_name = "test"
p = KafkaProducer(
    bootstrap_servers = [config.kafka_ip]
)
json_mess = json.dumps({"id":"2", "product":"samsung"})

p.send(topic_name, json_mess.encode("utf-8")) 
p.flush()

print("Message sended")

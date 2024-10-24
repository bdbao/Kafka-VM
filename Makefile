CONTAINER_NAMES=kafka-ui debezium kafka1 zookeeper
POSTGRES_NAME=postgresql@16
MYSQL_NAME=mysql

start:
	echo "Starting $(POSTGRES_NAME), $(MYSQL_NAME) and container $(CONTAINER_NAME)..."
	brew services start $(POSTGRES_NAME)
	brew services start $(MYSQL_NAME)
#	docker compose up -d
	docker start $(CONTAINER_NAMES)
	echo "Kafka UI is running at http://localhost:9000"

stop:
	echo "Stopping $(POSTGRES_NAME), $(MYSQL_NAME) and container $(CONTAINER_NAME)..."
	brew services stop $(POSTGRES_NAME)
	brew services stop $(MYSQL_NAME)
	docker stop $(CONTAINER_NAMES)

restart:
	echo "Restarting $(POSTGRES_NAME) and container $(CONTAINER_NAME)..."
	brew services restart $(POSTGRES_NAME)
	brew services restart $(MYSQL_NAME)
	docker restart $(CONTAINER_NAMES)

clean:
	curl -X DELETE http://localhost:8083/connectors/debezium-postgres-connector
	curl -X DELETE http://localhost:8083/connectors/jdbc-sink-connector
#	docker compose down

curl2:
	curl -X POST http://localhost:8083/connectors \
	-H "Content-Type: application/json" \
	-d '{
		"name": "jdbc-sink-connector",
		"config": {
			"connector.class": "io.debezium.connector.jdbc.JdbcSinkConnector",
			"tasks.max": "1",
			"topics": "source.E00Status",
			"connection.url": "jdbc:mysql://localhost:3306/db_kafka?useSSL=false&allowPublicKeyRetrieval=true",
			"connection.username": "user_kafka",
			"connection.password": "Admin@123",
			"auto.create": "true",
			"auto.evolve": "true",
			"insert.mode": "upsert",
			"primary.key.fields": "id",
			"primary.key.mode": "record_key",
			"schema.evolution": "basic",
			"transforms": "unwrap",
			"transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
			"key.converter": "org.apache.kafka.connect.json.JsonConverter",
			"key.converter.schemas.enable": "true",
			"value.converter": "org.apache.kafka.connect.json.JsonConverter",
			"value.converter.schemas.enable": "true"
		}
	}'

startdb:
	echo "Starting $(POSTGRES_NAME), $(MYSQL_NAME)..."
	brew services start $(POSTGRES_NAME)
	brew services start $(MYSQL_NAME)

stopdb:
	echo "Stopping $(POSTGRES_NAME), $(MYSQL_NAME)..."
	brew services stop $(POSTGRES_NAME)
	brew services stop $(MYSQL_NAME)

.PHONY: start stop restart clean startdb stopdb

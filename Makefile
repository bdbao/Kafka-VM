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

startdb:
	echo "Starting $(POSTGRES_NAME), $(MYSQL_NAME)..."
	brew services start $(POSTGRES_NAME)
	brew services start $(MYSQL_NAME)

stopdb:
	echo "Stopping $(POSTGRES_NAME), $(MYSQL_NAME)..."
	brew services stop $(POSTGRES_NAME)
	brew services stop $(MYSQL_NAME)

source:
	curl -i -X POST http://localhost:8083/connectors/ -H "Accept:application/json" -H "Content-Type:application/json" -d @scripts/source.json

sink:
	curl -X DELETE http://localhost:8083/connectors/jdbc-sink-connector
	curl -i -X POST http://localhost:8083/connectors/ -H "Accept:application/json" -H "Content-Type:application/json" -d @scripts/sink.json

.PHONY: start stop restart clean startdb stopdb

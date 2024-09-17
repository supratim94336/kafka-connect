## Setup
### Motivation
1. Setup postgres instance
2. Setup logical write ahead log (WAL)
3. Setup debezium kafka connector
4. Stream wal to kafka stream per table basis

### Diagram
<p align="left">
<img src="static/arch.png" width="400" height="128">
</p>

### Setup tables (optional)
```
CREATE TABLE recipes (
  recipe_id INT NOT NULL,
  recipe_name VARCHAR(30) NOT NULL,
  PRIMARY KEY (recipe_id),
  UNIQUE (recipe_name)
);

CREATE TABLE ingredients (
  ingredient_id INT NOT NULL, 
  ingredient_name VARCHAR(30) NOT NULL,
  ingredient_price INT NOT NULL,
  PRIMARY KEY (ingredient_id),  
  UNIQUE (ingredient_name)
);

ALTER TABLE ingredients REPLICA IDENTITY FULL;
ALTER TABLE recipes REPLICA IDENTITY FULL;
```

### Setup WAL (optional)
alter wal type
```
$ psql -h localhost -p 5435 -d food -U admin
# ALTER SYSTEM SET wal_level = 'logical';
# \q
```
restart postgres container
```
$ docker restart postgres
```
now you have logical wal

### Setup debezium connector
```
$ curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" 127.0.0.1:8083/connectors/ --data "@debezium.json"
```

### Setup consumption
In two different terminals
1. First Terminal
```
$ docker run --tty \
--network kc-test \
confluentinc/cp-kafkacat \
kafkacat -b broker:9092 -C \
-s key=s -s value=avro \
-r http://schema-registry:8085 \
-t postgres.public.ingredients
```
2. Second Terminal
```
$ docker run --tty \
--network kc-test \
confluentinc/cp-kafkacat \
kafkacat -b broker:9092 -C \
-s key=s -s value=avro \
-r http://schema-registry:8085 \
-t postgres.public.recipes
```

### Check Topics (if neccessary)
```
$ docker run --network=kc-test confluentinc/cp-kafkacat kafkacat -b broker:9092 -L
```
or
```
$ docker run --network=kc-test confluentinc/cp-kafkacat kafkacat -b broker:9092 -t postgres.public.recipes -C 
```

## Setup
### Motivation
1. Setup postgres instance
2. Setup debezium kafka connector
3. Stream wal to kafka stream per table basis

### Diagram
<p align="left">
<img src="static/arch.png" width="400" height="128">
</p>

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

### Example postgres inserts
```
INSERT INTO ingredients
    (ingredient_id, ingredient_name, ingredient_price)
VALUES 
    (1, 'Beef', 5),
    (2, 'Lettuce', 1),
    (3, 'Tomatoes', 2);

INSERT INTO recipes
 (recipe_id, recipe_name) 
VALUES
 (1,'Tacos'),
 (2,'Tomato Soup'),
 (3,'Grilled Cheese');
```

### Check Topics (if neccessary)
```
$ docker run --network=kc-test confluentinc/cp-kafkacat kafkacat -b broker:9092 -L
```
or
```
$ docker run --network=kc-test confluentinc/cp-kafkacat kafkacat -b broker:9092 -t postgres.public.recipes -C 
```

### Clean up (if neccessary)
```
$ docker stop $(docker ps -aq)  
$ docker system prune --all
$ docker volume rm $(docker volume ls -q)
```

## Setup
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

### Setup WAL
alter wal type
```
$ psql -h localhost -p 5435 -d n26 -U admin
# ALTER SYSTEM SET wal_level = 'logical';
```
restart postgres container
```
docker restart postgres
```
now you have logical wal

### Setup debezium connector
```
curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" 127.0.0.1:8083/connectors/ --data "@debezium.json"
```

DROP TABLE IF EXISTS ingredients;
CREATE TABLE ingredients (
    ingredient_id INT NOT NULL, 
    ingredient_name VARCHAR(30) NOT NULL,
    ingredient_price INT NOT NULL,
    PRIMARY KEY (ingredient_id)
);

ALTER TABLE ingredients REPLICA IDENTITY FULL;

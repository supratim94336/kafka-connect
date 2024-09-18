DROP TABLE IF EXISTS recipes;
CREATE TABLE recipes (
    recipe_id INT NOT NULL,
    recipe_name VARCHAR(30) NOT NULL,
    PRIMARY KEY (recipe_id)
);

DROP TABLE IF EXISTS ingredients;
CREATE TABLE ingredients (
    ingredient_id INT NOT NULL, 
    ingredient_name VARCHAR(30) NOT NULL,
    ingredient_price INT NOT NULL,
    PRIMARY KEY (ingredient_id)
);

ALTER TABLE ingredients REPLICA IDENTITY FULL;
ALTER TABLE recipes REPLICA IDENTITY FULL;

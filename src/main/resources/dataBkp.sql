----produto
--CREATE TABLE product (
--    pk INT PRIMARY KEY AUTO_INCREMENT,
--    description VARCHAR(100) NOT NULL
--);

----tabela de precos do produto
--CREATE TABLE unitPrice (
--    fkProduct INT,
--    fkUnitOfMeasurement INT,
--    price DECIMAL(10, 6) NOT NULL
--);
--
----unidade de medidas
--CREATE TABLE unitOfMeasurement (
--    pk INT PRIMARY KEY AUTO_INCREMENT,
--    unit VARCHAR(10) NOT NULL,
--    description VARCHAR(100) NOT NULL
--);
--
----um produto pode ter vários precos unitários
--ALTER TABLE unitPrice ADD CONSTRAINT fk_product_unitPrice
--FOREIGN KEY (fkProduct) REFERENCES product (pk);
--
----podemos ter um preco para cada unidade de medida
--ALTER TABLE unitPrice ADD CONSTRAINT fk_unitOfMeasurement_unitPrice
--FOREIGN KEY (fkUnitOfMeasurement) REFERENCES unitOfMeasurement (pk);

--dados para testes
INSERT INTO product (description) VALUES ('Product 1');
INSERT INTO product (description) VALUES ('Product 2');
INSERT INTO product (description) VALUES ('Product 3');
--INSERT INTO unitOfMeasurement (unit, description) VALUES ('KG', 'Quilograma');
--INSERT INTO unitOfMeasurement (unit, description) VALUES ('G', 'Grama');
--INSERT INTO unitOfMeasurement (unit, description) VALUES ('UN', 'Unidade');
--INSERT INTO unitPrice (fkProduct, fkUnitOfMeasurement, price) VALUES (1, 1, 53.67);
--INSERT INTO unitPrice (fkProduct, fkUnitOfMeasurement, price) VALUES (1, 2, 0.05367);
--INSERT INTO unitPrice (fkProduct, fkUnitOfMeasurement, price) VALUES (2, 3, 12.34);
--INSERT INTO unitPrice (fkProduct, fkUnitOfMeasurement, price) VALUES (3, 3, 7);

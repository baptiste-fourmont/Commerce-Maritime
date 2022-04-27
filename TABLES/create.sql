DROP DATABASE IF EXISTS projet_42;
CREATE DATABASE projet_42;
-- suppression des tables précédentes

DROP TABLE IF EXISTS nation;
DROP TABLE IF EXISTS navire;
DROP TABLE IF EXISTS port;
DROP TABLE IF EXISTS voyage;
DROP TABLE IF EXISTS etape_transitoire;
DROP TABLE IF EXISTS produits;

-- creation des tables
CREATE TABLE nation (
    name varchar(32),
    PRIMARY KEY (nom)
);

CREATE TABLE port(
    name varchar(32),
    category int NOT NULL,
    PRIMARY KEY (nom)
);

CREATE TABLE navire(
    id_navire SERIAL,
    type varchar(32) NOT NULL,
    category int NOT NULL, 
    passagers_max int NOT NULL,
    crew int NOT NULL,
    cale_max int NOT NULL,
    PRIMARY KEY(id_navire),
    CONSTRAINT CHK_Navire CHECK (category >= 1 AND category <= 5 and passagers_max > crew)
);

CREATE TABLE voyage(
    begin_date date,
    type varchar(32) NOT NULL,
    duration int NOT NULL,
    passagers int NOT NULL,
    cale int NOT NULL,
    PRIMARY KEY(begin_date)
    CONSTRAINT CHK_Voyage CHECK (passagers >= 0 AND cale > 0);
);

CREATE TABLE etape_transitoire(
    step_id SERIAL,
    distance int NOT NULL,
    ascending_passagers int NOT NULL,
    descending_passagers int NOT NULL,
    PRIMARY KEY(step_id),
    CONSTRAINT CHK_etape_transitoire CHECK (distance >= 0) 
);

CREATE TABLE produits(
    product_id SERIAL,
    name varchar(32) NOT NULL,
    perishable boolean NOT NULL,
    quantity int NOT NULL,
    shelf_life int NOT NULL,
    value_per_kilo int NOT NULL,
    PRIMARY KEY(product_id),
    CONSTRAINT CHK_produits CHECK (quantity > 0 && shelf_life > 1 && value_per_kilo > 0);
);

CREATE TABLE membership(
    name_port varchar(32),
    name_nation varchar(32),
    PRIMARY KEY(name_port, name_nation),
    FOREIGN KEY(name_port) REFERENCES port(name),
    FOREIGN KEY(name_nation) REFERENCES nation(name)
);

CREATE TABLE corresponding(
    id_navire SERIAL,
    begin_date date NOT NULL,
    PRIMARY KEY(id_navire, begin_date),
    FOREIGN KEY(id_navire) REFERENCES navire(id_navire),
    FOREIGN KEY(begin_date) REFERENCES voyage(begin_date)
);

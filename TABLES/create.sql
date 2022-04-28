DROP DATABASE IF EXISTS projet_42;
CREATE DATABASE projet_42;
-- suppression des tables précédentes

DROP TABLE IF EXISTS nation;
DROP TABLE IF EXISTS navire;
DROP TABLE IF EXISTS port;
DROP TABLE IF EXISTS voyage;
DROP TABLE IF EXISTS etape_transitoire;
DROP TABLE IF EXISTS produits;
DROP TABLE IF EXISTS membership;
DROP TABLE IF EXISTS origin;
DROP TABLE IF EXISTS destination;
DROP TABLE IF EXISTS cargo;
DROP TABLE IF EXISTS corresponding;
DROP TABLE IF EXISTS diplomatics_relations;

CREATE TYPE type_navire AS ENUM('Flûte', 'Galion', 'Gabare');
CREATE TYPE type_voyage AS ENUM('intercontinental', 'continental');

-- creation des tables
CREATE TABLE nation (
    name varchar(32) NOT NULL ON UPDATE CASCADE,
    PRIMARY KEY (nom),
    CONSTRAINT CHK_Nation CHECK(name NOT LIKE '%[^A-Z]%') 
);

CREATE TABLE port(
    name varchar(32) NOT NULL ON UPDATE CASCADE,
    category int NOT NULL ON UPDATE CASCADE,
    PRIMARY KEY (nom),
    CONSTRAINT CHK_Port CHECK(name NOT LIKE '%[^A-Z]%' AND category >= 1 AND category <= 5)
);

CREATE TABLE navire(
    id_navire SERIAL NOT NULL,
    type type_navire NOT NULL,
    category int NOT NULL, 
    passagers_max int NOT NULL DEFAULT 0,
    crew int NOT NULL,
    cale_max int NOT NULL DEFAULT 0,
    PRIMARY KEY(id_navire),
    CONSTRAINT CHK_Navire CHECK (crew > 0 AND passagers_max >= 0 AND category >= 1 AND category <= 5 and passagers_max > crew)
);

CREATE TABLE voyage(
    begin_date date NOT NULL DEFAULT current_date,
    type type_voyage NOT NULL,
    duration int NOT NULL,
    passagers int NOT NULL,
    cale int NOT NULL,
    PRIMARY KEY(begin_date)
    CONSTRAINT CHK_Voyage CHECK (passagers >= 0 AND cale > 0);
);

CREATE TABLE etape_transitoire(
    step_id SERIAL NOT NULL,
    distance int NOT NULL DEFAULT 0,
    ascending_passagers int NOT NULL,
    descending_passagers int NOT NULL,
    PRIMARY KEY(step_id),
    CONSTRAINT CHK_etape_transitoire CHECK (distance >= 0) 
);

CREATE TABLE produits(
    product_id SERIAL NOT NULL,
    name varchar(32) NOT NULL,
    perishable boolean NOT NULL,
    quantity int NOT NULL DEFAULT 1,
    volume int NOT NULL DEFAULT 1,
    shelf_life int NOT NULL DEFAULT 1,
    value_per_kilo int NOT NULL DEFAULT 1,
    PRIMARY KEY(product_id),
    CONSTRAINT CHK_produits CHECK (volume > 0 AND quantity > 0 && shelf_life > 0 && value_per_kilo > 0),
    CONSTRAINT CHK_Name CHECK(name NOT LIKE '%[^A-Z]%')
);

CREATE TABLE membership(
    name_port varchar(32) NOT NULL,
    name_nation varchar(32) NOT NULL,
    PRIMARY KEY(name_port, name_nation),
    FOREIGN KEY(name_port) REFERENCES port(name),
    FOREIGN KEY(name_nation) REFERENCES nation(name)
);

CREATE TABLE corresponding(
    id_navire SERIAL,
    begin_date date NOT NULL DEFAULT current_date,
    PRIMARY KEY(id_navire, begin_date),
    FOREIGN KEY(id_navire) REFERENCES navire(id_navire) ON DELETE CASCADE,
    FOREIGN KEY(begin_date) REFERENCES voyage(begin_date) ON DELETE CASCADE
);

CREATE TABLE nationality(
    name_nation varchar(32) NOT NULL,
    id_navire SERIAL NOT NULL,
    PRIMARY KEY(id_navire, name_nation),
    FOREIGN KEY(id_navire) REFERENCES navire(id_navire) ON DELETE CASCADE,
    FOREIGN KEY(name) REFERENCES nation(name) ON DELETE CASCADE
);

CREATE TABLE diplomatics_relations(
    nation1 varchar(32) NOT NULL,
    nation2 varchar(32) NOT NULL,
    CONSTRAINT CHK_nation1 FOREIGN KEY(nation1) REFERENCES nation(name) ON DELETE CASCADE,
    CONSTRAINT CHK_nation2 FOREIGN KEY(nation2) REFERENCES nation(name) ON DELETE CASCADE,
    CONSTRAINT CHK_nations CHECK(nation1 != nation2),
);

CREATE TABLE cargo(
    cargaison_id SERIAL NOT NULL,
    id_navire varchar(32) NOT NULL, 
    product_id SERIAL NOT NULL,
    quantity int NOT NULL,
    volume int NOT NULL,
    cale_max int NOT NULL,
    type type_voyage NOT NULL,
    perishable boolean NOT NULL,

    PRIMARY KEY(caragaison_id),
    FOREIGN KEY(id_navire) REFERENCES navire(id_navire) ON DELETE CASCADE,
    FOREIGN KEY(product_id) REFERENCES produits(product_id) ON DELETE CASCADE,
    FOREIGN KEY(quantity) REFERENCES produits(quantity),
    FOREIGN KEY(cale_max) REFERENCES navire(cale_max),
    FOREIGN KEY(volume) REFERENCES produits(volume),
    FOREIGN KEY(type_voyage) REFERENCES voyage(type),
    FOREIGN KEY(perishable) REFERENCES produits(perishable),

    CONSTRAINT CHK_Produits  CHECK( (perishable == false AND type == 'continentale') OR (perishable == true AND type == 'intercontinental')),
    CONSTRAINT CHK_Cargaison CHECK(quantity * volume < cale_max)
);

CREATE TABLE origin(
    id_navire varchar(32) NOT NULL,
    name varchar(32) NOT NULL,
    FOREIGN KEY(id_navire) REFERENCES navire(id_navire) ON DELETE CASCADE,
    FOREIGN KEY(name) REFERENCES port(name) ON DELETE CASCADE
);

CREATE TABLE destination(
    id_navire varchar(32) NOT NULL,
    name varchar(32) NOT NULL,
    FOREIGN KEY(id_navire) REFERENCES navire(id_navire) ON DELETE CASCADE,
    FOREIGN KEY(name) REFERENCES port(name) ON DELETE CASCADE
);

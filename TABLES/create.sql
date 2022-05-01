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
-- creation des tables
CREATE TABLE nation(
    name varchar(50) NOT NULL,
    PRIMARY KEY (name),
    CONSTRAINT CHK_Nation CHECK(
        name NOT LIKE '%[^A-Z]%'
        AND UNIQUE(name)
    )
);
CREATE TABLE port(
    name varchar(32) NOT NULL,
    category int NOT NULL,
    PRIMARY KEY (name),
    CONSTRAINT CHK_Port CHECK(
        name NOT LIKE '%[^A-Z]%'
        AND category >= 1
        AND category <= 5
        AND UNIQUE(name)
    )
);
CREATE TABLE navire(
    id_navire SERIAL NOT NULL,
    type varchar(50) NOT NULL,
    category int NOT NULL,
    passagers_max int NOT NULL DEFAULT 0,
    crew int NOT NULL,
    cale_max int NOT NULL DEFAULT 0,
    PRIMARY KEY(id_navire),
    CONSTRAINT CHK_Navire CHECK (
        crew > 0
        AND passagers_max >= 0
        AND category >= 1
        AND category <= 5
        AND passagers_max > crew
        AND cale_max >= 0
        AND type NOT LIKE '%[A-Z]%'
    )
);
CREATE TABLE voyage (
    begin_date date NOT NULL DEFAULT current_date,
    type varchar(50) NOT NULL,
    duration int NOT NULL,
    passagers int NOT NULL,
    cale int NOT NULL,
    PRIMARY KEY(begin_date) CONSTRAINT CHK_Voyage CHECK (
        duration > 0
        AND passagers >= 0
        AND cale >= 0
        AND type NOT LIKE '%[A-Z]%'
    )
);
CREATE TABLE etape_transitoire(
    date date NOT NULL DEFAULT current_date,
    numero_etape int NOT NULL,
    ascending_passagers int NOT NULL,
    descending_passagers int NOT NULL,
    PRIMARY KEY(date),
    CONSTRAINT CHK_Etape_Transitoire CHECK (
        UNIQUE(numero_etape)
        AND ascending_passagers >= 0
        AND descending_passagers >= 0
    )
);
CREATE TABLE produits(
    product_id int NOT NULL,
    name varchar(50) NOT NULL,
    perishable boolean NOT NULL,
    quantity int NOT NULL DEFAULT 1,
    shelf_life int NOT NULL DEFAULT 1,
    value_per_kilo int NOT NULL DEFAULT 1,
    PRIMARY KEY(product_id),
    CONSTRAINT CHK_produits CHECK (
        quantity > 0
        AND shelf_life > 0
        AND value_per_kilo > 0
    ),
    CONSTRAINT CHK_Name CHECK(name NOT LIKE '%[^A-Z]%')
);
/* THIS IS NOT IN THE MODEL
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
 FOREIGN KEY(begin_date) REFERENCES voyage(begin_date) ON UPDATE CASCADE
 );
 CREATE TABLE nationality(
 name_nation varchar(32) NOT NULL,
 id_navire SERIAL NOT NULL,
 PRIMARY KEY(id_navire, name_nation),
 FOREIGN KEY(id_navire) REFERENCES navire(id_navire) ON DELETE CASCADE,
 FOREIGN KEY(name_nation) REFERENCES nation(name) ON DELETE CASCADE
 );
 CREATE TABLE diplomatics_relations(
 nation1 varchar(32) NOT NULL,
 nation2 varchar(32) NOT NULL,
 PRIMARY KEY(nation1, nation2),
 CONSTRAINT CHK_nation1 FOREIGN KEY(nation1) REFERENCES nation(name) ON DELETE CASCADE,
 CONSTRAINT CHK_nation2 FOREIGN KEY(nation2) REFERENCES nation(name) ON DELETE CASCADE,
 CONSTRAINT CHK_nations CHECK(nation1 <> nation2)
 );
 CREATE TABLE cargo(
 cargaison_id SERIAL NOT NULL,
 id_navire SERIAL NOT NULL,
 product_id SERIAL NOT NULL,
 quantity int NOT NULL,
 volume int NOT NULL,
 cale_max int NOT NULL,
 type type_voyage NOT NULL,
 perishable boolean NOT NULL,
 cale int NOT NULL,
 PRIMARY KEY(cargaison_id),
 FOREIGN KEY(cale) REFERENCES voyage(cale) ON DELETE CASCADE,
 FOREIGN KEY(id_navire) REFERENCES navire(id_navire) ON DELETE CASCADE,
 FOREIGN KEY(product_id) REFERENCES produits(product_id) ON DELETE CASCADE,
 FOREIGN KEY(quantity) REFERENCES produits(quantity) ON UPDATE CASCADE,
 FOREIGN KEY(cale_max) REFERENCES navire(cale_max) ON UPDATE CASCADE,
 FOREIGN KEY(volume) REFERENCES produits(volume) ON UPDATE CASCADE,
 FOREIGN KEY(type_voyage) REFERENCES voyage(type) ON UPDATE CASCADE,
 FOREIGN KEY(perishable) REFERENCES produits(perishable) ON UPDATE CASCADE,
 CONSTRAINT CHK_Produits CHECK(
 (quantity * volume < cale_max)
 AND (
 perishable = false
 AND type = 'continental'
 )
 OR (
 perishable = true
 AND type = 'intercontinental'
 )
 )
 );
 CREATE TABLE origin(
 id_navire SERIAL NOT NULL,
 name varchar(32) NOT NULL,
 cale int NOT NULL,
 cale_max int NOT NULL,
 PRIMARY KEY(id_navire, name),
 FOREIGN KEY(id_navire) REFERENCES navire(id_navire) ON DELETE CASCADE,
 FOREIGN KEY(name) REFERENCES port(name) ON DELETE CASCADE,
 FOREIGN KEY(cale) REFERENCES voyage(cale) ON UPDATE CASCADE,
 FOREIGN KEY(cale_max) REFERENCES voyage(cale_max) ON UPDATE CASCADE
 );
 CREATE TABLE destination(
 id_navire SERIAL NOT NULL,
 name varchar(32) NOT NULL,
 cale int not NULL CHECK(cale = 0),
 PRIMARY KEY(id_navire, name),
 FOREIGN KEY(id_navire) REFERENCES navire(id_navire) ON DELETE CASCADE,
 FOREIGN KEY(name) REFERENCES port(name) ON DELETE CASCADE,
 FOREIGN KEY(cale) REFERENCES voyage(cale) ON DELETE CASCADE
 );
 */
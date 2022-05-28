DROP SCHEMA IF EXISTS projet_42 CASCADE;
create schema if not exists projet_42 ;
SET search_path TO projet_42;
-- suppression des tables précédentes
DROP TABLE IF EXISTS nation cascade;
DROP TABLE IF EXISTS diplomatics_relation;
DROP TABLE IF EXISTS capturation;
DROP TABLE IF EXISTS port cascade;
DROP TABLE IF EXISTS voyage cascade;
DROP TABLE IF EXISTS etape_transitoire cascade;
DROP TABLE IF EXISTS produit cascade;
DROP TABLE IF EXISTS cargaison;
DROP TABLE IF EXISTS Sell_Product;
DROP TABLE IF EXISTS Buy_Product;
DROP TABLE IF EXISTS navire cascade;
DROP TYPE IF EXISTS type_relation;
DROP TYPE IF EXISTS type_voyage;
DROP TYPE IF EXISTS type_navire;
DROP TYPE IF EXISTS type_pays;

CREATE TYPE type_relation AS ENUM ('alliés commerciaux', 'allié', 'neutre', 'guerre');
CREATE TYPE type_voyage AS ENUM('intercontinental', 'continental');
CREATE TYPE type_navire as ENUM ('Flute', 'Galion', 'Gabare', 'Caravelle') ;
CREATE TYPE type_pays as ENUM ('Europe', 'Amérique', 'Afrique', 'Asie', 'Océanie' ) ;


-- creation des tables
CREATE TABLE nation(
    name varchar(32) NOT NULL,
    name_continent type_pays NOT NULL,
    PRIMARY KEY (name),
    CONSTRAINT CHK_Nation CHECK(
        name NOT LIKE '%[^A-Z]%'
    )
);

CREATE TABLE diplomatics_relation(
    nation_name1 varchar(32) NOT NULL,
    nation_name2 varchar(32) NOT NULL,
    type_relation type_relation NOT NULL,
    PRIMARY KEY(nation_name1, nation_name2),
    FOREIGN KEY(nation_name1) REFERENCES nation(name),
    FOREIGN KEY(nation_name2) REFERENCES nation(name),
    CONSTRAINT CHK_Diplomatic CHECK(
        nation_name1 != nation_name2
    )
);

CREATE TABLE port(
    name varchar(32) NOT NULL,
    category int NOT NULL,
    nation_name varchar(32) NOT NULL,
    PRIMARY KEY (name),
    FOREIGN KEY(nation_name) REFERENCES nation(name),
    CONSTRAINT CHK_Port CHECK(
        name NOT LIKE '%[^A-Z]%'
        AND category >= 1
        AND category <= 5
    )
);

CREATE TABLE navire(
    id_navire SERIAL PRIMARY KEY,
    type type_navire  NOT NULL,
    category int NOT NULL,
    passagers_max int NOT NULL DEFAULT 0,
    crew int NOT NULL,
    cale_max int NOT NULL DEFAULT 0,
    nation_name varchar(32) NOT NULL,
    FOREIGN KEY(nation_name) REFERENCES nation(name),
    CONSTRAINT CHK_Navire CHECK (
        crew > 0
        AND passagers_max >= 0
        AND category >= 1
        AND category <= 5
        AND passagers_max > crew
        AND cale_max >= 0
    )
);

CREATE TABLE capturation(
    nation_name varchar(32) NOT NULL,
    id_navire int NOT NULL,
    date_capture date DEFAULT current_date,
    PRIMARY KEY(nation_name, id_navire),
    -- un bateau ne peut pas se refaire capture le même jour
    UNIQUE(date_capture, id_navire),
    FOREIGN KEY(nation_name) REFERENCES nation(name),
    FOREIGN KEY(id_navire) REFERENCES navire(id_navire)
);

CREATE TABLE voyage (
    id_voyage SERIAL NOT NULL,
    id_navire int NOT NULL,
    type_voyage type_voyage NOT NULL,
    distance int NOT NULL,
    passagers int NOT NULL,
    port_origin varchar(32) NOT NULL,
    port_destination varchar(32) NOT NULL,
    date_depart date NOT NULL,
    date_arrivee date NULL,

    FOREIGN KEY(port_origin) REFERENCES port(name),
    FOREIGN KEY(port_destination) REFERENCES port(name),
    FOREIGN KEY(id_navire) REFERENCES navire(id_navire),
    PRIMARY KEY(id_voyage),
    UNIQUE(date_depart, id_navire),

    CONSTRAINT CHK_Voyage CHECK(
        passagers >= 0
        AND distance >= 0
        AND date_arrivee >= date_depart
        AND type_voyage IN ('intercontinental', 'continental')
    )
    -- un bateau ne peut pas voyager le même jour
);

CREATE TABLE etape_transitoire(
    id_etape SERIAL NOT NULL,

    ascending_passagers int NOT NULL,
    descending_passagers int NOT NULL,
    name_port varchar(32) NOT NULL,
    id_voyage int NOT NULL,
    date_passage date DEFAULT current_date,

    FOREIGN KEY(name_port) REFERENCES port(name),
    FOREIGN KEY(id_voyage) REFERENCES voyage(id_voyage),
    PRIMARY KEY(id_etape),

    UNIQUE(date_passage, id_voyage),

    CONSTRAINT CHK_Etape_Transitoire CHECK(
        ascending_passagers >= 0
        AND descending_passagers >= 0
        AND name_port NOT LIKE '%[^A-Z]%'
    )
);

CREATE TABLE produit(
    product_id SERIAL,
    name varchar(50) NOT NULL,
    perishable boolean NOT NULL,
    shelf_life int NULL DEFAULT 1,
    value_per_kilo int NOT NULL DEFAULT 1,
    volume int NOT NULL DEFAULT 1,
    PRIMARY KEY(product_id),
    CONSTRAINT CHK_produits CHECK (
        shelf_life > 0
        AND value_per_kilo > 0
        AND volume > 0
    ), 
    CONSTRAINT CHK_Name CHECK(name NOT LIKE '%[^A-Z]%'),
    CONSTRAINT CHK_Perishable CHECK(NOT (perishable=true AND shelf_life IS NULL)),
    CONSTRAINT CHK_Perishable2 CHECK(NOT (perishable=false AND shelf_life IS NOT NULL))
);

CREATE TABLE Buy_Product(
    product_id int NOT NULL,
    id_etape int NOT NULL,
    quantity int NOT NULL,

    FOREIGN KEY(product_id) REFERENCES produit(product_id),
    FOREIGN KEY(id_etape) REFERENCES etape_transitoire(id_etape),
    PRIMARY KEY(product_id, id_etape)
);

CREATE TABLE Sell_Product(
    product_id int NOT NULL,
    id_etape int NOT NULL,
    quantity int NOT NULL,
    
    FOREIGN KEY(product_id) REFERENCES produit(product_id),
    FOREIGN KEY(id_etape) REFERENCES etape_transitoire(id_etape),
    PRIMARY KEY(product_id, id_etape)
);

CREATE TABLE cargaison(
    id_voyage int NOT NULL,
    product_id int NOT NULL,
    quantity int NOT NULL,

    PRIMARY KEY(id_voyage, product_id),
    FOREIGN KEY(id_voyage) REFERENCES voyage(id_voyage),
    FOREIGN KEY(product_id) REFERENCES produit(product_id)
);

\COPY nation FROM CSV/nation.dat WITH (FORMAT CSV)
\COPY produit ( name, perishable, shelf_life, value_per_kilo, volume) FROM CSV/produit.dat WITH (FORMAT CSV)
\COPY port ( name, category, nation_name) FROM CSV/port.dat WITH (FORMAT CSV)
\COPY diplomatics_relation FROM CSV/diplomatics_relation.dat WITH (FORMAT CSV)
\COPY navire (type, category, passagers_max, crew, cale_max, nation_name) FROM CSV/navire.dat WITH (FORMAT CSV)
\COPY capturation FROM CSV/capturation.dat WITH (FORMAT CSV)
\COPY voyage (id_navire, type_voyage, distance, passagers, port_origin, port_destination, date_depart, date_arrivee) FROM CSV/voyage.dat WITH (FORMAT CSV)
\COPY etape_transitoire (ascending_passagers, descending_passagers, name_port, id_voyage, date_passage) FROM CSV/etape_transitoire.dat WITH (FORMAT CSV)
\COPY Buy_Product (product_id, id_etape, quantity) FROM CSV/buy_product.dat WITH (FORMAT CSV)
\COPY Sell_Product (product_id, id_etape, quantity) FROM CSV/sell_product.dat WITH (FORMAT CSV)


-- INSERT INTO Buy_Product VALUES (1, '2020-01-01');
-- INSERT INTO Buy_Product VALUES (2, '2020-01-02');
-- INSERT INTO Buy_Product VALUES (3, '2020-01-03');
-- INSERT INTO Buy_Product VALUES (4, '2020-01-04');
-- INSERT INTO Buy_Product VALUES (5, '2020-01-05');
-- INSERT INTO Buy_Product VALUES (6, '2020-01-06');
-- INSERT INTO Buy_Product VALUES (7, '2020-01-07');
-- INSERT INTO Buy_Product VALUES (8, '2020-01-08');
-- INSERT INTO Buy_Product VALUES (9, '2020-01-09');

-- INSERT INTO Sell_Product VALUES (1, '2020-01-01');
-- INSERT INTO Sell_Product VALUES (2, '2020-01-02');
-- INSERT INTO Sell_Product VALUES (3, '2020-01-03');
-- INSERT INTO Sell_Product VALUES (4, '2020-01-04');
-- INSERT INTO Sell_Product VALUES (5, '2020-01-05');
-- INSERT INTO Sell_Product VALUES (6, '2020-01-06');
-- INSERT INTO Sell_Product VALUES (7, '2020-01-07');
-- INSERT INTO Sell_Product VALUES (8, '2020-01-08');
-- INSERT INTO Sell_Product VALUES (9, '2020-01-09');


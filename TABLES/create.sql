create schema if not exists projet_42 ;
SET search_path TO projet_42;
-- suppression des tables précédentes
DROP TABLE IF EXISTS nation cascade;
DROP TABLE IF EXISTS diplomatics_relation;
DROP TABLE IF EXISTS capturation;
DROP TABLE IF EXISTS port cascade;
DROP TABLE IF EXISTS voyage cascade;
DROP TABLE IF EXISTS etape_transitoire cascade;
DROP TABLE IF EXISTS produits cascade;
DROP TABLE IF EXISTS cargaison;
DROP TABLE IF EXISTS Sell_Product;
DROP TABLE IF EXISTS Buy_Product;
DROP TABLE IF EXISTS navire cascade;

CREATE TYPE type_relation AS ENUM ('alliés commerciaux', 'allié', 'neutre', 'guerre');
CREATE TYPE type_voyage AS ENUM('intercontinental', 'continental');

-- creation des tables
CREATE TABLE nation(
    name varchar(50) NOT NULL,
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
    type varchar(50) NOT NULL,
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
        AND type NOT LIKE '%[A-Z]%'
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
    begin_date date NOT NULL DEFAULT current_date,
    id_navire int NOT NULL,
    type_voyage type_voyage NOT NULL,
    duration int NOT NULL,
    passagers int NOT NULL,
    port_origin varchar(32) NOT NULL,
    port_destination varchar(32) NOT NULL,
    FOREIGN KEY(port_origin) REFERENCES port(name),
    FOREIGN KEY(port_destination) REFERENCES port(name),
    FOREIGN KEY(id_navire) REFERENCES navire(id_navire),
    PRIMARY KEY(begin_date), 
    -- un bateau ne peut pas voyager le même jour
    UNIQUE(begin_date, id_navire),
    CONSTRAINT CHK_Voyage CHECK (
        duration > 0
        AND passagers >= 0
    )
);

CREATE TABLE etape_transitoire(
    date_visite date NOT NULL DEFAULT current_date,
    ascending_passagers int NOT NULL,
    descending_passagers int NOT NULL,
    name_port varchar(32) NOT NULL,
    FOREIGN KEY(name_port) REFERENCES port(name),
    PRIMARY KEY(date_visite),
    CONSTRAINT CHK_Etape_Transitoire CHECK (
        ascending_passagers >= 0
        AND descending_passagers >= 0
    )
);


CREATE TABLE produits(
    product_id SERIAL,
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

CREATE TABLE Buy_Product(
    product_id int NOT NULL,
    date_buy date NOT NULL,
    FOREIGN KEY(product_id) REFERENCES produits(product_id),
    FOREIGN KEY(date_buy) REFERENCES etape_transitoire(date_visite),
    PRIMARY KEY(product_id, date_buy)
);

CREATE TABLE Sell_Product(
    product_id int NOT NULL,
    date_buy date NOT NULL,
    FOREIGN KEY(product_id) REFERENCES produits(product_id),
    FOREIGN KEY(date_buy) REFERENCES etape_transitoire(date_visite),
    PRIMARY KEY(product_id, date_buy)
);

CREATE TABLE cargaison(
    begin_date date NOT NULL,
    product_id int NOT NULL,
    volume int NOT NULL,
    PRIMARY KEY(begin_date, product_id),
    FOREIGN KEY(begin_date) REFERENCES voyage(begin_date),
    FOREIGN KEY(product_id) REFERENCES produits(product_id)
);


INSERT INTO nation VALUES ('Cyprus');
INSERT INTO nation VALUES ('San Marino');
INSERT INTO nation VALUES ('Liberia');
INSERT INTO nation VALUES ('Western Sahara');
INSERT INTO nation VALUES ('Lebanon');
INSERT INTO nation VALUES ('Faroe Islands');
INSERT INTO nation VALUES ('Malawi');
INSERT INTO nation VALUES ('Ecuador');
INSERT INTO nation VALUES ('Palau');
INSERT INTO nation VALUES ('Maldives');
INSERT INTO nation VALUES ('Mexico');
INSERT INTO nation VALUES ('Algeria');
INSERT INTO nation VALUES ('Turkmenistan');
INSERT INTO nation VALUES ('Nepal');
INSERT INTO nation VALUES ('Slovenia');


INSERT INTO port VALUES ('Copenhagen', 1, 'Cyprus');
INSERT INTO port VALUES ('San Marino', 2, 'San Marino');
INSERT INTO port VALUES ('Libreville', 3, 'Liberia');
INSERT INTO port VALUES ('Western Sahara', 4, 'Western Sahara');
INSERT INTO port VALUES ('Beirut', 5, 'Lebanon');
INSERT INTO port VALUES ('Torshavn', 1, 'Faroe Islands');
INSERT INTO port VALUES ('Lilongwe', 2, 'Malawi');
INSERT INTO port VALUES ('Quito', 3, 'Ecuador');
INSERT INTO port VALUES ('Palikir', 4, 'Palau');
INSERT INTO port VALUES ('Alofi', 5, 'Maldives');
INSERT INTO port VALUES ('Mexico City', 1, 'Mexico');
INSERT INTO port VALUES ('Algiers', 2, 'Algeria');
INSERT INTO port VALUES ('Dushanbe', 3, 'Turkmenistan');
INSERT INTO port VALUES ('Kathmandu', 4, 'Nepal');
INSERT INTO port VALUES ('Ljubljana', 5, 'Slovenia');

INSERT INTO produits VALUES (DEFAULT, 'Coca-Cola', true, 19, 98, 3);
INSERT INTO produits VALUES (DEFAULT, 'Pepsi', true, 1, 57, 1);
INSERT INTO produits VALUES (DEFAULT, 'Fanta', true, 24, 1, 1);
INSERT INTO produits VALUES (DEFAULT, 'Sprite', false, 1, 20, 1);
INSERT INTO produits VALUES (DEFAULT, 'Coca-Cola Zero', false, 1, 1, 1);
INSERT INTO produits VALUES (DEFAULT, 'Pepsi Max', true, 10, 9, 1);
INSERT INTO produits VALUES (DEFAULT, 'Fanta Max', true, 1, 1, 10);
INSERT INTO produits VALUES (DEFAULT, 'Sprite Max', false, 4, 100, 1);
INSERT INTO produits VALUES (DEFAULT, 'Coca-Cola Light', true, 10, 1, 1);
INSERT INTO produits VALUES (DEFAULT, 'Pepsi Light', true, 5, 10, 1);
INSERT INTO produits VALUES (DEFAULT, 'Fanta Light', false, 10, 1, 1);
INSERT INTO produits VALUES (DEFAULT, 'Sprite Light', true, 3, 1, 10);
INSERT INTO produits VALUES (DEFAULT, 'Cheeseburger', true, 6, 10, 1);
INSERT INTO produits VALUES (DEFAULT, 'Fries', true, 10, 15, 1);
INSERT INTO produits VALUES (DEFAULT, 'Chips', false, 1, 32, 1);
INSERT INTO produits VALUES (DEFAULT, 'Candy', true, 1, 1, 10);

/**
Ca va bloquer nickel
INSERT INTO diplomatics_relation VALUES ('Lebanon', 'Lebanon', 'alliés commerciaux');
INSERT INTO diplomatics_relation VALUES ('Liberia', 'Cyprus', 'alliés commerciaux'); 
**/

INSERT INTO diplomatics_relation VALUES ('Cyprus', 'San Marino', 'allié');
INSERT INTO diplomatics_relation VALUES ('Cyprus', 'Liberia', 'allié');
INSERT INTO diplomatics_relation VALUES ('Cyprus', 'Western Sahara', 'guerre');
INSERT INTO diplomatics_relation VALUES ('Cyprus', 'Lebanon', 'guerre');


INSERT INTO navire VALUES(DEFAULT, 'Caravelle', 1, 10, 5, 10, 'Cyprus');
INSERT INTO navire VALUES(DEFAULT, 'Flûte', 2, 10, 5, 10, 'Lebanon');
INSERT INTO navire VALUES(DEFAULT, 'Gallion', 3, 10, 5, 10, 'Palau');
INSERT INTO navire VALUES(DEFAULT, 'Caravelle', 4, 10, 5, 10, 'Cyprus');
INSERT INTO navire VALUES(DEFAULT, 'Gallion', 5, 10, 5, 10, 'Nepal');
INSERT INTO navire VALUES(DEFAULT, 'Caravelle', 1, 10, 5, 10, 'Slovenia');
INSERT INTO navire VALUES(DEFAULT, 'Caravelle', 2, 10, 5, 10, 'Mexico');


INSERT INTO voyage VALUES ('2010-01-01', 1, 'continental', 30, 10, 'Copenhagen', 'Beirut');
INSERT INTO voyage VALUES ('2016-02-02', 2, 'intercontinental', 30, 10, 'Libreville', 'Quito');
INSERT INTO voyage VALUES ('2017-03-03', 3, 'continental', 30, 10, 'Palikir', 'Algiers');
INSERT INTO voyage VALUES ('2018-01-01', 4, 'intercontinental', 30, 10, 'Copenhagen', 'Copenhagen');
INSERT INTO voyage VALUES ('2019-01-01', 5, 'continental', 10, 10, 'Kathmandu', 'Mexico City');
INSERT INTO voyage VALUES ('2020-01-01', 6, 'intercontinental', 30, 10, 'Ljubljana', 'Copenhagen');
INSERT INTO voyage VALUES ('2021-01-01', 6, 'continental', 30, 10, 'Mexico City', 'Mexico City');


INSERT INTO etape_transitoire VALUES('2020-01-01', 1, 1, 'Beirut');
INSERT INTO etape_transitoire VALUES('2020-01-02', 2, 1, 'Quito');
INSERT INTO etape_transitoire VALUES('2020-01-03', 3, 1, 'Alofi');
INSERT INTO etape_transitoire VALUES('2020-01-04', 4, 1, 'Ljubljana');
INSERT INTO etape_transitoire VALUES('2020-01-05', 5, 1, 'Mexico City');
INSERT INTO etape_transitoire VALUES('2020-01-06', 6, 1, 'Mexico City');
INSERT INTO etape_transitoire VALUES('2020-01-07', 6, 1, 'Torshavn');
INSERT INTO etape_transitoire VALUES('2020-01-08', 6, 1, 'Western Sahara');
INSERT INTO etape_transitoire VALUES('2020-01-09', 6, 1, 'Dushanbe');

INSERT INTO capturation VALUES('Cyprus', 1, '2020-01-01');
INSERT INTO capturation VALUES('Mexico', 1, '2020-01-01');

INSERT INTO Buy_Product VALUES (1, '2020-01-01');
INSERT INTO Buy_Product VALUES (2, '2020-01-02');
INSERT INTO Buy_Product VALUES (3, '2020-01-03');
INSERT INTO Buy_Product VALUES (4, '2020-01-04');
INSERT INTO Buy_Product VALUES (5, '2020-01-05');
INSERT INTO Buy_Product VALUES (6, '2020-01-06');
INSERT INTO Buy_Product VALUES (7, '2020-01-07');
INSERT INTO Buy_Product VALUES (8, '2020-01-08');
INSERT INTO Buy_Product VALUES (9, '2020-01-09');

INSERT INTO Sell_Product VALUES (1, '2020-01-01');
INSERT INTO Sell_Product VALUES (2, '2020-01-02');
INSERT INTO Sell_Product VALUES (3, '2020-01-03');
INSERT INTO Sell_Product VALUES (4, '2020-01-04');
INSERT INTO Sell_Product VALUES (5, '2020-01-05');
INSERT INTO Sell_Product VALUES (6, '2020-01-06');
INSERT INTO Sell_Product VALUES (7, '2020-01-07');
INSERT INTO Sell_Product VALUES (8, '2020-01-08');
INSERT INTO Sell_Product VALUES (9, '2020-01-09');



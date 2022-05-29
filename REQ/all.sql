-- Select the nation, count of ships by nation from the ships table
-- Basic aggregation
SELECT
    nation_name,
    COUNT(*)
FROM
    navire
GROUP BY
    nation_name;

/*
 Les produits qui ont été acheté avec la même quantité
 */
SELECT
    DISTINCT Buy_Product.product_id
FROM
    Buy_Product FULL
    OUTER JOIN Sell_Product ON Buy_Product.id_etape = Sell_Product.id_etape
WHERE
    Buy_Product.quantity = Sell_Product.quantity
ORDER by
    Buy_Product.product_id;

/*  
 Les etapes qui maximisent l’écart entre les passagers montées et descendus
 */
SELECT
    id_etape as numero_etape
FROM
    etape_transitoire
GROUP by
    id_etape
HAVING
    MAX(ascending_passagers) - MIN(descending_passagers) >= ALL (
        SELECT
            MAX(ascending_passagers) - MIN(descending_passagers)
        FROM
            etape_transitoire
        GROUP by
            id_etape
    );

/*
 La somme des années d'arrivées des bateaux durant un voyage
 */
SELECT
    id_navire,
    SUM(
        EXTRACT(
            MONTH
            FROM
                date_arrivee
        )
    ) + SUM(
        EXTRACT(
            YEAR
            FROM
                date_arrivee
        )
    ) + SUM(
        EXTRACT(
            DAY
            FROM
                date_arrivee
        )
    ) as somme
FROM
    voyage
GROUP by
    id_navire
ORDER by
    id_navire;

SELECT
    id_navire,
    (
        SUM(
            EXTRACT(
                MONTH
                FROM
                    date_arrivee
            )
        ) + SUM(
            EXTRACT(
                YEAR
                FROM
                    date_arrivee
            )
        ) + SUM(
            EXTRACT(
                DAY
                FROM
                    date_arrivee
            )
        )
    ) as somme
FROM
    voyage
GROUP by
    id_navire
ORDER by
    id_navire;

SELECT
    id_navire,
    COALESCE(
        SUM(
            EXTRACT(
                MONTH
                FROM
                    date_arrivee
            )
        ),
        0
    ) + COALESCE(
        SUM(
            EXTRACT(
                YEAR
                FROM
                    date_arrivee
            )
        ),
        0
    ) + COALESCE(
        SUM(
            EXTRACT(
                DAY
                FROM
                    date_arrivee
            )
        ),
        0
    ) as somme
FROM
    voyage
GROUP by
    id_navire
ORDER by
    id_navire;

/* Le produit qui a été vendu en plus grande quantité durant une étape */
SELECT
    name,
    quantity
FROM
    Sell_Product NATURAL
    JOIN produit
WHERE
    quantity = (
        SELECT
            MAX(quantity)
        FROM
            Sell_Product
    );

/* Le produit qui a été vendu en plus grande quantité durant une étape */
SELECT
    name,
    quantity
FROM
    Sell_Product NATURAL
    JOIN produit
WHERE
    quantity >= ALL (
        SELECT
            quantity
        FROM
            Sell_Product
    );

WITH RECURSIVE Access(id_voyage, date_passage) AS (
    SELECT
        id_voyage,
        date_depart
    FROM
        voyage
    UNION
    SELECT
        etape_transitoire.id_voyage,
        etape_transitoire.date_passage
    FROM
        etape_transitoire,
        Access
    WHERE
        Access.id_voyage = etape_transitoire.id_voyage
        AND Access.date_passage < etape_transitoire.date_passage
)
SELECT
    id_voyage,
    date_passage
FROM
    Access
ORDER BY
    id_voyage;

-- Select the nations and their percentage of total ports
-- Useful statistic
SELECT
    nation_name,
    ROUND(
        COUNT(*) * 100.0 / (
            SELECT
                COUNT(*)
            FROM
                port
        ),
        2
    ) as percentage
FROM
    port
GROUP BY
    nation_name;

WITH RECURSIVE Access(id_voyage, date_passage, passagers) AS (
    SELECT
        id_voyage,
        date_depart,
        passagers
    FROM
        voyage
    UNION
    SELECT
        etape_transitoire.id_voyage,
        etape_transitoire.date_passage,
        passagers + etape_transitoire.ascending_passagers - etape_transitoire.descending_passagers as passagers_new
    FROM
        etape_transitoire,
        Access NATURAL
        JOIN navire as n
    WHERE
        Access.id_voyage = etape_transitoire.id_voyage
        AND Access.date_passage < etape_transitoire.date_passage
        AND COALESCE(passagers, 0) + COALESCE(etape_transitoire.ascending_passagers, 0) - COALESCE(etape_transitoire.descending_passagers, 0) >= 0
        AND n.passagers_max >= COALESCE(passagers, 0) + COALESCE(etape_transitoire.ascending_passagers, 0) - COALESCE(etape_transitoire.descending_passagers, 0)
)
SELECT
    id_voyage,
    date_passage,
    passagers
FROM
    Access
ORDER BY
    id_voyage;

-- Select all countries that are in war with any other country
-- Subquery in WHERE
SELECT
    *
FROM
    nation
WHERE
    name NOT IN (
        SELECT
            nation_name2
        FROM
            diplomatics_relation
        WHERE
            nation_name1 NOT IN (
                SELECT
                    nation_name2
                FROM
                    diplomatics_relation
                WHERE
                    nation_name1 = name
                    AND type_relation = 'guerre'
            )
    );

-- Select passangers left after a trip (after all descending / ascending movement)
SELECT
    id_voyage,
    (voyage.passagers - steps.net_gain) as voyageurs_restants
FROM
    voyage NATURAL
    JOIN (
        SELECT
            SUM(ascending_passagers) - SUM(descending_passagers) as net_gain,
            id_voyage
        FROM
            etape_transitoire
        GROUP BY
            id_voyage
    ) as steps;

-- Select all ports from the ports table where the nation_name not in war with any other nation
-- query with 3 tables
SELECT
    *
FROM
    port
WHERE
    nation_name NOT IN (
        SELECT
            nation_name2
        FROM
            diplomatics_relation
        WHERE
            nation_name1 NOT IN (
                SELECT
                    nation_name2
                FROM
                    diplomatics_relation
                WHERE
                    nation_name1 = nation_name
                    AND type_relation = 'guerre'
            )
    );

-- Select the ship(s) with the highest cale_max from the ships table
-- Basic subquery + aggregation
SELECT
    *
FROM
    navire
WHERE
    cale_max = (
        SELECT
            MAX(cale_max)
        FROM
            navire
    );

-- Select the ship(s) with the highest passagers_max from the sub table that contains the ships with the max cale_max
-- Subquery in FROM + 2 aggregations
SELECT
    id_navire,
    MAX(passagers_max)
FROM
    (
        SELECT
            *
        FROM
            navire
        WHERE
            cale_max = (
                SELECT
                    MAX(cale_max)
                FROM
                    navire
            )
    ) AS sub
GROUP BY
    id_navire;

-- Select the nation, count of ships by nation from the ships table, only nations with more than 3 ships
-- Aggregation with GROUP BY and HAVING
SELECT
    nation_name,
    COUNT(*)
FROM
    navire
GROUP BY
    nation_name
HAVING
    COUNT(*) > 3;

-- Select all nations, ships
-- Automatic join
SELECT
    *
FROM
    navire NATURAL
    JOIN nation;

-- Selects all trips with unique destination ports
-- Correlated subquery
SELECT
    *
FROM
    VOYAGE as v
WHERE
    v.id_voyage NOT IN (
        SELECT
            v2.id_voyage
        FROM
            VOYAGE as v2
        WHERE
            v.id_voyage <> v2.id_voyage
            AND v.port_destination = v2.port_destination
    );

/*
 Pour chaque navire retourner la distance moyenne de ses trajets, à
 condition qu’il ait réalisé au moins un trajet de plus de 500km
 */
SELECT
    DISTINCT n.id_navire,
    AVG(CAST(v.distance AS REAL))
FROM
    navire n NATURAL
    JOIN voyage v
GROUP BY
    n.id_navire
HAVING
    MAX(v.distance) > 500
ORDER BY
    id_navire;
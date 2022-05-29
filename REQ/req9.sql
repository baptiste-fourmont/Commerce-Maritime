-- For each vessel return the average distance of its trips
-- provided that it has made at least one trip of more than 500km
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

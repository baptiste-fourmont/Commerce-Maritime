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
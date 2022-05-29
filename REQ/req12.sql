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
    id_navire
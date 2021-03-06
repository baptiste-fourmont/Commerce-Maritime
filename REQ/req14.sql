-- The sum of the day, month and year of arrival of a ship for all its voyages
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

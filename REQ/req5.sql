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
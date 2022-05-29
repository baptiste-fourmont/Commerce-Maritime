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
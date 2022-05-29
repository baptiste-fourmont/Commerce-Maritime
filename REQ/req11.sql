--  Steps that maximize the gap between up and down passengers
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

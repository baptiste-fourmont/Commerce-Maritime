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
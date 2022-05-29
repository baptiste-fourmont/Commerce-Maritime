-- The crossing of a journey with passengers verification
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

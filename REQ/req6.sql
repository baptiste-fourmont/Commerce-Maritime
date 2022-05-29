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
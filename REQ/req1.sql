-- Select the nation, count of ships by nation from the ships table
-- Basic aggregation
SELECT
    nation_name,
    COUNT(*)
FROM
    navire
GROUP BY
    nation_name;
-- Select the nations and their percentage of total ports
-- Useful statistic
SELECT
    nation_name,
    ROUND(
        COUNT(*) * 100.0 / (
            SELECT
                COUNT(*)
            FROM
                port
        ),
        2
    ) as percentage
FROM
    port
GROUP BY
    nation_name;
-- Select all ports from the ports table where the nation_name not in war with any other nation
-- query with 3 tables
SELECT
    *
FROM
    port
WHERE
    nation_name NOT IN (
        SELECT
            nation_name2
        FROM
            diplomatics_relation
        WHERE
            nation_name1 NOT IN (
                SELECT
                    nation_name2
                FROM
                    diplomatics_relation
                WHERE
                    nation_name1 = nation_name
                    AND type_relation = 'guerre'
            )
    );
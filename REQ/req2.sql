-- Select all countries that are in war with any other country
-- Subquery in WHERE
SELECT
    *
FROM
    nation
WHERE
    name NOT IN (
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
                    nation_name1 = name
                    AND type_relation = 'guerre'
            )
    );
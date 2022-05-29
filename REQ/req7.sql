-- Select all nations, ships
-- Automatic join
SELECT
    *
FROM
    navire NATURAL
    JOIN nation;
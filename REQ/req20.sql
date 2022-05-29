-- Select passangers left after a trip (after all descending / ascending movement)
SELECT
    id_voyage,
    (voyage.passagers - steps.net_gain) as voyageurs_restants
FROM
    voyage NATURAL
    JOIN (
        SELECT
            SUM(ascending_passagers) - SUM(descending_passagers) as net_gain,
            id_voyage
        FROM
            etape_transitoire
        GROUP BY
            id_voyage
    ) as steps;
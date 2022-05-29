/*  
    Les etapes qui maximisent l’écart entre les passagers montées et descendus
*/
SELECT id_etape as numero_etape
FROM etape_transitoire
GROUP by id_etape
HAVING MAX(ascending_passagers) - MIN(descending_passagers) >= 
ALL ( 
    SELECT MAX(ascending_passagers)- MIN(descending_passagers) 
    FROM etape_transitoire 
    GROUP by id_etape
);
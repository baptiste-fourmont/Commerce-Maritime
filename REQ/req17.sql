WITH RECURSIVE Access(id_voyage, date_passage) AS
(
SELECT id_voyage, date_depart
FROM voyage
UNION
SELECT etape_transitoire.id_voyage, etape_transitoire.date_passage
FROM etape_transitoire, Access
WHERE Access.id_voyage = etape_transitoire.id_voyage AND Access.date_passage < etape_transitoire.date_passage
)
SELECT * FROM Access
ORDER by id_voyage, date_passage;

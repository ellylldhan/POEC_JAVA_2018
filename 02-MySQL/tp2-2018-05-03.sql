-- TP2 03/05/2018 13:45
-- Creer une view selon 
-- annee | Code | Article | PU | qteJanv | qteFev | qteMars | qteAutre

/* article
+----+---------------+----------------------+--------------+-------------+
| id | numeroArticle | designation          | prixUnitaire | prixRevient |
+----+---------------+----------------------+--------------+-------------+
|  1 | BB0001        | Biere Castel 350mL   |         5.25 |        2.63 |
|  2 | BJ0001        | Jus Ananas 1.50L     |         4.20 |        2.10 |
|  3 | BJ0002        | Jus Orange 1.50L     |         4.20 |        2.10 |
|  4 | BV0001        | Listel Gris 75cL     |         4.50 |        2.25 |
|  5 | CS0005        | Gauloise blonde bleu |         8.50 |        4.25 |
+----+---------------+----------------------+--------------+-------------+

commande;
+----+----------------+---------------------+-----------+
| id | numeroCommande | dateCommande        | client_id |
+----+----------------+---------------------+-----------+
|  1 | CDE201700125   | 2017-01-20 00:00:00 |         1 |
|  2 | CDE201700130   | 2017-02-10 00:00:00 |         2 |
|  3 | CDE201700135   | 2017-03-05 00:00:00 |         1 |
|  4 | CDE201700745   | 2017-04-29 00:00:00 |         2 |
+----+----------------+---------------------+-----------+

ligneCommande;
+----+-------------+------------+----------+
| id | commande_id | article_id | quantite |
+----+-------------+------------+----------+
|  1 |           1 |          1 |   128.00 |
|  2 |           1 |          2 |   328.00 |
|  3 |           2 |          1 |    58.00 |
|  4 |           2 |          2 |   128.00 |
|  5 |           3 |          1 |   128.00 |
|  6 |           4 |          2 |  1028.00 |
|  7 |           4 |          2 |  1280.00 |
+----+-------------+------------+----------+

client;
+----+--------------+-----------+---------------+
| id | numeroClient | nomClient | adresseClient |
+----+--------------+-----------+---------------+
|  1 | CLT0001      | Rene      | Rennes        |
|  2 | CLT0002      | Claude    | Clisson       |
+----+--------------+-----------+---------------+*/

-- annee | Code | Article | PU | qteJanv | qteFev | qteMars | qteAutre
-- qteJanv = qte vendue dont le mois est 1 (1=janv)
-- qteAutre = {} est superieure a 3...

-- DROP VIEW IF EXISTS v_achat;
CREATE OR REPLACE VIEW v_stat AS
SELECT year(cmd.dateCommande)                                                AS Annee,
       art.numeroArticle                                                     AS Code,
       art.designation                                                       AS Article,
       art.prixUnitaire                                                      AS PU,
       sum(case when month(cmd.dateCommande) = 1 then l.quantite else 0 end) AS Janv,
       sum(case when month(cmd.dateCommande) = 2 then l.quantite else 0 end) AS Fev,
       sum(case when month(cmd.dateCommande) = 3 then l.quantite else 0 end) AS Mars,
       sum(case when month(cmd.dateCommande) > 3 then l.quantite else 0 end) AS Autre
FROM commande AS cmd,
     article AS art,
     ligneCommande as l
WHERE cmd.id = l.commande_id
  and l.article_id = art.id
GROUP BY annee, code;

SELECT * from v_stat;

---- insert values dans article pour montre que VIEW s'auto-update
INSERT INTO commande (numeroCommande, client_id, dateCommande)
VALUES ('CDE20171248', 2, '2017/02/03'),
       ('CDE20171274', 2, '2017/03/13'),
       ('CDE20177548', 2, '2017/06/03');

SELECT * FROM commande;

INSERT INTO ligneCommande (commande_id, article_id, quantite)
VALUES (5, 3, 1248),
       (6, 4, 4748),
       (7, 5, 1244);

SELECT * FROM v_stat;
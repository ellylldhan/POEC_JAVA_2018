-- TP3 03/05/2018 15:00
-- Creer une view selon 
-- Code | Article | PU | Biere | Vin | Jus | Autre

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
insert into commande values (null, 'CDE201805322', '2018-05-03 15:00:00', 1);
insert into lignecommande values (null, 5, 6, 2);

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

-- Code | Article | PU | Biere | Vin | Jus | Autre
CREATE OR REPLACE VIEW v_rpt0 AS
SELECT numeroArticle                                                      as Code,
       designation                                                        as Article,
       prixUnitaire                                                       as PU,
       sum(case when numeroArticle like "bb%" then l.quantite else 0 end) as Biere,
       sum(case when numeroArticle like "bv%" then l.quantite else 0 end) as Vin,
       sum(case when numeroArticle like "bj%" then l.quantite else 0 end) as Jus,
       sum(case
               when numeroArticle not like "bb%" and numeroArticle not like "bv%" and numeroArticle not like "bj%"
                   then l.quantite
               else 0 end)                                                as Autre
FROM article,
     ligneCommande as l
WHERE l.article_id = article.id
GROUP BY numeroArticle;

/*
+------+--------+---------+---------+---------+
| Code | Biere  | Vin     | Jus     | Autre   |
+------+--------+---------+---------+---------+
| BB   | 314.00 |    0.00 |    0.00 |    0.00 |
| BJ   |   0.00 |    0.00 | 4012.00 |    0.00 |
| BV   |   0.00 | 4748.00 |    0.00 |    0.00 |
| CS   |   0.00 |    0.00 |    0.00 | 1244.00 |
+------+--------+---------+---------+---------+
*/

CREATE OR REPLACE VIEW v_rpt1 AS
SELECT left(numeroArticle, 2)                                             as Code,
       sum(case when numeroArticle like "bb%" then l.quantite else 0 end) as Biere,
       sum(case when numeroArticle like "bv%" then l.quantite else 0 end) as Vin,
       sum(case when numeroArticle like "bj%" then l.quantite else 0 end) as Jus,
       sum(case
               when numeroArticle not like "bb%" and numeroArticle not like "bv%" and numeroArticle not like "bj%"
                   then l.quantite
               else 0 end)                                                as Autre
FROM article,
     ligneCommande as l
WHERE l.article_id = article.id
GROUP BY code;


---- CORRECTION
CREATE OR REPLACE VIEW v_rpt2 AS
SELECT numeroArticle                                                      as Code,
       designation                                                        as Article,
       sum(case when numeroArticle like "bb%" then l.quantite else 0 end) as Biere,
       sum(case when numeroArticle like "bv%" then l.quantite else 0 end) as Vin,
       sum(case when numeroArticle like "bj%" then l.quantite else 0 end) as Jus,
       sum(case
               when not (numeroArticle like "bb%" or numeroArticle like "bv%" or numeroArticle like "bj%")
                   then l.quantite
               else 0 end)                                                as Autre
FROM article,
     ligneCommande as l
WHERE l.article_id = article.id
GROUP BY code;


---- CORRECTION ajout d'une ligne AUTRE
CREATE OR REPLACE VIEW v_rpt3 AS
SELECT numeroArticle                                                                           as Code,
       designation                                                                             as Article,
       prixUnitaire                                                                            as PU,
       (case when left(numeroArticle, 2) = 'BB' then l.quantite else 0 end)                    as BIERE,
       (case when left(numeroArticle, 2) = 'BV' then l.quantite else 0 end)                    as VIN,
       (case when left(numeroArticle, 2) = 'BJ' then l.quantite else 0 end)                    as JUS,
       (case when left(numeroArticle, 2) not in ('BB', 'BV', 'BJ') then l.quantite else 0 end) as AUTRE
FROM article,
     ligneCommande as l
WHERE l.article_id = article.id
GROUP BY code;

---- UNION ALL
CREATE OR REPLACE VIEW v_rpt4 AS
SELECT numeroArticle as Code,
       designation   as Article,
       prixUnitaire  as PU,
       l.quantite    as BIERE,
       0             as VIN,
       0             as JUS,
       0             as AUTRE
FROM article,
     ligneCommande as l
WHERE l.article_id = article.id
  and left(numeroArticle, 2) = 'BB'

UNION ALL

SELECT numeroArticle as Code,
       designation   as Article,
       prixUnitaire  as PU,
       0             as BIERE,
       l.quantite    as VIN,
       0             as JUS,
       0             as AUTRE
FROM article,
     ligneCommande as l
WHERE l.article_id = article.id
  and left(numeroArticle, 2) = 'BV'

UNION ALL

SELECT numeroArticle as Code,
       designation   as Article,
       prixUnitaire  as PU,
       0             as BIERE,
       0             as VIN,
       l.quantite    as JUS,
       0             as AUTRE
FROM article,
     ligneCommande as l
WHERE l.article_id = article.id
  and left(numeroArticle, 2) = 'BJ'

UNION ALL

SELECT numeroArticle as Code,
       designation   as Article,
       prixUnitaire  as PU,
       0             as BIERE,
       0             as VIN,
       0             as JUS,
       l.quantite    as AUTRE
FROM article,
     ligneCommande as l
WHERE l.article_id = article.id
  and left(numeroArticle, 2) not in ('BJ', 'BV', 'BB')

ORDER BY Code;

/* =>
+--------+----------------------+-------+--------+---------+---------+---------+
| Code   | Article              | PU    | BIERE  | VIN     | JUS     | AUTRE   |
+--------+----------------------+-------+--------+---------+---------+---------+
| BB0001 | Biere Castel 350mL   |  5.25 | 128.00 |    0.00 |    0.00 |    0.00 |
| BB0001 | Biere Castel 350mL   |  5.25 |  58.00 |    0.00 |    0.00 |    0.00 |
| BB0001 | Biere Castel 350mL   |  5.25 | 128.00 |    0.00 |    0.00 |    0.00 |
| BJ0001 | Jus Ananas 1.50L     |  4.20 |   0.00 |    0.00 |  128.00 |    0.00 |
| BJ0001 | Jus Ananas 1.50L     |  4.20 |   0.00 |    0.00 | 1028.00 |    0.00 |
| BJ0001 | Jus Ananas 1.50L     |  4.20 |   0.00 |    0.00 |  328.00 |    0.00 |
| BJ0001 | Jus Ananas 1.50L     |  4.20 |   0.00 |    0.00 | 1280.00 |    0.00 |
| BJ0002 | Jus Orange 1.50L     |  4.20 |   0.00 |    0.00 | 1248.00 |    0.00 |
| BV0001 | Listel Gris 75cL     |  4.50 |   0.00 | 4748.00 |    0.00 |    0.00 |
| CH0008 | Cacahuete            | 16.99 |   0.00 |    0.00 |    0.00 |    2.00 |
| CS0005 | Gauloise blonde bleu |  8.50 |   0.00 |    0.00 |    0.00 | 1244.00 |
+--------+----------------------+-------+--------+---------+---------+---------+
*/

---- Groupement
SELECT code,
       article,
       PU,
       sum(biere)                     as Biere,
       sum(vin)                       as Vin,
       sum(jus)                       as Jus,
       sum(autre)                     as Autre,
       sum(Biere + Vin + Jus + Autre) as Total
FROM v_rpt4
GROUP BY code;

/* =>
+--------+----------------------+-------+--------+---------+---------+---------+---------+
| code   | article              | PU    | Biere  | Vin     | Jus     | Autre   | Total   |
+--------+----------------------+-------+--------+---------+---------+---------+---------+
| BB0001 | Biere Castel 350mL   |  5.25 | 314.00 |    0.00 |    0.00 |    0.00 |  314.00 |
| BJ0001 | Jus Ananas 1.50L     |  4.20 |   0.00 |    0.00 | 2764.00 |    0.00 | 2764.00 |
| BJ0002 | Jus Orange 1.50L     |  4.20 |   0.00 |    0.00 | 1248.00 |    0.00 | 1248.00 |
| BV0001 | Listel Gris 75cL     |  4.50 |   0.00 | 4748.00 |    0.00 |    0.00 | 4748.00 |
| CH0008 | Cacahuete            | 16.99 |   0.00 |    0.00 |    0.00 |    2.00 |    2.00 |
| CS0005 | Gauloise blonde bleu |  8.50 |   0.00 |    0.00 |    0.00 | 1244.00 | 1244.00 |
+--------+----------------------+-------+--------+---------+---------+---------+---------+
*/

---- Sous Requete
SELECT code,
       article,
       PU,
       sum(biere)                     as Biere,
       sum(vin)                       as Vin,
       sum(jus)                       as Jus,
       sum(autre)                     as Autre,
       sum(Biere + Vin + Jus + Autre) as Total
FROM (
         SELECT numeroArticle as Code,
                designation   as Article,
                prixUnitaire  as PU,
                l.quantite    as BIERE,
                0             as VIN,
                0             as JUS,
                0             as AUTRE
         FROM article,
              ligneCommande as l
         WHERE l.article_id = article.id
           and left(numeroArticle, 2) = 'BB'
         UNION ALL
         SELECT numeroArticle as Code,
                designation   as Article,
                prixUnitaire  as PU,
                0             as BIERE,
                l.quantite    as VIN,
                0             as JUS,
                0             as AUTRE
         FROM article,
              ligneCommande as l
         WHERE l.article_id = article.id
           and left(numeroArticle, 2) = 'BV'
         UNION ALL
         SELECT numeroArticle as Code,
                designation   as Article,
                prixUnitaire  as PU,
                0             as BIERE,
                0             as VIN,
                l.quantite    as JUS,
                0             as AUTRE
         FROM article,
              ligneCommande as l
         WHERE l.article_id = article.id
           and left(numeroArticle, 2) = 'BJ'
         UNION ALL
         SELECT numeroArticle as Code,
                designation   as Article,
                prixUnitaire  as PU,
                0             as BIERE,
                0             as VIN,
                0             as JUS,
                l.quantite    as AUTRE
         FROM article,
              ligneCommande as l
         WHERE l.article_id = article.id
           and left(numeroArticle, 2) not in ('BJ', 'BV', 'BB')
     ) as v_rpt4
GROUP BY code;


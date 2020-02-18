-- TP 03/05/2018 11:30
-- Creer une view selon 
-- annee ¦ numclient ¦ nomclient ¦ adresse ¦ montantFacture

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

client;
+----+--------------+-----------+---------------+
| id | numeroClient | nomClient | adresseClient |
+----+--------------+-----------+---------------+
|  1 | CLT0001      | Rene      | Rennes        |
|  2 | CLT0002      | Claude    | Clisson       |
+----+--------------+-----------+---------------+

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
+----+-------------+------------+----------+*/

-- annee ¦ numclient ¦ nomclient ¦ adresse ¦ montantFacture

-- DROP VIEW IF EXISTS v_achat;

CREATE OR REPLACE VIEW v_achat AS
SELECT year(cmd.dateCommande)                       as Annee,
       clt.numeroClient                             as numClient,
       clt.nomClient                                as nomClient,
       clt.adresseClient                            as Adresse,
       round(sum(l.quantite * art.prixUnitaire), 2) as Montant
from commande as cmd,
     client as clt,
     article as art,
     ligneCommande as l
where clt.id = cmd.client_id
  and cmd.id = l.commande_id
  and art.id = l.article_id
group by Annee,
         clt.nomClient;


SELECT * FROM v_achat;

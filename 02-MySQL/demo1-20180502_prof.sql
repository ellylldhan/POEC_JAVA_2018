---creation de la bdd poecjava---
create database poecjava;

---entrer dans la bdd poecjava
use poecjava;

--creer la table client--
create table client
(
    id            int auto_increment primary key,
    numeroClient  varchar(20) not null unique,
    nomClient     varchar(250),
    adresseClient varchar(250)
);

----insertion sz données dans la table client-
insert into client (numeroClient, nomClient, adresseClient)
values ('CLT0001', 'René', 'Rennes'),
       ('CLT0002', 'Claude', 'Clisson');
------afficher le contenu de la table client--
select *
from client;
/* =>
+----+--------------+-----------+---------------+
| id | numeroClient | nomClient | adresseClient |
+----+--------------+-----------+---------------+
|  1 | CLT0001      | René      | Rennes        |
|  2 | CLT0002      | Claude    | Clisson       |
+----+--------------+-----------+---------------+
2 rows in set (0.00 sec)
*/

select nomClient, adresseClient
from client;
/* =>
+-----------+---------------+
| nomClient | adresseClient |
+-----------+---------------+
| René      | Rennes        |
| Claude    | Clisson       |
+-----------+---------------+
*/

----créer la table article---
create table article
(
    id            int auto_increment primary key,
    numeroArticle varchar(20) not null unique,
    designation   varchar(250),
    prixUnitaire  decimal(10, 2)
);

----insertion de données dans la table article---
insert into article
values (null, 'BB0001', 'Biere castel 350ml', 2.50),
       (null, 'BJ0001', 'Jus ananas 1.50l', 3.50),
       (null, 'BJ0002', 'Jus orange 1.50l', 3.50),
       (null, 'BV0001', 'Listel Gris 75cl', 4.50),
       (null, 'CS0005', 'Gauloise blonde bleu', '8.50');

-----afficher le contenu de la table article dont id=3---
select *
from article
where id = 3;
/* =>
+----+---------------+------------------+--------------+
| id | numeroArticle | designation      | prixUnitaire |
+----+---------------+------------------+--------------+
|  3 | BJ0002        | Jus orange 1.50l |         3.50 |
+----+---------------+------------------+--------------+
*/

-----afficher tous les article dont prixUnitaire <=4--
select *
from article
where prixUnitaire <= 4;
/* =>
+----+---------------+--------------------+--------------+
| id | numeroArticle | designation        | prixUnitaire |
+----+---------------+--------------------+--------------+
|  1 | BB0001        | Biere castel 350ml |         2.50 |
|  2 | BJ0001        | Jus ananas 1.50l   |         3.50 |
|  3 | BJ0002        | Jus orange 1.50l   |         3.50 |
+----+---------------+--------------------+--------------+
*/

--afficher tous les articles dont le numero commence par BJ
select *
from article
where numeroArticle like 'BJ%';
/* =>
+----+---------------+------------------+--------------+
| id | numeroArticle | designation      | prixUnitaire |
+----+---------------+------------------+--------------+
|  2 | BJ0001        | Jus ananas 1.50l |         3.50 |
|  3 | BJ0002        | Jus orange 1.50l |         3.50 |
+----+---------------+------------------+--------------+
*/

---afficher tous les articles dont la designation contient la lettre 'e'
select *
from article
where designation like '%e%';

---------afficher par ordre alphabetique croissant au numeroArticle;
select *
from article
order by numeroArticle asc;

---afficher tous les articles dont la designation contient la lettre 'e' et classer 
---ordre par ordre alphabetique croissant au numeroArticle
select *
from article
where designation like '%e%'
order by numeroArticle;
/* =>
+----+---------------+----------------------+--------------+
| id | numeroArticle | designation          | prixUnitaire |
+----+---------------+----------------------+--------------+
|  1 | BB0001        | Biere castel 350ml   |         2.50 |
|  3 | BJ0002        | Jus orange 1.50l     |         3.50 |
|  4 | BV0001        | Listel Gris 75cl     |         4.50 |
|  5 | CS0005        | Gauloise blonde bleu |         8.50 |
+----+---------------+----------------------+--------------+
*/

----creation de la table commande--
create table commande
(
    id             int auto_increment primary key,
    numeroCommande varchar(20) not null unique,
    dateCommande   timestamp,
    client_id      int         not null,
    foreign key (client_id) references client (id)
);

---afficher la structure d'une table créée
desc commande;
/* =>
+----------------+-------------+------+-----+-------------------+-----------------------------+
| Field          | Type        | Null | Key | Default           | Extra                       |
+----------------+-------------+------+-----+-------------------+-----------------------------+
| id             | int(11)     | NO   | PRI | NULL              | auto_increment              |
| numeroCommande | varchar(20) | NO   | UNI | NULL              |                             |
| dateCommande   | timestamp   | NO   |     | CURRENT_TIMESTAMP | on update CURRENT_TIMESTAMP |
| client_id      | int(11)     | NO   | MUL | NULL              |                             |
+----------------+-------------+------+-----+-------------------+-----------------------------+
*/

---afficher le script sql à la creation de la table commande
show create table commande;
/* =>
+----------+----------------------------------------------------------------------------------------------+
| Table    | Create Table                                                                                                                                                       |
+----------+----------------------------------------------------------------------------------------------+
| commande | CREATE TABLE `commande` (
				`id` int(11) NOT NULL AUTO_INCREMENT,
				`numeroCommande` varchar(20) NOT NULL,
				`dateCommande` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
				`client_id` int(11) NOT NULL,
				PRIMARY KEY (`id`),
				UNIQUE KEY `numeroCommande` (`numeroCommande`),
				KEY `client_id` (`client_id`),
				CONSTRAINT `commande_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`)
				) ENGINE=InnoDB DEFAULT CHARSET=latin1 |
+----------+----------------------------------------------------------------------------------------------+
*/

----insertion de données dans la table commande
insert into commande (client_id, numeroCommande, dateCommande)
values (1, 'CDE201700125', '2017/01/20'),
       (2, 'CDE201700130', '2017/02/10'),
       (1, 'CDE201700315', '2017/03/05'),
       (2, 'CDE201700745', '2017/04/29');

------exemple d'erreur---
insert into commande (client_id, numeroCommande, dateCommande)
values (10, 'CDE201704478', '2017/01/20');

---afficher le contenu de la table commande
select *
from commande;
/* =>
+----+----------------+---------------------+-----------+
| id | numeroCommande | dateCommande        | client_id |
+----+----------------+---------------------+-----------+
|  1 | CDE201700125   | 2017-01-20 00:00:00 |         1 |
|  2 | CDE201700130   | 2017-02-10 00:00:00 |         2 |
|  3 | CDE201700315   | 2017-03-05 00:00:00 |         1 |
|  4 | CDE201700745   | 2017-04-29 00:00:00 |         2 |
+----+----------------+---------------------+-----------+
*/

---- Afficher une combinaison de données venant de plusieurs tables
select cde.numeroCommande,
       cde.dateCommande,
       clt.nomClient,
       clt.adresseClient
from commande as cde,
     client as clt
where cde.client_id = clt.id;
/* =>
+----------------+---------------------+-----------+---------------+
| numeroCommande | dateCommande        | nomClient | adresseClient |
+----------------+---------------------+-----------+---------------+
| CDE201700125   | 2017-01-20 00:00:00 | René      | Rennes        |
| CDE201700130   | 2017-02-10 00:00:00 | Claude    | Clisson       |
| CDE201700315   | 2017-03-05 00:00:00 | René      | Rennes        |
| CDE201700745   | 2017-04-29 00:00:00 | Claude    | Clisson       |
+----------------+---------------------+-----------+---------------+
*/

----creation d'une view à partir d'une requete
create view v_commande as
select cde.numeroCommande, cde.dateCommande, clt.nomClient, clt.adresseClient
from commande as cde,
     client as clt
where cde.client_id = clt.id;

----afficher le contenu d'une view
select *
from v_commande;

---creation de la table ligneCommande
create table ligneCommande
(
    id          integer auto_increment primary key,
    commande_id int not null,
    article_id  int not null,
    quantite    decimal(8, 2),
    foreign key (commande_id) references commande (id),
    foreign key (article_id) references article (id)
);

--------insertion de données dans la table ligneCommande--
insert into ligneCommande (commande_id, article_id, quantite)
values (1, 1, 128),
       (1, 2, 328),

       (2, 1, 58),
       (2, 2, 128),

       (3, 1, 1208),

       (4, 2, 1028),
       (4, 2, 1280);

MariaDB [poecjava]>
select *
from lignecommande;
/*
+----+-------------+------------+----------+
| id | commande_id | article_id | quantite |
+----+-------------+------------+----------+
|  1 |           1 |          1 |   128.00 |
|  2 |           1 |          2 |   328.00 |
|  3 |           2 |          1 |    58.00 |
|  4 |           2 |          2 |   128.00 |
|  5 |           3 |          1 |  1208.00 |
|  6 |           4 |          2 |  1028.00 |
|  7 |           4 |          2 |  1280.00 |
+----+-------------+------------+----------+
*/

---
create view v_ligneCommande as
select c.numeroCommande,
       a.numeroArticle,
       a.designation,
       a.prixUnitaire              as pu,
       l.quantite                  as qte,
       l.quantite * a.prixUnitaire as Montant

from commande as c,
     ligneCommande as l,
     article as a
where l.commande_id = c.id
  and l.article_id = a.id;

select *
from v_ligneCommande;

MariaDB [poecjava]>
select *
from v_ligneCommande;

/*
+----------------+---------------+--------------------+------+---------+-----------+
| numeroCommande | numeroArticle | designation        | pu   | qte     | Montant   |
+----------------+---------------+--------------------+------+---------+-----------+
| CDE201700125   | BB0001        | Biere castel 350ml | 2.50 |  128.00 |  320.0000 |
| CDE201700130   | BB0001        | Biere castel 350ml | 2.50 |   58.00 |  145.0000 |
| CDE201700315   | BB0001        | Biere castel 350ml | 2.50 | 1208.00 | 3020.0000 |
| CDE201700125   | BJ0001        | Jus ananas 1.50l   | 3.50 |  328.00 | 1148.0000 |
| CDE201700130   | BJ0001        | Jus ananas 1.50l   | 3.50 |  128.00 |  448.0000 |
| CDE201700745   | BJ0001        | Jus ananas 1.50l   | 3.50 | 1028.00 | 3598.0000 |
| CDE201700745   | BJ0001        | Jus ananas 1.50l   | 3.50 | 1280.00 | 4480.0000 |
*/


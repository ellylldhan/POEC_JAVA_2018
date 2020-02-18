--creation de la bdd poecjava
create database poecjava;

--entrer dans la bdd
use poecjava;

--creer la table client
create table client (
	id int auto_increment primary key,
	numeroClient varchar(20) not null unique,
	nomClient varchar(250),
	adresseClient varchar(250)
	);

----insertion de donnees dans la table 
insert into client (numeroClient, nomClient, adresseClient) values
    ('CLT0001', 'Rene', 'Rennes'),
    ('CLT0002', 'Claude', 'Clisson');

----afficher le contenu de la table client
select * from client;
select nomClient, adresseClient from client;

/* => TABLE client
+----+--------------+-----------+---------------+
| id | numeroClient | nomClient | adresseClient |
+----+--------------+-----------+---------------+
|  1 | CLT0001      | René      | Rennes        |
|  2 | CLT0002      | Claude    | Clisson       |
+----+--------------+-----------+---------------+
2 rows in set (0.00 sec)
*/

----creer la table article
create table article (
	id int auto_increment primary key,
	numeroArticle varchar(20) not null unique,
	designation varchar(250),
	prixUnitaire decimal(10, 2)
	);
	
----afficher la totalite des tables presentes dans une bdd donnee
show tables;
/* =>
+--------------------+
| Tables_in_poecjava |
+--------------------+
| article            |
| client             |
| commande           |
| lignecommande      |
| v_commande         |
+--------------------+
5 rows in set (0.00 sec)
*/

----insertion dans table
insert into article values
	(null, 'BB0001', 'Biere Castel 350mL', 2.50),
	(null, 'BJ0001', 'Jus Ananas 1.50L', 3.50),
	(null, 'BJ0002', 'Jus Orange 1.50L', 3.50),
	(null, 'BV0001', 'Listel Gris 75cL', 4.50),
	(null, 'CS0005', 'Gauloise blonde bleu', 8.50);

----afficher le contenu de la cellule de table dont l'id est 3
select * from article where id=3;

----affiche tous articles dont prix inf ou egal a 4
select * from article where prixUnitaire<=4;

----afficher tous art dont numero commence par BJ
select * from article where numeroArticle like "BJ%";

----affiche tous art dont designation contient 'e'
select * from article where designation like "%e%";

----affichage par ordre alpha
select * from article order by numeroArticle asc;

-----cherche et tri resultat
select * from article 
where designation like "%e%" 
order by numeroArticle desc;

----creation de la table commande
create table commande (
	id int auto_increment primary key,
	numeroCommande varchar(20) not null unique,
	dateCommande timestamp,
	client_id int not null,							/* d'abord creer cle avec attributs, */
	foreign key (client_id) references client(id)   /* puis declarer foreign key */
	);

----afficher la structure d'une table
desc commande;  --desc=describe
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

----afficher le schema
show create table commande;
/* => table COMMANDE
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

----insertion de donnee dans table commande
insert into commande (client_id, numeroCommande, dateCommande) values
	(1, 'CDE201700125', '2017/01/20'),
	(2, 'CDE201700130', '2017/02/10'),
	(1, 'CDE201700135', '2017/03/05'),
	(2, 'CDE201700745', '2017/04/29');

----Croiser des tables par leur point commun
select cde.numeroCommande, cde.dateCommande, clt.nomClient, clt.adresseClient
from commande as cde, client as clt 
where cde.client_id=clt.id;

/* COMBINAISON de commande et client
+----------------+---------------------+-----------+---------------+
| numeroCommande | dateCommande        | nomClient | adresseClient |
+----------------+---------------------+-----------+---------------+
| CDE201700125   | 2017-01-20 00:00:00 | René      | Rennes        |
| CDE201700130   | 2017-02-10 00:00:00 | Claude    | Clisson       |
| CDE201700315   | 2017-03-05 00:00:00 | René      | Rennes        |
| CDE201700745   | 2017-04-29 00:00:00 | Claude    | Clisson       |
+----------------+---------------------+-----------+---------------+
*/

----CREATE VIEW
create view v_commande as
	select cde.numeroCommande, cde.dateCommande, clt.nomClient, clt.adresseClient
	from commande as cde, client as clt 
	where cde.client_id=clt.id;

show tables;

----Affichage contenu VIEW
select * from v_commande;

----creation de la table LigneCommande
create table ligneCommande (
	id int auto_increment not null primary key,
	commande_id int not null,
	article_id int,
	quantite decimal(8,2),
	foreign key (commande_id) references commande(id),
	foreign key (article_id) references article(id)
	);

----insertion data dans ligneCommande
insert into ligneCommande (commande_id, article_id, quantite)
values
	(1,1,128),
	(1,2,328),
	(2,1,58),
	(2,2,128),
	(3,1,128),
	(4,2,1028),
	(4,2,1280);

SELECT * FROM ligneCommande;
/* TABLE ligneCommande
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
*/

----VIEW 
create view v_LigneCommande as 
select 
	c.numeroCommande, 
	a.numeroArticle, a.designation, a.prixUnitaire as pu, 
	l.quantite as qte, 
	l.quantite*a.prixUnitaire as Montant
from commande c, ligneCommande l, article a    			/* omission volontaire des 'as' */
where l.commande_id=c.id and l.article_id=a.id;

/* v_LigneCommande
+----------------+---------------+--------------------+------+---------+-----------+
| numeroCommande | numeroArticle | designation        | pu   | qte     | Montant   |
+----------------+---------------+--------------------+------+---------+-----------+
| CDE201700125   | BB0001        | Biere castel 350ml | 2.50 |  128.00 |  320.0000 |
| CDE201700130   | BB0001        | Biere castel 350ml | 2.50 |   58.00 |  145.0000 |
| CDE201700315   | BB0001        | Biere castel 350ml | 2.50 |  128.00 |  320.0000 |
| CDE201700125   | BJ0001        | Jus ananas 1.50l   | 3.50 |  328.00 | 1148.0000 |
| CDE201700130   | BJ0001        | Jus ananas 1.50l   | 3.50 |  128.00 |  448.0000 |
| CDE201700745   | BJ0001        | Jus ananas 1.50l   | 3.50 | 1028.00 | 3598.0000 |
| CDE201700745   | BJ0001        | Jus ananas 1.50l   | 3.50 | 1280.00 | 4480.0000 |
+----------------+---------------+--------------------+------+---------+-----------+
*/

---- 03/05/2018
---- exemple DROP TABLE
create table product (
	id int auto_increment primary key,
	test_field char(50)
	);
drop table product;

---- duplicate table
create table produit like article;              /* meth1: copie uniquement schema, sans contraintes (ex: prk), sans data */
insert into produit select * from article;

create table produits as select * from article; /* meth2: duplicate */

---- duplicate avec condition
insert into produit select * from article where id<=3; 

---- delete avec condition
delete from produits where numeroArticle='BV0001';

---- supprimer toutes les entrees de produits
delete from produits;                  /* meth1 */
truncate table if exists produits;     /* meth2 */

---- modifier le prix d'un produit
update article set prixUnitaire=5.25 where id=1;

---- augmenter le prix des jus de 20%
update article 
	set prixUnitaire=prixUnitaire*1.20 
	where numeroArticle like 'BJ%';

---- rajouter une colonne prixRevient et mettre a jour prix a 50% du pu
alter table article add column prixRevient decimal(10,2);
update article set prixRevient=prixUnitaire*0.50;




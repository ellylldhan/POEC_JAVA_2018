/* 
 * POSTGRESQL 
 * Cours semaine 23/05/2018
 * JP BOTO
 */

-- Se connecter au serveur
$ psql -U postgres

-- Creation db
CREATE DATABASE poecjava;

-- Se connecter a la bdd
\c poecjava

-- Creation table Tiers
DROP TABLE tiers;
CREATE TABLE tiers
(
    id       SERIAL PRIMARY KEY,
    numTiers VARCHAR(20) NOT NULL UNIQUE,
    nomTiers VARCHAR(250),
    adrTiers VARCHAR(250)
);

-- Insertion de valeurs
INSERT INTO tiers (numTiers, nomTiers, adrTiers)
VALUES ('CLT0124', 'Jean-Claude', 'Clisson');

-- Creation d'une sequence numero_tiers_seq
DROP SEQUENCE IF EXISTS numero_tiers_seq CASCADE;
CREATE SEQUENCE numero_tiers_seq START 125;
ALTER TABLE tiers
ALTER numTiers SET DEFAULT NEXTVAL('numero_tiers_seq');
INSERT INTO tiers (nomTiers, adrTiers)
VALUES ('Jean-Pierre', 'Nantes'),
       ('Quentin', 'Rennes');
ALTER TABLE tiers
ALTER numTiers SET DEFAULT CONCAT('CLT', LTRIM(to_char(NEXTVAL('numero_tiers_seq'), '0000')));

/* Exemples TO_CHAR
SELECT TO_CHAR(10, '0000');
SELECT TO_CHAR(125, '00000');
SELECT CONCAT('CLT', TO_CHAR(125,'00000'));
SELECT CONCAT('CLT', LTRIM(TO_CHAR(125,'00000')));
*/

-- Creation d'un fonction numeroter
CREATE OR REPLACE 
    FUNCTION numeroter(prefixe VARCHAR(20), nomSequence VARCHAR(50))
    RETURNS VARCHAR(100) AS $$
BEGIN
    RETURN concat(prefixe, ltrim(to_char(nextval(nomSequence), '0000000')));
END;
$$language plpgsql;


/* SYNTAXE FUNCTION
 * ================
CREATE [OR REPLACE] FUNCTION function_name (arguments)
    RETURNS return_datatype AS $variable_name$  
    DECLARE
        declaration;
        [...]
    BEGIN
        < function_body >
        [...]
        RETURN { variable_name | value }
    END; LANGUAGE plpgsql;
*/

-- afficher tous les noms des fonctions creees
\df 

-- afficher le contenu dans un editeur externe
\ef numeroter

-- supprimer fonction
DROP FUNCTION numeroter(prefix VARCHAR(20), nomSequence VARCHAR(50));

-- Creation de la table article
DROP SEQUENCE IF EXISTS numero_article_seq CASCADE;
CREATE SEQUENCE numero_article_seq START 500;
CREATE TABLE article
(
    id          SERIAL PRIMARY KEY,
    numArticle  VARCHAR(20) NOT NULL UNIQUE,
    designation VARCHAR(250),
    prixUnit    DECIMAL(10, 2),
    prixRevient FLOAT
);

ALTER TABLE article
ALTER numArticle
SET DEFAULT numeroter('ART', 'numero_article_seq');

-- Insertion de donnees
INSERT INTO article (designation, prixUnit, prixRevient)
VALUES ('Vin Listel Gris 3L', 11.50, 7.20),
       ('Biere Castel 350mL', 2.45, 1.50),
       ('Stylo Bic', 1.50, 0.50);
SELECT *
FROM article;

-- Table COMMANDE
DROP SEQUENCE IF EXISTS numero_commande_seq CASCADE;
CREATE SEQUENCE numero_commande_seq START 1000;
DROP TABLE IF EXISTS commande CASCADE;
CREATE TABLE commande
(
    id           SERIAL PRIMARY KEY,
    dateCommande timestamp,
    numCommande  VARCHAR(20) NOT NULL UNIQUE DEFAULT numeroter('CDE', 'numero_commande_seq'),
    typeCommande VARCHAR(10) NOT NULL,
    tiers_id     INTEGER     NOT NULL,
    FOREIGN KEY (tiers_id) REFERENCES tiers (id)
);

--ALTER TABLE commande ADD CHECK (typeCommande in ('APP','VTE')); 

-- Insertion de donnees dans commande
INSERT INTO commande (tiers_id, dateCommande, typeCommande)
VALUES (1, '2017-01-21', 'VTE'),
       (2, '2017-02-07', 'VTE'),
       (3, '2017-03-15', 'VTE'),
       (2, '2017-04-25', 'VTE');

-- Creation de la table ligneCommande
DROP TABLE IF EXISTS ligneCommande CASCADE;
CREATE TABLE ligneCommande
(
    id          SERIAL primary key,
    commande_id integer,
    article_id  integer not null,
    quantite    decimal(10, 2),
    foreign key (commande_id) references commande (id),
    foreign key (article_id) references article (id)
);

INSERT INTO ligneCommande(commande_id, article_id, quantite)
VALUES (1, 4, 1428),
       (1, 2, 2458),
       (2, 3, 4587),
       (3, 2, 4587),
       (4, 3, 4588);


----- CORRECTION TD
create or replace view v_ca_tiers AS
select extract(year from c.dateCommande)      as annee,
       t.numTiers,
       t.nomTiers,
       round(sum(l.quantite * a.prixunit), 2) as ca
from commande c,
     lignecommande l,
     tiers t,
     article a
where c.tiers_id = t.id
  and l.commande_id = c.id
  and l.article_id = a.id
group by annee, t.numTiers, t.nomTiers;

--- Deuxieme vue
create or replace view v_ca_annee as
select extract(year from c.dateCommande)      as annee,
       round(sum(l.quantite * a.prixunit), 2) as ca
from commande c,
     ligneCommande l,
     article a
where l.commande_id = c.id
  and l.article_id = a.id
group by annee;

--- Troisieme vue
CREATE OR REPLACE VIEW v_ca_pourcentage AS
SELECT v1.*, round((v1.ca / v2.ca) * 100, 2) as "%"
FROM v_ca_tiers v1,
     v_ca_annee v2
WHERE v1.annee = v2.annee;


----- CTE : Common Table Expression -- vue temporaire
with v1(annee, numTiers, nomTiers, ca) as
         (select extract(year from c.dateCommande)      as annee,
                 t.numTiers,
                 t.nomTiers,
                 round(sum(l.quantite * a.prixunit), 2) as ca
          from commande c,
               lignecommande l,
               tiers t,
               article a
          where c.tiers_id = t.id
            and l.commande_id = c.id
            and l.article_id = a.id
          group by annee, t.numTiers, t.nomTiers
         ),
     v2(annee, ca) as
         (
             select extract(year from c.dateCommande)      as annee,
                    round(sum(l.quantite * a.prixunit), 2) as ca
             from commande c,
                  ligneCommande l,
                  article a
             where l.commande_id = c.id
               and l.article_id = a.id
             group by annee
         )
select v1.*, round((v1.ca / v2.ca) * 100, 2) as "%"
from v1,
     v2
where v1.annee = v2.annee;


---- FENETRAGE ----
select *, sum(ca)
from v_ca_tiers;
/* ERREUR */
/*
ERROR:  column "v_ca_tiers.annee" must appear in the GROUP BY clause or be used in an aggregate function
*/

select *, sum(ca) over ()
from v_ca_tiers;
/*
 annee | numtiers |  nomtiers   |    ca    |    sum    
-------+----------+-------------+----------+-----------
  2017 | CLT0125  | Jean-Pierre | 22478.75 | 105638.25
  2017 | CLT0124  | Jean-Claude | 30409.00 | 105638.25
  2017 | CLT0126  | Quentin     | 52750.50 | 105638.25
*/

select *, sum(ca) over (partition by annee) as total
from v_ca_tiers;
/*
 annee | numtiers |  nomtiers   |    ca    |   total   
-------+----------+-------------+----------+-----------
  2017 | CLT0124  | Jean-Claude | 30409.00 | 105638.25
  2017 | CLT0125  | Jean-Pierre | 22478.75 | 105638.25
  2017 | CLT0126  | Quentin     | 52750.50 | 105638.25
*/


select *,
       sum(ca) over (partition by annee)                          as total,
       round((ca / (sum(ca) over (partition by annee))) * 100, 2) as "%"
from v_ca_tiers;
/*
 annee | numtiers |  nomtiers   |    ca    |   total   |   %   
-------+----------+-------------+----------+-----------+-------
  2017 | CLT0124  | Jean-Claude | 30409.00 | 105638.25 | 28.79
  2017 | CLT0125  | Jean-Pierre | 22478.75 | 105638.25 | 21.28
  2017 | CLT0126  | Quentin     | 52750.50 | 105638.25 | 49.94
*/

-- Avec une expression de table commune (with())
create or replace view v_pourcentage_ca_over as
with v1 (annee, numTiers, nomTiers, ca) as
         (select extract(year from c.dateCommande)      as annee,
                 t.numTiers,
                 t.nomTiers,
                 round(sum(l.quantite * a.prixunit), 2) as ca
          from commande c,
               lignecommande l,
               tiers t,
               article a
          where c.tiers_id = t.id
            and l.commande_id = c.id
            and l.article_id = a.id
          group by annee, t.numTiers, t.nomTiers
         )
select *,
       sum(ca) over (partition by annee)                          as total,
       round((ca / (sum(ca) over (partition by annee))) * 100, 2) as "%"
from v1;

/* select * from v_pourcentage_ca_over;
 annee | numtiers |  nomtiers   |    ca    |   total   |   %   
-------+----------+-------------+----------+-----------+-------
  2017 | CLT0125  | Jean-Pierre | 22478.75 | 105638.25 | 21.28
  2017 | CLT0124  | Jean-Claude | 30409.00 | 105638.25 | 28.79
  2017 | CLT0126  | Quentin     | 52750.50 | 105638.25 | 49.94
*/


--- HERITAGE
-- Creation de la table Client qui herite la table Tiers
create sequence numero_client_seq start 100;
create table if not exists client
(
) inherits
(
    tiers
);
alter table client
alter numTiers set default numeroter('CLT', 'numero_client_seq');
alter table client
    add check (left(numTiers, 3) = 'CLT');
alter table client
    add unique (numTiers);

-- iinsertion donnees table client
insert into client (nomTiers, adrTiers)
VALUES ('Richard', 'Vitre');


/*
 id |  numtiers  | nomtiers | adrtiers 
----+------------+----------+----------
  4 | CLT0000100 | Richard  | Vitre
(1 row)

poecjava=# select * from tiers;
 id |  numtiers  |  nomtiers   | adrtiers 
----+------------+-------------+----------
  1 | CLT0124    | Jean-Claude | Clisson
  2 | CLT0125    | Jean-Pierre | Nantes
  3 | CLT0126    | Quentin     | Rennes
  4 | CLT0000100 | Richard     | Vitre
(4 rows)
*/

-- afficher les enregistrements de la table tiers eulement
select *
from only tiers;

-- detacher 
alter table client no inherit tiers;
select *
from client;
select *
from tiers;

/*
poecjava=# select * from client;
 id |  numtiers  | nomtiers | adrtiers 
----+------------+----------+----------
  4 | CLT0000100 | Richard  | Vitre
(1 row)

poecjava=# select * from tiers;
 id | numtiers |  nomtiers   | adrtiers 
----+----------+-------------+----------
  1 | CLT0124  | Jean-Claude | Clisson
  2 | CLT0125  | Jean-Pierre | Nantes
  3 | CLT0126  | Quentin     | Rennes
(3 rows)
*/

-- insertion de nouvelle data dans client --qui est detachee de tiers
insert into client (nomTiers, adrTiers)
values ('Clement', 'Thorigne');

-- Rattacher client a tiers
alter table client inherit tiers;

/* 
 id |  numtiers  | nomtiers | adrtiers 
----+------------+----------+----------
  4 | CLT0000100 | Richard  | Vitre
  5 | CLT0000101 | Clement  | Thorigne
(2 rows)

 id |  numtiers  |  nomtiers   | adrtiers 
----+------------+-------------+----------
  1 | CLT0124    | Jean-Claude | Clisson
  2 | CLT0125    | Jean-Pierre | Nantes
  3 | CLT0126    | Quentin     | Rennes
  4 | CLT0000100 | Richard     | Vitre
  5 | CLT0000101 | Clement     | Thorigne
(5 rows)
*/

-- verser le contenu de tiers vers client
update tiers
    set numtiers = 'CLT0127'
    where id = 4;

update tiers
    set numtiers = 'CLT0128'
    where id = 5;

insert into client

select * from only tiers;

-- supprimer tous les enregistrements de tiers
delete from only tiers;

---- TP : creation de la table fournisseur

----- CORRECTION
create sequence numero_fournisseur_seq start 42;

create table fournisseur () inherits(tiers);
alter table fournisseur;

alter numtiers set default numeroter('FRS', 'numero_fournisseur_seq');

alter table fournisseur
    add check (left(numTiers, 3) = 'FRS');

alter table fournisseur
    add unique (numTiers);

Insert into fournisseur (nomTiers, adrTiers)
values ('Carrefour', 'Rennes'),
       ('Intermarche', 'Bruz'),
       ('Super U', 'Liffre'),
       ('Leclerc', 'Saint-Gregoire');

select *
from fournisseur;
select *
from tiers;

create sequence numero_vente_seq start 1000;
create table vente
(
) inherits(commande);
alter table vente
alter numcommande set default numeroter('VTE', 'numero_vente_seq');
alter table vente
    add check (left(numcommande, 3) = 'VTE');
alter table vente
    add unique (numCommande);
alter table vente
alter typeCommande set default 'VTE';
alter table client
    add primary key (id);
alter table vente
    add foreign key (tiers_id) references client (id);
alter table vente
    drop constraint vente_numcommande_check;

Insert into vente (tiers_id, dateCommande)
values (6, '2018-03-21'),
       (7, '2018-05-23');

-- verser le contenu de la table commande dans vente
insert into vente
select *
from only commande;

-- supprimer la contrainte sur numCommande dans la table vente
-- \d vente   /* pour voir le schema */
-- alter table vente drop constraint vente_numcommande_check;

-- creation de la table appro heritant de la table commande
create sequence numero_appro_seq start 1000;
create table appro
(
) inherits(commande);
alter table appro
alter numcommande set default numeroter('APP', 'numero_vente_seq');
alter table appro
    add check (left(numcommande, 3) = 'APP');
alter table appro
    add unique (numCommande);
alter table appro
alter typeCommande set default 'APP';
alter table fournisseur
    add primary key (id);
alter table appro
    add foreign key (tiers_id) references fournisseur (id);
-- alter table appro drop constraint vente_numcommande_check;

Insert into appro (tiers_id, dateCommande)
values (9, '2018-03-21');


-- creation de la table ligneVente
create table ligneVente
(
) inherits(ligneCommande);
alter table vente
    add primary key (id);
alter table ligneVente
    add foreign key (commande_id) references vente (id);
alter table ligneVente
    add foreign key (article_id) references article (id);

insert into ligneVente
select *
from only ligneCommande;

-- 
create table ligneAppro
(
) inherits(ligneCommande);
alter table appro
    add primary key (id);
alter table ligneAppro
    add foreign key (commande_id) references appro (id);
alter table ligneAppro
    add foreign key (article_id) references article (id);

insert into ligneAppro
select *
from only ligneCommande;


------------ JOUR 2 ; 25/05/2018 09:00 -------------------------
-- suppression donnees tables meres
delete from only lignecommande;
delete from only commande;
delete from only tiers;

-- insertion donnees table ligneAppro
insert into ligneAppro (commande_id, article_id, quantite)
values (7, 1, 142588),
       (7, 2, 42587);

-- ajouter des article
insert into article (designation, prixUnit, prixRevient)
values ('Jus d''orange 1L', 3, 1),
       ('Cartable', 30, 10),
       ('Crayons x10', 3, 2),
       ('Regle', 1, 0.75),
       ('Frigo Samsung', 300, 100);

-- Convertion en ligne
-- CORRECTION EXERCICE
create or replace view v_stock as
with v1(code, article, prixRevient, appro, vente) as
         (select a.numArticle  as Code,
                 a.designation as Article,
                 a.prixRevient,
                 la.quantite   as appro,
                 0             as vente
          from article a,
               ligneAppro la
          where la.article_id = a.id
          UNION ALL
          select a.numArticle  as Code,
                 a.designation as Article,
                 a.prixRevient,
                 0             as appro,
                 lv.quantite   as vente
          from article a,
               ligneVente lv
          where lv.article_id = a.id)
select a.numArticle                                            as Code,
       a.designation                                           as Article,
       a.prixRevient,
       coalesce(sum(v1.appro), 0)                              as appro,
       coalesce(sum(v1.vente), 0)                              as vente,
       coalesce(sum(v1.appro - v1.vente), 0)                   as Stock,
       coalesce(sum((v1.appro - v1.vente) * a.prixRevient), 0) as valeur
from article a
         left join v1 on a.numArticle = v1.code
group by a.numArticle, a.designation, a.prixRevient
order by code;

/*
    code    |      article       | prixrevient |   appro   |  vente  |   stock   | valeur  
------------+--------------------+-------------+-----------+---------+-----------+---------
 ART0000500 | Vin Listel Gris 3L |         7.2 | 142588.00 | 1428.00 | 141160.00 | 1016352
 ART0000501 | Biere Castel 350mL |         1.5 |  42587.00 | 7045.00 |  35542.00 |   53313
 ART0000502 | Stylo Bic          |         0.5 |         0 | 9175.00 |  -9175.00 | -4587.5
 ART0000503 | Jus d'orange 1L    |           1 |         0 |       0 |         0 |       0
 ART0000504 | Cartable           |          10 |         0 |       0 |         0 |       0
 ART0000505 | Crayons x10        |           2 |         0 |       0 |         0 |       0
 ART0000506 | Regle              |        0.75 |         0 |       0 |         0 |       0
 ART0000507 | Frigo Samsung      |         100 |         0 |       0 |         0 |       0
(8 rows)
*/

--- autre exercice
with v1(annee, client_id, janv, fev, mars, autre) as
         (select extract(year from dateCommande) as annee,
                 lv.article_id,
                 lv.quantite                     as janv,
                 0                               as fev,
                 0                               as mars,
                 0                               as autre
          from vente v,
               ligneVente lv,
               article a
          where lv.commande_id = v.id
            and lv.article_id = a.id
            and extract(month from v.dateCommande) = 1

          UNION ALL

          select extract(year from dateCommande) as annee,
                 lv.article_id,
                 0                               as janv,
                 lv.quantite                     as fev,
                 0                               as mars,
                 0                               as autre
          from vente v,
               ligneVente lv,
               article a
          where lv.commande_id = v.id
            and lv.article_id = a.id
            and extract(month from v.dateCommande) = 2

          UNION ALL

          select extract(year from dateCommande) as annee,
                 lv.article_id,
                 0                               as janv,
                 0                               as fev,
                 lv.quantite                     as mars,
                 0                               as autre
          from vente v,
               ligneVente lv,
               article a
          where lv.commande_id = v.id
            and lv.article_id = a.id
            and extract(month from v.dateCommande) = 3)

select v1.annee                                   as Annee,
       c.numTiers                                 as Code,
       c.nomTiers                                 as Client,
       sum(v1.janv)                               as Janv,
       sum(v1.fev)                                as Fev,
       sum(v1.mars)                               as Mars,
       sum(v1.autre)                              as Autre,
       sum(v1.janv + v1.fev + v1.mars + v1.autre) as Total
from client c
         left join v1 on v1.client_id = c.id
group by v1.annee, code, client;


select extract(year from dateCommande) as annee,
       v.tiers_id                      as client_id,
       0                               as janv,
       0                               as fev,
       0                               as mars,
       lv.quantite * a.prixUnit        as autre
from vente v,
     ligneVente lv,
     article a
where lv.commande_id = v.id
  and lv.article_id = a.id
  and extract(month from v.dateCommande) > 3 )

/*
 annee |  code   |   client    |  janv   |   fev   |  mars   | autre |  total  
-------+---------+-------------+---------+---------+---------+-------+---------
       | CLT0128 | Clement     |         |         |         |       |        
  2017 | CLT0125 | Jean-Pierre | 2458.00 |       0 | 4587.00 |     0 | 7045.00
  2017 | CLT0126 | Quentin     |       0 | 4587.00 |       0 |     0 | 4587.00
  2017 | CLT0124 | Jean-Claude | 1428.00 |       0 |       0 |     0 | 1428.00
       | CLT0127 | Richard     |         |         |         |       |        
(5 rows)
*/

-- Creation d'une rule
create table article_log
(
    article_id    int,
    numArticle    varchar(20),
    designation   varchar(250),
    ancienPrix    decimal(10, 2),
    nouveauPrix   decimal(10, 2),
    operateur     varchar(100),
    dateOperation timestamp
);


create or replace rule modifPrixUnitaire
    as on
update to article
where old.prixUnit <> new.prixUnit
    do
insert into article_log
values (old.id, old.numArticle, old.designation, old.prixUnit, new.prixUnit, current_user, now());

update article
set prixUnit=20.50
where id = 3;
--create user paul 'paul'
select *
from article_log;

-- schema : pour donner acces a toutes les tables incluses dans le schema
-- \dn   list of schema
-- \d    pour voir que fournisseur n'est plus la, mais dans depot
create schema depot;

-- deplacer la table fournisseur vers le schema depot
alter table fournisseur
    set schema depot;

-- switch to depot
set search_path to depot;

--- \d donne uniquement la table fournisseur
-- retour au rep public
set search_path to public;

-- affiche schema en cours
show search_path;

-- donner un droit d'usage au schema depot pour paul
grant usage on schema depot to paul;

-- donner un droit d'usage de toutes les sequences 
-- du schema depot a paul
grant usage on all sequences in schema depot to paul;


-- DUMPING
$ pg_dump -U postgres poecjava > /path/to/backup_poecjava.pgsql

-- RESTORING
$ ???

-- creer des utilisateurs
-- commande externe vs commande interne (dans le serveur)
-- creer user
create user marie password 'marie';
-- vs --
$ CreateUser -U postgre marie -P

-- SuperUser, createDB, createRole 
create user admin [ SuperUser | createDB | createRole ] password 'admin';

-- vs --
$ CreateUser -U postgres -s marie       -- s=superuser

-- Les options:
$ CreateUser -U postgres [OPTION] username
    -s    SuperUser
    -d    databases, peut modif db
    -r    role, peut creer des roles
    -P    invite password
    -e    echo, affiche la commande sql
    -interactive
          interaction
    /?    help


-- exemples
-- creation d'un admin
create user admin superuser password 'admin';

----- gestion utilisateur
-- creation de la bdd poec2018
-- createDB
$ createDB -U admin poecjava

-- creation d'un utilisateur de meme nom que la bdd poec2018
$ createUser -U admin -P poec2018 

-- se connecter a la base de donnees poec2018
$ psql -U poec2018 poec2018
ou 
$ psql -U poec2018 

---- on est dans la bdd poec2018 a partir d'ici
-- creer les differentes tables
-- donner les droits aux differents utilisateurs
grant select on article to user1;

grant usage on sequence numero_article_seq to user1;
grant usage on all sequences in schema public to user1;
grant usage on schema depot to user1;

-- supprimer un utilisateur
drop user user2;

-- revoke permission

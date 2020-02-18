/* * * * * * * * * * * * * * *
 *                           *
 *   COURS BDD IMIE          *
 *   semaine du 22/05/2018   *
 *   JP Boto                 *
 *                           *
 * * * * * * * * * * * * * * */


-- Create new tables
CREATE TABLE a
(
    id     int,
    valeur char(2)
);
insert into a
values (1, 'a'),
       (2, 'b'),
       (3, 'c'),
       (4, 'd');

CREATE TABLE b
(
    id     int,
    valeur CHAR(2)
);
INSERT INTO b
values (3, 'x'),
       (2, 'y'),
       (7, 'z'),
       (8, 'w');

-- CROSS JOIN
SELECT *
FROM a,
     b;
SELECT *
FROM a
         CROSS JOIN b;

/*
+------+--------+------+--------+
| id   | valeur | id   | valeur |
+------+--------+------+--------+
|    1 | a      |    3 | x      |
|    2 | b      |    3 | x      |
|    3 | c      |    3 | x      |
|    4 | d      |    3 | x      |
|    1 | a      |    2 | y      |
|    2 | b      |    2 | y      |
|    3 | c      |    2 | y      |
|    4 | d      |    2 | y      |
|    1 | a      |    7 | z      |
|    2 | b      |    7 | z      |
|    3 | c      |    7 | z      |
|    4 | d      |    7 | z      |
|    1 | a      |    8 | w      |
|    2 | b      |    8 | w      |
|    3 | c      |    8 | w      |
|    4 | d      |    8 | w      |
+------+--------+------+--------+
*/

-- INNER JOIN
SELECT *
FROM a
         INNER JOIN b ON a.id = b.id;

/*
+------+--------+------+--------+
| id   | valeur | id   | valeur |
+------+--------+------+--------+
|    3 | c      |    3 | x      |
|    2 | b      |    2 | y      |
+------+--------+------+--------+
*/

-- LEFT JOIN
SELECT *
FROM a
         LEFT JOIN b ON a.id = b.id;

/*
+------+--------+------+--------+
| id   | valeur | id   | valeur |
+------+--------+------+--------+
|    3 | c      |    3 | x      |
|    2 | b      |    2 | y      |
|    1 | a      | NULL | NULL   |
|    4 | d      | NULL | NULL   |
+------+--------+------+--------+
*/

-- Pour se debarrasser des NULL, on utilise COALESCE
-- COALESCE returns the first non-null expression amongst its arguments
SELECT a.*,
       COALESCE(b.id, 0)                           as b_id,
       COALESCE(b.valeur, 'Pas de correspondance') as b_valeur
FROM a
         LEFT JOIN b on a.id = b.id;

/*
+------+--------+------+-----------------------+
| id   | valeur | b_id | b_valeur              |
+------+--------+------+-----------------------+
|    3 | c      |    3 | x                     |
|    2 | b      |    2 | y                     |
|    1 | a      |    0 | Pas de correspondance |
|    4 | d      |    0 | Pas de correspondance |
+------+--------+------+-----------------------+
*/

-- RIGHT JOIN
SELECT a.id, a.valeur, b.*
FROM a
         RIGHT JOIN b ON a.id = b.id;

/*
+------+--------+------+--------+
| id   | valeur | id   | valeur |
+------+--------+------+--------+
|    2 | b      |    2 | y      |
|    3 | c      |    3 | x      |
| NULL | NULL   |    7 | z      |
| NULL | NULL   |    8 | w      |
+------+--------+------+--------+
*/

-- RIGHT JOIN sans les null
SELECT COALESCE(a.id, 0)                           as a_id,
       COALESCE(a.valeur, 'Pas de correspondance') as a_valeur,
       b.*
FROM a
         RIGHT JOIN b ON a.id = b.id;

/*
+------+-----------------------+------+--------+
| a_id | a_valeur              | id   | valeur |
+------+-----------------------+------+--------+
|    2 | b                     |    2 | y      |
|    3 | c                     |    3 | x      |
|    0 | Pas de correspondance |    7 | z      |
|    0 | Pas de correspondance |    8 | w      |
+------+-----------------------+------+--------+
*/

-- FULL JOIN   *** N EXISTE PAS EN MYSQL ***
SELECT *
FROM a
         FULL JOIN b ON a.id = b.id;

-- on va essayer de faire un FULL JOIN a la main
CREATE OR REPLACE VIEW id_ab AS
SELECT id
from a
UNION
SELECT id
from b;

/*
+------+
| id   |
+------+
|    1 |
|    2 |
|    3 |
|    4 |
|    7 |
|    8 |
+------+ */

SELECT *
FROM id_ab
         LEFT JOIN a on id_ab = a.id
         LEFT JOIN b on id_ab = b.id;

/*
+------+------+--------+------+--------+
| id   | id   | valeur | id   | valeur |
+------+------+--------+------+--------+
|    3 |    3 | c      |    3 | x      |
|    2 |    2 | b      |    2 | y      |
|    7 | NULL | NULL   |    7 | z      |
|    8 | NULL | NULL   |    8 | w      |
|    1 |    1 | a      | NULL | NULL   |
|    4 |    4 | d      | NULL | NULL   |
+------+------+--------+------+--------+
*/

---- PART2 : 2018-05-22 11:00
-- TRANSACTION
-- ROLLBACK = annulation
BEGIN
    ;
    INSERT INTO a VALUES (6, 'f');
    UPDATE a SET valeur = 'aa' WHERE id = 1;
    ROLLBACK;

    -- SAVEPOINT + ROLLBACK TO
-- voir cours --
    BEGIN
        ;
        SAVEPOINT mySave;
        INSERT INTO a VALUES (6, 'f');
        UPDATE a SET valeur = 'aa' WHERE id = 1;
        ROLLBACK TO mySave;
        COMMIT;


        -- INDEX
-- Permet d'accelerer la recherche
-- Exemple: un index sur la table clients sur numeroClient
        CREATE INDEX idx_numero_client ON client (numeroClient);
        SHOW INDEX FROM client;

        /*
        +--------+------------+-------------------+--------------+--------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
        | Table  | Non_unique | Key_name          | Seq_in_index | Column_name  | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
        +--------+------------+-------------------+--------------+--------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
        | client |          0 | PRIMARY           |            1 | id           | A         |           2 |     NULL | NULL   |      | BTREE      |         |               |
        | client |          0 | numeroClient      |            1 | numeroClient | A         |           2 |     NULL | NULL   |      | BTREE      |         |               |
        | client |          1 | idx_numero_client |            1 | numeroClient | A         |           2 |     NULL | NULL   |      | BTREE      |         |               |
        +--------+------------+-------------------+--------------+--------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
        */

-- Sauvegarde de BDD
-- mysqldump -u root poecjava > /path/to/backup/bkup.sql
        $ sudo mysqldump -u root poecjava > dump_poecjava.sql

-- Restauration
-- 1. Creer la base destinataire
        CREATE DATABASE copie_poecjava;
-- 2. Lancer la restauration
        $ sudo mysql -u root copie_poecjava < dump_poecjava.sql


---- Gestion d'user
-- creation
        create user marie@localhost identified by '1234';

-- donner droit 
        grant SELECT (numeroClient, adresseClient) ON poecjava.client TO marie@localhost;
        grant SELECT on poecjava.* to norbert@localhost identified by '1234';

-- creer un admin
        grant all privileges on *.* to admin@localhost identified by 'admin';

-- changer le mdp de marie
        set password for marie@localhost= password ('4321');

-- afficher les users existants
        select user, host, password from mysql.user;

-- afficher les droits de marie
        show grants for marie@localhost;


        ---- EXOS ----
-- creation utilisateurs
        CREATE USER admin@localhost identified by 'admin'
        CREATE USER info@localhost identified by 'info';
        CREATE USER claude@localhost identified by 'direction1';
        CREATE USER paul@localhost identified by 'direction2';
        CREATE USER marie@localhost identified by 'caissemarie';
        CREATE USER georges@localhost identified by 'caissegeorges';

-- privileges
        GRANT ALL PRIVILEGES ON *.* TO admin@localhost IDENTIFIED BY 'admin';
        GRANT ALL PRIVILEGES ON poecjava.* TO info@localhost IDENTIFIED BY 'sysman';

        GRANT SELECT ON poecjava.v_commande TO claude@localhost, paul@localhost;
        GRANT SELECT ON poecjava.v_qteMois TO claude@localhost, paul@localhost;
        GRANT SELECT ON poecjava.v_stat TO claude@localhost, paul@localhost;

        GRANT SELECT ON poecjava.article TO marie@localhost, georges@localhost;
        GRANT SELECT ON poecjava.client TO marie@localhost, georges@localhost;

        GRANT sELECT, INSERT, UPDATE ON poecjava.commande TO marie@localhost, georges@localhost;
        GRANT SELECT, INSERT, UPDATE ON poecjava.ligneCommande TO marie@localhost, georges@localhost;


-- mettre mdp a root
        SET PASSWORD FOR root@localhost= password ('1234');


        -------------- CORRECTION
-- METHODE 2 : creation de groupes d'utilisateur
-- CREATION de groupe (possible avec MariaDB mais pas avec MySQL)
        CREATE ROLE informatique;
        CREATE ROLE direction;
        CREATE ROLE caisse;

        GRANT ALL PRIVILEGES ON poecjava.* TO informatique;
        GRANT informatique TO info@localhost IDENTIFIED BY 'info'

-- donner les droits au groupe 'direction'
        GRANT SELECT ON poecjava.v_commande TO direction;
        GRANT SELECT ON poecjava.v_qteMois TO direction;
        GRANT SELECT ON poecjava.v_stat TO direction;

-- Rattacher Paul (paul n'existe pas encore)
        GRANT direction TO paul@localhost identified by 'paul1234';

-- Activer role pour l'utilisateur en cours (?)
        SET ROLE direction;

-- Enlever le role en cours
        SET ROLE none;

-- Afficher l'user et le role en cours
        SELECT current_user(), current_role();

-- Enlever le droit
        REVOKE SELECT ON poecjava.article FROM marie@localhost;
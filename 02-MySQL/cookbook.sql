/* * * * * * * * * * * * * * * * 
 *                             *
 *   Formation Java J2E        *
 *   IMIE Avril-Juillet 2018   *
 *                             *
 *   COOKBOOK MySQL            *           
 *                             *
 * * * * * * * * * * * * * * * */

/*    INSTALLATION MySQL - LINUX
 *    $ sudo apt-get install mysql-server
 *
 *    REDEMARRER mysql
 *    $ sudo /etc/init.d/mysql [ OPTION ]
 *    OPTIONS : start | restart | stop | reload
 *
 *    DEMARRER UNE SESSION : start server + start mysql session
 *    $ mysqld
 *    $ sudo mysql -u root [-p --password=] [[-D] dbName] 
 *    $ sudo mysql --user=root [--database=dbname] 
 *
 *    AIDE COMPLETE
 *    $ mysql --verbose --help
 *
 *    REDIRECTION
 *    $ mysql -u root <dbname> < script.sql
 *
 *    DUMPING
 *    $ ???
 */


-- afficher les bdd dispo sur le serveur */
SHOW DATABASES;


-- ouvrir connection vers bdd dbname
USE <dbName>;

CONNECT <dbName>;


-- afficher les tables dispo dans bdd connectee 
SHOW TABLES;


-- afficher bdd currently in use
SELECT DATABASE ();


-- executer <fname> dans mysql -- equiv a une redirection
SOURCE <fname>;


-- afficher le nom des index de la table tblname
SHOW INDEX FROM <tblname>

-- ouvrir un flux vers fname, puis fermer
TEE <fname>                  /* ouvrir un flux vers fname qui va enregister tout ce qui sera tape ensuite */
foo bar baz;
goo zoo boo;
NOTEE
/* ferme le flux */


/* Exemple:
	*** Console input ***
	MariaDB [poecjava]> tee findme1205.sql
	Logging to file 'findme1205.sql'
	MariaDB [poecjava]> select * from v_commande;
	+----------------+---------------------+-----------+---------------+
	| numeroCommande | dateCommande        | nomClient | adresseClient |
	+----------------+---------------------+-----------+---------------+
	| CDE201700125   | 2017-01-20 00:00:00 | René      | Rennes        |
	| CDE201700130   | 2017-02-10 00:00:00 | Claude    | Clisson       |
	| CDE201700315   | 2017-03-05 00:00:00 | René      | Rennes        |
	| CDE201700745   | 2017-04-29 00:00:00 | Claude    | Clisson       |
	+----------------+---------------------+-----------+---------------+
	4 rows in set (0.18 sec)

	MariaDB [poecjava]> notee
	Outfile disabled. 

	*** Contenu du log ***
	MariaDB [poecjava]> select * from v_commande;
	+----------------+---------------------+-----------+---------------+
	| numeroCommande | dateCommande        | nomClient | adresseClient |
	+----------------+---------------------+-----------+---------------+
	| CDE201700125   | 2017-01-20 00:00:00 | Ren‚      | Rennes        |
	| CDE201700130   | 2017-02-10 00:00:00 | Claude    | Clisson       |
	| CDE201700315   | 2017-03-05 00:00:00 | Ren‚      | Rennes        |
	| CDE201700745   | 2017-04-29 00:00:00 | Claude    | Clisson       |
	+----------------+---------------------+-----------+---------------+
	4 rows in set (0.18 sec)

	MariaDB [poecjava]> notee
	*/

-- exporter le resultat de la requete vers fichier indique
SELECT *
INTO OUTFILE '/path/to/fname'
FROM <tblname>;

/* Note: default file path: dbname folder (e.g. C:\xampp\mysql\data\poecjava)
 *
 * Exemple:
 *    SELECT nomClient INTO OUTFILE 'findme1441.sql' FROM client;
 *
 * *** output ***
 * Ren�
 * Claude
 */

-- afficher la structure de la table
DESC nom_table;

/* Exemple: DESC poecjava.client;
  	+---------------+--------------+------+-----+---------+----------------+
	| Field         | Type         | Null | Key | Default | Extra          |
	+---------------+--------------+------+-----+---------+----------------+
	| id            | int(11)      | NO   | PRI | NULL    | auto_increment |
	| numeroClient  | varchar(20)  | NO   | UNI | NULL    |                |
	| nomClient     | varchar(250) | YES  |     | NULL    |                |
	| adresseClient | varchar(250) | YES  |     | NULL    |                |
	+---------------+--------------+------+-----+---------+----------------+
*/

-- LDD : Langage de DEFINITION des Donnees = CREATE, ALTER, TRUNCATE, DROP, RENAME
-- LMD : Langage de MANIPULATION des Donnees = SELECT, INSERT, UPDATE, DELETE
-- LCD : Langage de CONTROLE des Donnees = GRANT, REVOKE

-- Creer une database et s'y connecter
CREATE DATABASE nom_bdd;
USE nom_bdd;


-- Creer une table
CREATE TABLE IF NOT EXISTS clients
(
    id
    INTEGER
    AUTO_INCREMENT
    PRIMARY
    KEY,
    nomClient
    VARCHAR
(
    80
),
    adresseClient VARCHAR
(
    150
)
    );

/* Les options:
 * IF NOT EXISTS
 * CREATE OR REPLACE TABLE   (*** check this one ***)
 * AUTO_INCREMENT     incrementation auto a chaque insertion
 * PRIMARY KEY        designe la cle primaire, c-a-d un identifiant unique
 */


-- FOREIGN KEYS
-- Exemple
CREATE TABLE commandes
(
    id           INTEGER AUTO_INCREMENT PRIMARY KEY,
    client_id    INTEGER,
    FOREIGN KEY (client_id) REFERENCES clients (id),
    dateCommande date
);

CREATE TABLE nomTable
(
    a INTEGER PRIMARY KEY,
    b INTEGER,
    c INTEGER,
    FOREIGN KEY (b, c) REFERENCES autreTable (c1, c2)
);

CREATE TABLE IF NOT EXISTS commandes_produits
(
    no_produit
    INTEGER
    REFERENCES
    produits
    ON
    DELETE
    RESTRICT,
    id_commande
    INTEGER
    REFERENCES
    commandes
    ON
    DELETE
    CASCADE,
    quantite
    INTEGER,
    PRIMARY
    KEY
(
    no_produit,
    id_commande
)
    );

/* Les options:
 * RESTRICT      empêche la suppression d'une ligne référencée
 * CASCADE       lors de la suppression d'une ligne référencée, les lignes la référant sont aussi supprimées
 */

cf demo aussi

-- DROP TABLE : Supprimer une table
DROP TABLE [ IF EXISTS ] nomTable;

-- INSERT INTO : Remplir une table
--> Syntaxe :
INSERT [ OR REPLACE | OR IGNORE ]
    INTO nomTable (nomCol1, nomCol2, ...)
VALUES
    (value1Col1, value2Col2),
    (value3Col1, value4Col2);

--> Exemple :
INSERT INTO clients (nomClient, adresseClient)
VALUES ('Joe', 'Saint-Nazaire'),
       ('Richard', 'Angers');

--> Insertion with Nested SELECT
INSERT INTO clients (nomClient, adresseClient)
VALUES
        (SELECT nom, adresse FROM fournisseurs);

-- DELETE or TRUNCATE : Supprimer des entrées / Vider une table
DELETE
FROM nomTable; /* ATTENTION ! SUPPRIME TOUTES LES ENTREES */
DELETE
FROM clients
WHERE adresseClient = 'Saint-Nazaire';
TRUNCATE TABLE client [ WHERE ... ];

-- JOIN : Tables jointes
--> Set up
CREATE TABLE IF NOT EXISTS t1
(
    num
    INTEGER
    AUTO_INCREMENT
    PRIMARY
    KEY,
    nom
    VARCHAR
(
    20
));
CREATE TABLE IF NOT EXISTS t2
(
    num
    INTEGER
    PRIMARY
    KEY,
    valeur
    VARCHAR
(
    20
));
INSERT INTO t1 (nom)
VALUES ('a'),
       ('b'),
       ('c');
INSERT INTO t2(num, valeur)
VALUES (1, 'xxx'),
       (3, 'yyy'),
       (5, 'zzz');
SELECT *
FROM t1;
SELECT *
FROM t2;

/*    t1              t2
+-----+------+  +-----+--------+
| num | nom  |  | num | valeur |
+-----+------+  +-----+--------+
|   1 | a    |  |   1 | xxx    |
|   2 | b    |  |   3 | yyy    |
|   3 | c    |  |   5 | zzz    |
+-----+------+  +-----+--------+ */


--> CROSS JOIN
SELECT *
FROM t1,
     t2; /* Methode 1 */
SELECT *
FROM t1
         CROSS JOIN t2;
/* Methode 2 */

/*  +-----+------+-----+--------+
	| num | nom  | num | valeur |
	+-----+------+-----+--------+
	|   1 | a    |   1 | xxx    |
	|   2 | b    |   1 | xxx    |
	|   3 | c    |   1 | xxx    |
	|   1 | a    |   3 | yyy    |
	|   2 | b    |   3 | yyy    |
	|   3 | c    |   3 | yyy    |
	|   1 | a    |   5 | zzz    |
	|   2 | b    |   5 | zzz    |
	|   3 | c    |   5 | zzz    |
	+-----+------+-----+--------+ */


--> NATURAL JOIN
SELECT *
FROM t1 NATURAL
         JOIN t2;

/*  +-----+------+--------+
	| num | nom  | valeur |
	+-----+------+--------+
	|   1 | a    | xxx    |
	|   3 | c    | yyy    |
	+-----+------+--------+ */


--> INNER JOIN
SELECT *
FROM t1,
     t2
WHERE t1.num = t2.num;
SELECT *
FROM t1
         INNER JOIN t2 ON t1.num = t2.num;

/*  +-----+------+-----+--------+
	| num | nom  | num | valeur |
	+-----+------+-----+--------+
	|   1 | a    |   1 | xxx    |
	|   3 | c    |   3 | yyy    |
	+-----+------+-----+--------+ */


--> LEFT JOIN
SELECT *
FROM t1
         LEFT JOIN t2 ON t1.num = t2.num;

/* 	+-----+------+------+--------+
	| num | nom  | num  | valeur |
	+-----+------+------+--------+
	|   1 | a    |    1 | xxx    |
	|   2 | b    | NULL | NULL   |
	|   3 | c    |    3 | yyy    |
	+-----+------+------+--------+ */


--> RIGHT JOIN
SELECT *
FROM t1
         RIGHT JOIN t2 ON t1.num = t2.num;

/*  +------+------+-----+--------+
	| num  | nom  | num | valeur |
	+------+------+-----+--------+
	|    1 | a    |   1 | xxx    |
	|    3 | c    |   3 | yyy    |
	| NULL | NULL |   5 | zzz    |
	+------+------+-----+--------+ */


-- TRANSACTIONS
-- Une transaction assemble plusieurs etapes en une seule etape tout-ou-rien

--> BEGIN; ...; COMMIT;
BEGIN
    ;
    UPDATE comptes
    SET balance = balance - 100.00
    WHERE nom = 'Alice';
    UPDATE branches
    SET balance = balance - 100.00
    WHERE nom = (SELECT nom_branche FROM comptes WHERE nom = 'Alice');

    UPDATE comptes
    SET balance = balance + 100.00
    WHERE nom = 'Bob';
    UPDATE branches
    SET balance = balance + 100.00
    WHERE nom = (SELECT nom_branche FROM comptes WHERE nom = 'Bob');
    COMMIT;

    --> SAVEPOINT + ROLLBACK
-- Retour a un etat donne sauvegarde avec SAVEPOINT
    BEGIN
        ;
        UPDATE comptes
        SET balance = balance - 100.00
        WHERE nom = 'Alice';

        SAVEPOINT mySavePoint;

        UPDATE comptes
        SET balance = balance + 100.00
        WHERE nom = 'Bob';

        /* ANNULATION */
        ROLLBACK TO mySavePoint;

        /* Go again */
        UPDATE comptes
        SET balance = balance + 100.00
        WHERE nom = 'Wally';

        COMMIT;

        -- VUES
--> Creer une vue: CREATE VIEW
        CREATE OR REPLACE VIEW nomVue AS <instructions>;
        CREATE VIEW IF NOT EXISTS nomVue AS <instructions>;
        CREATE OR IGNORE VIEW nomVue AS <instructions>;

/* Les options:
 * OR REPLACE
 * OR IGNORE
 * IF NOT EXISTS
 */

--> Supprimer une vue: DROP VIEW
        DROP VIEW IF EXISTS nomVue;


        -- EXPRESSIONS CONDITIONNELLES
--> CASE
                CASE
                WHEN <condition> THEN <action>          /* pas de virgule entre les when */
  [ WHEN ... THEN ... ]
  [ ELSE ... ]
    END;

-- exemples
    CREATE TABLE IF NOT EXISTS test
    (
        a int
    );
    INSERT INTO test (a) VALUES (1), (2), (3);

    SELECT a,
           CASE
               WHEN a = 1 THEN 'un'
               WHEN a = 2 THEN 'deux'
               WHEN a = 3 THEN 'trois'
               END as full_letters
    FROM test;

    /* OUTPUT HERE ? */

--> COALESCE
-- returns the first non-NULL expression among its arguments.
    COALESCE ("expression 1", "expressions 2", ...)

-- It is the same as the following CASE statement:
    SELECT CASE ("column_name")
               WHEN "expression 1 is not NULL" THEN "expression 1"
               WHEN "expression 2 is not NULL" THEN "expression 2"
                   ...
                   [ELSE "NULL"]
               END
    FROM "table_name";

    -- Exemple
/* Table Contact_Info
+-------+----------------+------------+------------+
| Name  | Business_Phone | Cell_Phone | Home_Phone |
+-------+----------------+------------+------------+
| Jeff  | 531-2531       | 622-7813   | 565-9901   |
| Laura | NULL           | 772-5588   | 312-4088   |
| Peter | NULL           | NULL       | 594-7477   |
+-------+----------------+------------+------------+ */

    CREATE TABLE IF NOT EXISTS Contact_Info
    (
        Name VARCHAR
    (
        20
    ),
        Business_Phone VARCHAR
    (
        50
    ),
        Cell_Phone VARCHAR
    (
        50
    ),
        Home_Phone VARCHAR
    (
        50
    )
        );
    INSERT INTO Contact_Info
    VALUES ("Jeff", "531-2531", "622-7813", "565-9901"),
           ("Laura", Null, "772-5588", "312-4088"),
           ("Peter", Null, Null, "594-7477");

/* ...and we want to find out the best way to contact each person according to the 
 * following rules:
 *    1. If a person has a business phone, use the business phone number.
 *    2. If a person does not have a business phone and has a cell phone, 
         use the cell phone number.
 *    3. If a person does not have a business phone, does not have a cell phone, 
         and has a home phone, use the home phone number.
 *
 * We can use the COALESCE function to achieve our goal: */
    SELECT Name,
           COALESCE(Business_Phone, Cell_Phone, Home_Phone) Contact_Phone
    FROM Contact_Info;

    /* OUTPUT COALESCE
    +-------+---------------+
    | Name  | Contact_Phone |
    +-------+---------------+
    | Jeff  | 531-2531      |
    | Laura | 772-5588      |
    | Peter | 594-7477      |
    +-------+---------------+ */


--> NULLIF
-- La fonction NULLIF renvoie une valeur NULL si valeur1 et valeur2 sont égales, 
-- sinon il renvoie valeur1.	
    NULLIF (valeur1, valeur2);


    --> GREATEST et LEAST
-- Plus grand que / Plus petit que
-- Les fonctions GREATEST et LEAST selectionnent respectivement la valeur la plus grande et
-- la valeur la plus petite à partir d'une liste d'un certain nombre d'expressions
    GREATEST (valeur [, ...]);
    LEAST (valeur [, ...]);


    --> GROUP BY et HAVING
-- GROUP BY permet de grouper les lignes d'enregistrement HAVING spécifie une condition à 
-- vérifier sur les lignes groupées
    SELECT ville, max(t_basse)
    FROM temps
    GROUP BY ville;

/*	+---------------+-----+
	| ville         | max |
	+---------------+-----+
	| Hayward       |  37 | 
	| San Francisco |  46 |
	+---------------+-----+ */

    SELECT ville, max(t_basse)
    FROM temps
    GROUP BY ville
    HAVING max(t_basse) < 40;

    /* => GROUP BY ville HAVING max low temps < 40
        +---------------+-----+
        | ville         | max |
        +---------------+-----+
        | Hayward       |  37 |
        +---------------+-----+ */


/* COMBINER DES REQUETES
 *    Les résultats de deux requêtes peuvent être combinés en utilisant les opérations
 *    d'ensemble: union, intersection et différence.
 *
 * Syntaxe:
 *    requete1 UNION [ ALL ] requete2
 *	  requete1 INTERSECT [ ALL ] requete2
 *	  requete1 EXCEPT [ ALL ] requete2
 */

--> UNION 
-- UNION elimine les lignes dupliquées du résultat, de la même façon que DISTINCT, 
-- sauf si UNION ALL est utilisée. 


--> INTERSECT
-- INTERSECT renvoie toutes les lignes qui sont à la fois dans le résultat de requete1 ET
-- dans le résultat de requete2. Les lignes dupliquées sont éliminées sauf si INTERSECT ALL -- est utilisée.


--> EXCEPT
-- EXCEPT renvoie toutes les lignes qui sont dans le résultat de requete1 mais pas dans le
-- résultat de requete2 (difference entre 2 requêtes). De nouveau, les lignes dupliquées 
-- sont éliminées sauf si EXCEPT ALL est utilisée.


--> CREATION INDEX
-- L'utilisation d'un index simplifie et accélère les opérations de recherche, de tri, de
-- jointure ou d'agrégation effectuées par le SGBD.

-- Syntaxe:
    CREATE INDEX nomIndex
        ON nomTable (col1 [, col2] [, ...]);

    Exemple:
-- Créer un index sur la colonne titre dans la table films
    CREATE INDEX title_idx
        ON films (title);

-- Supprimer un index créé:
    ALTER TABLE nomTable
        DROP INDEX nomIndex;


    --> AJOUTER UNE CONTRAINTE

-- Pour ajouter une contrainte, la syntaxe de contrainte de table est utilisée
    ALTER TABLE produits
        ADD CONSTRAINT nom_contrainte_unique
            UNIQUE (no_produit);

    ALTER TABLE produits
        ADD CONSTRAINT nom_contrainte_foreign_key
            FOREIGN KEY (id_group_produits) REFERENCES groupe_produits;

-- Pour enlever respectivement les contraintes:
    ALTER TABLE produits
        DROP INDEX nom_contrainte_unique;
    ALTER TABLE produits
        DROP FOREIGN KEY nom_contrainte_foreign_key;

-- Pour ajouter une contrainte NOT NULL, qui ne peut pas être écrite sous forme d'une contrainte de table:
    ALTER TABLE produits
        MODIFY no_produit VARCHAR (20) NOT NULL;

-- Pour enlever cette même contrainte NOT NULL:
    ALTER TABLE produit
        MODIFY no_produit VARCHAR (20) NULL;

    La contrainte étant immédiatement vérifiée, les données de la table doivent satisfaire la contrainte avant qu'elle ne soit ajoutée.


--> SUPPRIMER UNE CONTRAINTE
La suppression se fait par son si elle a été explicitement nommée. 
Dans le cas contraire, le système engendre et attribue un nom qu'il faut découvrir à partir de la commande SHOW
    CREATE TABLE <nomTable>

    Syntaxe:
    ALTER TABLE nomTable
        DROP FOREIGN KEY nomContrainte;

    Exemple:
    ALTER TABLE commande
        DROP FOREIGN KEY commande_fki_client_id;


    MODIFIER LA VALEUR PAR DEFAUT D'UNE COLONNE
-- Ajouter une valeur par defaut
Syntaxe:
	ALTER TABLE nomTable
		ALTER COLUMN nomColonne
		SET DEFAULT valeur;

Exemple:
	ALTER TABLE produits
		ALTER COLUMN prix SET DEFAULT 7.77;
		
-- Retirer toute valeur par defaut
Syntaxe:
	ALTER TABLE nomTable
		ALTER COLUMN nomColonne
		DROP DEFAULT;
		
Exemple:
	ALTER TABLE produits
		ALTER COLUMN prix DROP DEFAULT;
		
MODIFIER LE TYPE DE DONNEE D'UNE COLONNE
    Syntaxe:
    ALTER TABLE nomTable
        MODIFY nomColonne type1 [type2 ...];

    Exemples:
    ALTER TABLE produits MODIFY prixUnitaire NUMERIC (10,2);
    ALTER TABLE client MODIFY nom VARCHAR (150) NOT NULL;

    RENOMMER UNE COLONNE
    Syntaxe:
    ALTER TABLE nomTable
        CHANGE COLUMN nomColonne nouveauNomColonne < type >;

    Exemple:
    ALTER TABLE client
        CHANGE COLUMN nom nomClient VARCHAR (100);

    RENOMMER UNE TABLE:
    Syntaxe:
    ALTER TABLE nomTable
        RENAME TO nouveauNomTable;

    Exemple:
    ALTER TABLE produits
        RENAME TO articles;

    AFFICHER LA REQUETE DE CREATION D'UNE TABLE
Syntaxe:
	SHOW CREATE TABLE nomTable;
	
Exemple:
	SHOW CREATE TABLE article;
	
/* =>
+---------+------------------------------------------------------------+
| Table   | Create Table                                               |
+---------+------------------------------------------------------------+
| article | CREATE TABLE `article` (
			  `id` int(11) NOT NULL AUTO_INCREMENT,
			  `numeroArticle` varchar(20) NOT NULL,
			  `designation` varchar(250) DEFAULT NULL,
			  `prixUnitaire` decimal(10,2) DEFAULT NULL,
			  `prixRevient` decimal(10,2) DEFAULT NULL,
			  PRIMARY KEY (`id`),
			  UNIQUE KEY `numeroArticle` (`numeroArticle`)
			  ) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 |
+---------+-----------------------------------------------------------+
*/

AFFICHER LES CONTRAINTES A UNE TABLE
Syntaxe:
	SELECT * 
	FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
	WHERE TABLE_NAME = 'nomTable';
	
Exemple:
	SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
	WHERE TABLE_NAME = 'article';
/* =>
+--------------------+-------------------+-----------------+--------------+------------+-----------------+
| CONSTRAINT_CATALOG | CONSTRAINT_SCHEMA | CONSTRAINT_NAME | TABLE_SCHEMA | TABLE_NAME | CONSTRAINT_TYPE |
+--------------------+-------------------+-----------------+--------------+------------+-----------------+
| def                | poecjava          | PRIMARY         | poecjava     | article    | PRIMARY KEY     |
| def                | poecjava          | numeroArticle   | poecjava     | article    | UNIQUE          |
+--------------------+-------------------+-----------------+--------------+------------+-----------------+
*/






# Oracle Project Academique - Gestion Fablab

Ce depot contient un projet Oracle SQL de gestion de fablab / atelier academique.

Ce n'est pas une application web a lancer avec un serveur.  
La demonstration consiste a executer un schema Oracle, charger un jeu de donnees, puis lancer des requetes SQL qui montrent que le modele fonctionne.

## Contenu

- `schema_gestion_fablab_oracle.sql` : creation du schema relationnel
- `jeu_donnees_demo_oracle.sql` : insertion des donnees de demonstration
- `requetes_soutenance_oracle.sql` : 30 requetes SQL pour la soutenance
- `guide_requetes_soutenance.md` : guide oral pour expliquer les requetes
- `explication_ddl_gestion_fablab.md` : explication du schema et des choix DDL

## Prerequis

- Oracle Database 19c, 21c, ou Oracle Free
- Un client SQL comme SQL Developer, SQLcl, SQL*Plus, ou DBeaver
- Un utilisateur Oracle sur lequel vous pouvez creer les tables

## Execution rapide

### Option 1 : SQL Developer

1. Ouvrir une connexion vers votre base Oracle.
2. Executer [`schema_gestion_fablab_oracle.sql`](schema_gestion_fablab_oracle.sql).
3. Executer [`jeu_donnees_demo_oracle.sql`](jeu_donnees_demo_oracle.sql).
4. Ouvrir [`requetes_soutenance_oracle.sql`](requetes_soutenance_oracle.sql).
5. Lancer 8 a 12 requetes representatives pendant la demonstration.

### Option 2 : SQL*Plus / SQLcl

Exemple une fois connecte a Oracle :

```sql
@schema_gestion_fablab_oracle.sql
@jeu_donnees_demo_oracle.sql
@requetes_soutenance_oracle.sql
```

Si vous voulez lancer une seule requete a la fois, copiez-la depuis le fichier de requetes et executez-la dans votre console SQL.

## Ordre de demo recommande

L'ordre le plus efficace pour montrer que le projet fonctionne :

1. Creer le schema.
2. Charger les donnees.
3. Montrer quelques tables avec un `SELECT *`.
4. Executer des requetes simples.
5. Executer des jointures.
6. Executer des agregations.
7. Finir avec des sous-requetes et operateurs avances.

Le guide oral recommande deja un bon enchainement dans [`guide_requetes_soutenance.md`](guide_requetes_soutenance.md).

## Requetes a montrer en soutenance

Vous n'avez pas besoin de montrer les 30.

Sequence courte et convaincante :

1. Requete 01 : liste des membres
2. Requete 03 : machines disponibles
3. Requete 05 : reservations confirmees avec jointure
4. Requete 08 : nombre de membres par type
5. Requete 10 : participants par evenement
6. Requete 13 : membres sans reservation
7. Requete 16 : projet avec le plus de membres
8. Requete 30 : classification metier du stock avec `CASE`

## Ce que vous pouvez dire pendant la demo

- Le schema est reexecutable sans nettoyage manuel grace au bloc `DROP TABLE ... EXCEPTION ...`.
- Les cles primaires utilisent `GENERATED ALWAYS AS IDENTITY`.
- Le jeu de donnees couvre membres, machines, projets, evenements, reservations, maintenance et consommation.
- Les requetes ne sont pas decoratives : elles montrent consultation, jointures, indicateurs, absences de relation et logique metier.

## Verification minimale

Apres chargement des scripts, vous pouvez verifier rapidement que tout fonctionne avec :

```sql
SELECT COUNT(*) AS nb_membres FROM membre;
SELECT COUNT(*) AS nb_machines FROM machine;
SELECT COUNT(*) AS nb_projets FROM projet;
SELECT COUNT(*) AS nb_evenements FROM evenement;
```

## Limite actuelle

Le depot contient uniquement la partie base de donnees Oracle.  
Il n'inclut pas d'interface graphique ni d'API backend.

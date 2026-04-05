/*
    ============================================================
    Script : requetes_soutenance_oracle.sql
    Objet  : 30 requetes SQL de demonstration pour la soutenance.

    Couvre les notions classiques d'un cours de base de donnees
    relationnelle :
      - selection simple
      - projection
      - filtrage
      - tri
      - jointures internes et externes
      - agregations
      - GROUP BY / HAVING
      - sous-requetes simples et correlees
      - EXISTS / NOT EXISTS
      - IN
      - operateurs ensemblistes
      - classement / Top-N
      - expressions CASE

    Prerequis :
      1. schema_gestion_fablab_oracle.sql
      2. jeu_donnees_demo_oracle.sql
    ============================================================
*/

/* Requete 01 : lister tous les membres */
SELECT id_membre, nom_membre, prenom_membre, type_membre, email_membre
FROM membre
ORDER BY nom_membre, prenom_membre;

/* Requete 02 : afficher uniquement les etudiants */
SELECT nom_membre, prenom_membre, email_membre
FROM membre
WHERE type_membre = 'ETUDIANT'
ORDER BY prenom_membre;

/* Requete 03 : lister les machines disponibles */
SELECT id_machine, nom_machine, type_machine
FROM machine
WHERE etat_machine = 'DISPONIBLE'
ORDER BY nom_machine;

/* Requete 04 : afficher les projets encore en cours */
SELECT titre_projet, date_debut_projet, date_fin_projet
FROM projet
WHERE date_fin_projet IS NULL
ORDER BY date_debut_projet;

/* Requete 05 : afficher les reservations confirmees avec nom du membre et machine */
SELECT r.id_reservation,
       m.prenom_membre || ' ' || m.nom_membre AS membre,
       ma.nom_machine,
       r.date_reservation,
       r.heure_debut_reservation,
       r.heure_fin_reservation
FROM reservation r
JOIN membre m
    ON m.id_membre = r.id_membre
JOIN machine ma
    ON ma.id_machine = r.id_machine
WHERE r.statut_reservation = 'CONFIRMEE'
ORDER BY r.date_reservation, r.heure_debut_reservation;

/* Requete 06 : afficher les evenements et leurs administrateurs organisateurs */
SELECT e.titre_evenement,
       e.date_evenement,
       a.login AS administrateur
FROM organiser o
JOIN administrateur a
    ON a.id_admin = o.id_admin
JOIN evenement e
    ON e.id_evenement = o.id_evenement
ORDER BY e.date_evenement;

/* Requete 07 : lister le materiel dont le stock est faible */
SELECT nom_materiel, quantite_stock_materiel, unite_materiel
FROM materiel
WHERE quantite_stock_materiel < 10
ORDER BY quantite_stock_materiel;

/* Requete 08 : compter le nombre de membres par type */
SELECT type_membre, COUNT(*) AS nombre_membres
FROM membre
GROUP BY type_membre
ORDER BY type_membre;

/* Requete 09 : compter le nombre de machines par etat */
SELECT etat_machine, COUNT(*) AS nombre_machines
FROM machine
GROUP BY etat_machine
ORDER BY etat_machine;

/* Requete 10 : compter les participants par evenement, y compris ceux sans participant */
SELECT e.titre_evenement,
       COUNT(p.id_membre) AS nombre_participants
FROM evenement e
LEFT JOIN participer p
    ON p.id_evenement = e.id_evenement
GROUP BY e.titre_evenement
ORDER BY nombre_participants DESC, e.titre_evenement;

/* Requete 11 : afficher les projets avec le nombre de membres qui les realisent */
SELECT pr.titre_projet,
       COUNT(r.id_membre) AS nombre_membres
FROM projet pr
LEFT JOIN realiser r
    ON r.id_projet = pr.id_projet
GROUP BY pr.titre_projet
ORDER BY nombre_membres DESC, pr.titre_projet;

/* Requete 12 : afficher les fournisseurs et le materiel qu ils fournissent */
SELECT f.nom_societe, m.nom_materiel
FROM fournir fr
JOIN fournisseur f
    ON f.id_fournisseur = fr.id_fournisseur
JOIN materiel m
    ON m.id_materiel = fr.id_materiel
ORDER BY f.nom_societe, m.nom_materiel;

/* Requete 13 : membres n ayant effectue aucune reservation */
SELECT m.nom_membre, m.prenom_membre, m.email_membre
FROM membre m
WHERE NOT EXISTS (
    SELECT 1
    FROM reservation r
    WHERE r.id_membre = m.id_membre
)
ORDER BY m.nom_membre, m.prenom_membre;

/* Requete 14 : machines n ayant jamais ete reservees */
SELECT ma.nom_machine, ma.type_machine
FROM machine ma
WHERE NOT EXISTS (
    SELECT 1
    FROM reservation r
    WHERE r.id_machine = ma.id_machine
)
ORDER BY ma.nom_machine;

/* Requete 15 : administrateurs ayant organise au moins un evenement */
SELECT a.login, a.droits
FROM administrateur a
WHERE EXISTS (
    SELECT 1
    FROM organiser o
    WHERE o.id_admin = a.id_admin
)
ORDER BY a.login;

/* Requete 16 : projet ayant le plus grand nombre de membres */
SELECT titre_projet, nombre_membres
FROM (
    SELECT pr.titre_projet,
           COUNT(r.id_membre) AS nombre_membres
    FROM projet pr
    LEFT JOIN realiser r
        ON r.id_projet = pr.id_projet
    GROUP BY pr.titre_projet
    ORDER BY COUNT(r.id_membre) DESC, pr.titre_projet
)
FETCH FIRST 1 ROW ONLY;

/* Requete 17 : quantite totale consommee par projet */
SELECT pr.titre_projet,
       SUM(c.quantite_utilise) AS quantite_totale_utilisee
FROM projet pr
JOIN consommer c
    ON c.id_projet = pr.id_projet
GROUP BY pr.titre_projet
ORDER BY quantite_totale_utilisee DESC;

/* Requete 18 : moyenne du stock par unite */
SELECT unite_materiel,
       ROUND(AVG(quantite_stock_materiel), 2) AS stock_moyen
FROM materiel
GROUP BY unite_materiel
ORDER BY unite_materiel;

/* Requete 19 : projets qui consomment plus que la moyenne des consommations enregistrees */
SELECT pr.titre_projet, c.quantite_utilise, m.nom_materiel
FROM consommer c
JOIN projet pr
    ON pr.id_projet = c.id_projet
JOIN materiel m
    ON m.id_materiel = c.id_materiel
WHERE c.quantite_utilise > (
    SELECT AVG(c2.quantite_utilise)
    FROM consommer c2
)
ORDER BY c.quantite_utilise DESC;

/* Requete 20 : evenements ayant plus de participants que la moyenne */
SELECT e.titre_evenement,
       COUNT(p.id_membre) AS nombre_participants
FROM evenement e
LEFT JOIN participer p
    ON p.id_evenement = e.id_evenement
GROUP BY e.id_evenement, e.titre_evenement
HAVING COUNT(p.id_membre) > (
    SELECT AVG(nb_participants)
    FROM (
        SELECT COUNT(p2.id_membre) AS nb_participants
        FROM evenement e2
        LEFT JOIN participer p2
            ON p2.id_evenement = e2.id_evenement
        GROUP BY e2.id_evenement
    )
)
ORDER BY nombre_participants DESC;

/* Requete 21 : membres participant a au moins un evenement et realisant au moins un projet */
SELECT m.id_membre, m.nom_membre, m.prenom_membre
FROM membre m
WHERE EXISTS (
    SELECT 1
    FROM participer p
    WHERE p.id_membre = m.id_membre
)
AND EXISTS (
    SELECT 1
    FROM realiser r
    WHERE r.id_membre = m.id_membre
)
ORDER BY m.nom_membre, m.prenom_membre;

/* Requete 22 : membres ayant participe a un evenement mais ne realisant aucun projet */
SELECT m.id_membre, m.nom_membre, m.prenom_membre
FROM membre m
WHERE EXISTS (
    SELECT 1
    FROM participer p
    WHERE p.id_membre = m.id_membre
)
AND NOT EXISTS (
    SELECT 1
    FROM realiser r
    WHERE r.id_membre = m.id_membre
)
ORDER BY m.nom_membre, m.prenom_membre;

/* Requete 23 : membres ayant reserve la machine Imprimante 3D A */
SELECT DISTINCT m.nom_membre, m.prenom_membre
FROM membre m
JOIN reservation r
    ON r.id_membre = m.id_membre
JOIN machine ma
    ON ma.id_machine = r.id_machine
WHERE ma.nom_machine = 'Imprimante 3D A'
ORDER BY m.nom_membre, m.prenom_membre;

/* Requete 24 : historique des maintenances avec machine et administrateur */
SELECT mt.date_maintenance,
       ma.nom_machine,
       a.login AS admin_responsable,
       mt.type_maintenance,
       mt.description_maintenance
FROM maintenance mt
JOIN machine ma
    ON ma.id_machine = mt.id_machine
JOIN administrateur a
    ON a.id_admin = mt.id_admin
ORDER BY mt.date_maintenance DESC;

/* Requete 25 : nombre de logs par membre */
SELECT m.nom_membre,
       m.prenom_membre,
       COUNT(l.id_log) AS nombre_logs
FROM membre m
LEFT JOIN logactivite l
    ON l.id_membre = m.id_membre
GROUP BY m.nom_membre, m.prenom_membre
ORDER BY nombre_logs DESC, m.nom_membre;

/* Requete 26 : classement des projets par nombre de membres avec RANK */
SELECT titre_projet,
       nombre_membres,
       RANK() OVER (ORDER BY nombre_membres DESC) AS rang_projet
FROM (
    SELECT pr.titre_projet,
           COUNT(r.id_membre) AS nombre_membres
    FROM projet pr
    LEFT JOIN realiser r
        ON r.id_projet = pr.id_projet
    GROUP BY pr.titre_projet
)
ORDER BY rang_projet, titre_projet;

/* Requete 27 : classement des evenements par participation avec DENSE_RANK */
SELECT titre_evenement,
       nombre_participants,
       DENSE_RANK() OVER (ORDER BY nombre_participants DESC) AS rang_evenement
FROM (
    SELECT e.titre_evenement,
           COUNT(p.id_membre) AS nombre_participants
    FROM evenement e
    LEFT JOIN participer p
        ON p.id_evenement = e.id_evenement
    GROUP BY e.titre_evenement
)
ORDER BY rang_evenement, titre_evenement;

/* Requete 28 : operateur ensembliste INTERSECT
   membres qui ont participe a un evenement et qui ont aussi reserve une machine */
SELECT id_membre
FROM participer
INTERSECT
SELECT id_membre
FROM reservation
ORDER BY id_membre;

/* Requete 29 : operateur ensembliste MINUS
   membres qui realisent un projet mais n ont participe a aucun evenement */
SELECT id_membre
FROM realiser
MINUS
SELECT id_membre
FROM participer
ORDER BY id_membre;

/* Requete 30 : categorisation des stocks avec CASE */
SELECT nom_materiel,
       quantite_stock_materiel,
       unite_materiel,
       CASE
           WHEN quantite_stock_materiel < 10 THEN 'STOCK_CRITIQUE'
           WHEN quantite_stock_materiel < 30 THEN 'STOCK_MOYEN'
           ELSE 'STOCK_CONFORTABLE'
       END AS niveau_stock
FROM materiel
ORDER BY quantite_stock_materiel;

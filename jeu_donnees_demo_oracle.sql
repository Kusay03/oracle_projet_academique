/*
    ============================================================
    Script : jeu_donnees_demo_oracle.sql
    Objet  : Insertion d'un jeu de donnees de demonstration
             coherent avec le schema Oracle du projet academique.

    Prerequis :
      - Executer d'abord schema_gestion_fablab_oracle.sql

    Remarque :
      - Les identifiants etant generes automatiquement, les tables
        d'association et les tables dependantes referencent les lignes
        parents via des sous-requetes sur des attributs uniques/metier.
    ============================================================
*/

/* ============================================================
   1. Tables de base
   ============================================================ */

INSERT INTO administrateur (login, mot_de_passe_admin, droits)
VALUES ('admin_nadia', 'hash_admin_01', 'SUPER_ADMIN');

INSERT INTO administrateur (login, mot_de_passe_admin, droits)
VALUES ('admin_youssef', 'hash_admin_02', 'GESTION_MACHINES');

INSERT INTO administrateur (login, mot_de_passe_admin, droits)
VALUES ('admin_sami', 'hash_admin_03', 'GESTION_EVENTS');

INSERT INTO membre (nom_membre, prenom_membre, type_membre, email_membre)
VALUES ('Ben Salem', 'Amine', 'ETUDIANT', 'amine.bensalem@fablab.tn');

INSERT INTO membre (nom_membre, prenom_membre, type_membre, email_membre)
VALUES ('Trabelsi', 'Sarra', 'ETUDIANT', 'sarra.trabelsi@fablab.tn');

INSERT INTO membre (nom_membre, prenom_membre, type_membre, email_membre)
VALUES ('Mansouri', 'Khalil', 'ENSEIGNANT', 'khalil.mansouri@fablab.tn');

INSERT INTO membre (nom_membre, prenom_membre, type_membre, email_membre)
VALUES ('Jlassi', 'Meriem', 'TECHNICIEN', 'meriem.jlassi@fablab.tn');

INSERT INTO membre (nom_membre, prenom_membre, type_membre, email_membre)
VALUES ('Gharbi', 'Omar', 'ETUDIANT', 'omar.gharbi@fablab.tn');

INSERT INTO membre (nom_membre, prenom_membre, type_membre, email_membre)
VALUES ('Ayadi', 'Lina', 'EXTERNE', 'lina.ayadi@fablab.tn');

INSERT INTO membre (nom_membre, prenom_membre, type_membre, email_membre)
VALUES ('Haddad', 'Yassine', 'ETUDIANT', 'yassine.haddad@fablab.tn');

INSERT INTO membre (nom_membre, prenom_membre, type_membre, email_membre)
VALUES ('Zaier', 'Rahma', 'ENSEIGNANT', 'rahma.zaier@fablab.tn');

INSERT INTO evenement (titre_evenement, date_evenement, type_evenement)
VALUES ('Hackathon IoT', DATE '2026-04-20', 'COMPETITION');

INSERT INTO evenement (titre_evenement, date_evenement, type_evenement)
VALUES ('Atelier Impression 3D', DATE '2026-04-15', 'ATELIER');

INSERT INTO evenement (titre_evenement, date_evenement, type_evenement)
VALUES ('Journee Portes Ouvertes', DATE '2026-05-03', 'COMMUNICATION');

INSERT INTO evenement (titre_evenement, date_evenement, type_evenement)
VALUES ('Formation Securite Laser', DATE '2026-04-10', 'FORMATION');

INSERT INTO fournisseur (nom_societe, contact_fournisseur)
VALUES ('TechnoPrint Tunisie', 'contact@technoprint.tn');

INSERT INTO fournisseur (nom_societe, contact_fournisseur)
VALUES ('ElectroSupply', 'vente@electrosupply.tn');

INSERT INTO fournisseur (nom_societe, contact_fournisseur)
VALUES ('MecaTools', 'support@mecatools.tn');

INSERT INTO fournisseur (nom_societe, contact_fournisseur)
VALUES ('FabMaterials', 'info@fabmaterials.tn');

INSERT INTO materiel (nom_materiel, quantite_stock_materiel, unite_materiel)
VALUES ('Filament PLA', 25.50, 'kg');

INSERT INTO materiel (nom_materiel, quantite_stock_materiel, unite_materiel)
VALUES ('Carte Arduino Uno', 18, 'piece');

INSERT INTO materiel (nom_materiel, quantite_stock_materiel, unite_materiel)
VALUES ('Vis M3', 500, 'piece');

INSERT INTO materiel (nom_materiel, quantite_stock_materiel, unite_materiel)
VALUES ('Bois MDF', 12, 'plaque');

INSERT INTO materiel (nom_materiel, quantite_stock_materiel, unite_materiel)
VALUES ('Resine UV', 8.75, 'litre');

INSERT INTO materiel (nom_materiel, quantite_stock_materiel, unite_materiel)
VALUES ('Capteur Ultrason', 30, 'piece');

INSERT INTO projet (titre_projet, description_projet, date_debut_projet, date_fin_projet)
VALUES ('Drone Autonome', 'Prototype de drone autonome pour suivi de trajectoire.', DATE '2026-03-01', NULL);

INSERT INTO projet (titre_projet, description_projet, date_debut_projet, date_fin_projet)
VALUES ('Station Meteo Connectee', 'Station IoT de mesure et visualisation meteo.', DATE '2026-02-15', DATE '2026-06-20');

INSERT INTO projet (titre_projet, description_projet, date_debut_projet, date_fin_projet)
VALUES ('Bras Robotique', 'Bras robotique educatif commande par microcontroleur.', DATE '2026-01-20', DATE '2026-05-30');

INSERT INTO projet (titre_projet, description_projet, date_debut_projet, date_fin_projet)
VALUES ('Mini CNC', 'Conception et integration d une mini machine CNC.', DATE '2026-03-12', NULL);

INSERT INTO machine (nom_machine, type_machine, etat_machine)
VALUES ('Imprimante 3D A', 'IMPRESSION_3D', 'DISPONIBLE');

INSERT INTO machine (nom_machine, type_machine, etat_machine)
VALUES ('Laser Cutter 1', 'DECOUPE_LASER', 'EN_MAINTENANCE');

INSERT INTO machine (nom_machine, type_machine, etat_machine)
VALUES ('Fraiseuse CNC X', 'USINAGE', 'RESERVEE');

INSERT INTO machine (nom_machine, type_machine, etat_machine)
VALUES ('Banc Electronique', 'ELECTRONIQUE', 'DISPONIBLE');

INSERT INTO machine (nom_machine, type_machine, etat_machine)
VALUES ('Imprimante Resine R1', 'IMPRESSION_3D', 'HORS_SERVICE');

/* ============================================================
   2. Tables dependantes
   ============================================================ */

INSERT INTO reservation (
    date_reservation,
    heure_debut_reservation,
    heure_fin_reservation,
    statut_reservation,
    id_membre,
    id_machine
)
VALUES (
    DATE '2026-04-08',
    TO_TIMESTAMP('2026-04-08 09:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    TO_TIMESTAMP('2026-04-08 11:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    'CONFIRMEE',
    (SELECT id_membre FROM membre WHERE email_membre = 'amine.bensalem@fablab.tn'),
    (SELECT id_machine FROM machine WHERE nom_machine = 'Imprimante 3D A')
);

INSERT INTO reservation (
    date_reservation,
    heure_debut_reservation,
    heure_fin_reservation,
    statut_reservation,
    id_membre,
    id_machine
)
VALUES (
    DATE '2026-04-09',
    TO_TIMESTAMP('2026-04-09 14:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    TO_TIMESTAMP('2026-04-09 16:30:00', 'YYYY-MM-DD HH24:MI:SS'),
    'EN_ATTENTE',
    (SELECT id_membre FROM membre WHERE email_membre = 'sarra.trabelsi@fablab.tn'),
    (SELECT id_machine FROM machine WHERE nom_machine = 'Fraiseuse CNC X')
);

INSERT INTO reservation (
    date_reservation,
    heure_debut_reservation,
    heure_fin_reservation,
    statut_reservation,
    id_membre,
    id_machine
)
VALUES (
    DATE '2026-04-11',
    TO_TIMESTAMP('2026-04-11 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    TO_TIMESTAMP('2026-04-11 12:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    'ANNULEE',
    (SELECT id_membre FROM membre WHERE email_membre = 'omar.gharbi@fablab.tn'),
    (SELECT id_machine FROM machine WHERE nom_machine = 'Banc Electronique')
);

INSERT INTO reservation (
    date_reservation,
    heure_debut_reservation,
    heure_fin_reservation,
    statut_reservation,
    id_membre,
    id_machine
)
VALUES (
    DATE '2026-04-12',
    TO_TIMESTAMP('2026-04-12 08:30:00', 'YYYY-MM-DD HH24:MI:SS'),
    TO_TIMESTAMP('2026-04-12 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    'TERMINEE',
    (SELECT id_membre FROM membre WHERE email_membre = 'lina.ayadi@fablab.tn'),
    (SELECT id_machine FROM machine WHERE nom_machine = 'Imprimante 3D A')
);

INSERT INTO reservation (
    date_reservation,
    heure_debut_reservation,
    heure_fin_reservation,
    statut_reservation,
    id_membre,
    id_machine
)
VALUES (
    DATE '2026-04-12',
    TO_TIMESTAMP('2026-04-12 15:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    TO_TIMESTAMP('2026-04-12 17:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    'CONFIRMEE',
    (SELECT id_membre FROM membre WHERE email_membre = 'yassine.haddad@fablab.tn'),
    (SELECT id_machine FROM machine WHERE nom_machine = 'Banc Electronique')
);

INSERT INTO maintenance (
    date_maintenance,
    description_maintenance,
    type_maintenance,
    id_machine,
    id_admin
)
VALUES (
    DATE '2026-04-05',
    'Remplacement du module optique et recalibrage.',
    'CORRECTIVE',
    (SELECT id_machine FROM machine WHERE nom_machine = 'Laser Cutter 1'),
    (SELECT id_admin FROM administrateur WHERE login = 'admin_youssef')
);

INSERT INTO maintenance (
    date_maintenance,
    description_maintenance,
    type_maintenance,
    id_machine,
    id_admin
)
VALUES (
    DATE '2026-04-02',
    'Controle general et nettoyage pre-operatoire.',
    'PREVENTIVE',
    (SELECT id_machine FROM machine WHERE nom_machine = 'Imprimante 3D A'),
    (SELECT id_admin FROM administrateur WHERE login = 'admin_nadia')
);

INSERT INTO maintenance (
    date_maintenance,
    description_maintenance,
    type_maintenance,
    id_machine,
    id_admin
)
VALUES (
    DATE '2026-04-01',
    'Diagnostic suite a une panne d alimentation.',
    'URGENTE',
    (SELECT id_machine FROM machine WHERE nom_machine = 'Imprimante Resine R1'),
    (SELECT id_admin FROM administrateur WHERE login = 'admin_nadia')
);

INSERT INTO logactivite (description_action, horodatage, id_membre)
VALUES (
    'Reservation de la machine Imprimante 3D A',
    TO_TIMESTAMP('2026-04-08 08:45:00', 'YYYY-MM-DD HH24:MI:SS'),
    (SELECT id_membre FROM membre WHERE email_membre = 'amine.bensalem@fablab.tn')
);

INSERT INTO logactivite (description_action, horodatage, id_membre)
VALUES (
    'Participation a l atelier impression 3D',
    TO_TIMESTAMP('2026-04-15 17:10:00', 'YYYY-MM-DD HH24:MI:SS'),
    (SELECT id_membre FROM membre WHERE email_membre = 'sarra.trabelsi@fablab.tn')
);

INSERT INTO logactivite (description_action, horodatage, id_membre)
VALUES (
    'Mise a jour du projet Drone Autonome',
    TO_TIMESTAMP('2026-04-06 19:30:00', 'YYYY-MM-DD HH24:MI:SS'),
    (SELECT id_membre FROM membre WHERE email_membre = 'yassine.haddad@fablab.tn')
);

INSERT INTO logactivite (description_action, horodatage, id_membre)
VALUES (
    'Consultation du stock de materiel',
    TO_TIMESTAMP('2026-04-04 11:20:00', 'YYYY-MM-DD HH24:MI:SS'),
    (SELECT id_membre FROM membre WHERE email_membre = 'meriem.jlassi@fablab.tn')
);

/* ============================================================
   3. Tables d'association
   ============================================================ */

INSERT INTO organiser (id_admin, id_evenement)
VALUES (
    (SELECT id_admin FROM administrateur WHERE login = 'admin_sami'),
    (SELECT id_evenement FROM evenement WHERE titre_evenement = 'Hackathon IoT')
);

INSERT INTO organiser (id_admin, id_evenement)
VALUES (
    (SELECT id_admin FROM administrateur WHERE login = 'admin_nadia'),
    (SELECT id_evenement FROM evenement WHERE titre_evenement = 'Atelier Impression 3D')
);

INSERT INTO organiser (id_admin, id_evenement)
VALUES (
    (SELECT id_admin FROM administrateur WHERE login = 'admin_youssef'),
    (SELECT id_evenement FROM evenement WHERE titre_evenement = 'Formation Securite Laser')
);

INSERT INTO participer (id_evenement, id_membre)
VALUES (
    (SELECT id_evenement FROM evenement WHERE titre_evenement = 'Hackathon IoT'),
    (SELECT id_membre FROM membre WHERE email_membre = 'amine.bensalem@fablab.tn')
);

INSERT INTO participer (id_evenement, id_membre)
VALUES (
    (SELECT id_evenement FROM evenement WHERE titre_evenement = 'Hackathon IoT'),
    (SELECT id_membre FROM membre WHERE email_membre = 'sarra.trabelsi@fablab.tn')
);

INSERT INTO participer (id_evenement, id_membre)
VALUES (
    (SELECT id_evenement FROM evenement WHERE titre_evenement = 'Hackathon IoT'),
    (SELECT id_membre FROM membre WHERE email_membre = 'yassine.haddad@fablab.tn')
);

INSERT INTO participer (id_evenement, id_membre)
VALUES (
    (SELECT id_evenement FROM evenement WHERE titre_evenement = 'Atelier Impression 3D'),
    (SELECT id_membre FROM membre WHERE email_membre = 'sarra.trabelsi@fablab.tn')
);

INSERT INTO participer (id_evenement, id_membre)
VALUES (
    (SELECT id_evenement FROM evenement WHERE titre_evenement = 'Atelier Impression 3D'),
    (SELECT id_membre FROM membre WHERE email_membre = 'lina.ayadi@fablab.tn')
);

INSERT INTO participer (id_evenement, id_membre)
VALUES (
    (SELECT id_evenement FROM evenement WHERE titre_evenement = 'Journee Portes Ouvertes'),
    (SELECT id_membre FROM membre WHERE email_membre = 'rahma.zaier@fablab.tn')
);

INSERT INTO participer (id_evenement, id_membre)
VALUES (
    (SELECT id_evenement FROM evenement WHERE titre_evenement = 'Formation Securite Laser'),
    (SELECT id_membre FROM membre WHERE email_membre = 'meriem.jlassi@fablab.tn')
);

INSERT INTO fournir (id_fournisseur, id_materiel)
VALUES (
    (SELECT id_fournisseur FROM fournisseur WHERE nom_societe = 'TechnoPrint Tunisie'),
    (SELECT id_materiel FROM materiel WHERE nom_materiel = 'Filament PLA')
);

INSERT INTO fournir (id_fournisseur, id_materiel)
VALUES (
    (SELECT id_fournisseur FROM fournisseur WHERE nom_societe = 'TechnoPrint Tunisie'),
    (SELECT id_materiel FROM materiel WHERE nom_materiel = 'Resine UV')
);

INSERT INTO fournir (id_fournisseur, id_materiel)
VALUES (
    (SELECT id_fournisseur FROM fournisseur WHERE nom_societe = 'ElectroSupply'),
    (SELECT id_materiel FROM materiel WHERE nom_materiel = 'Carte Arduino Uno')
);

INSERT INTO fournir (id_fournisseur, id_materiel)
VALUES (
    (SELECT id_fournisseur FROM fournisseur WHERE nom_societe = 'ElectroSupply'),
    (SELECT id_materiel FROM materiel WHERE nom_materiel = 'Capteur Ultrason')
);

INSERT INTO fournir (id_fournisseur, id_materiel)
VALUES (
    (SELECT id_fournisseur FROM fournisseur WHERE nom_societe = 'MecaTools'),
    (SELECT id_materiel FROM materiel WHERE nom_materiel = 'Vis M3')
);

INSERT INTO fournir (id_fournisseur, id_materiel)
VALUES (
    (SELECT id_fournisseur FROM fournisseur WHERE nom_societe = 'FabMaterials'),
    (SELECT id_materiel FROM materiel WHERE nom_materiel = 'Bois MDF')
);

INSERT INTO consommer (id_materiel, id_projet, quantite_utilise)
VALUES (
    (SELECT id_materiel FROM materiel WHERE nom_materiel = 'Carte Arduino Uno'),
    (SELECT id_projet FROM projet WHERE titre_projet = 'Drone Autonome'),
    4
);

INSERT INTO consommer (id_materiel, id_projet, quantite_utilise)
VALUES (
    (SELECT id_materiel FROM materiel WHERE nom_materiel = 'Capteur Ultrason'),
    (SELECT id_projet FROM projet WHERE titre_projet = 'Drone Autonome'),
    6
);

INSERT INTO consommer (id_materiel, id_projet, quantite_utilise)
VALUES (
    (SELECT id_materiel FROM materiel WHERE nom_materiel = 'Carte Arduino Uno'),
    (SELECT id_projet FROM projet WHERE titre_projet = 'Station Meteo Connectee'),
    3
);

INSERT INTO consommer (id_materiel, id_projet, quantite_utilise)
VALUES (
    (SELECT id_materiel FROM materiel WHERE nom_materiel = 'Bois MDF'),
    (SELECT id_projet FROM projet WHERE titre_projet = 'Mini CNC'),
    5
);

INSERT INTO consommer (id_materiel, id_projet, quantite_utilise)
VALUES (
    (SELECT id_materiel FROM materiel WHERE nom_materiel = 'Vis M3'),
    (SELECT id_projet FROM projet WHERE titre_projet = 'Bras Robotique'),
    120
);

INSERT INTO consommer (id_materiel, id_projet, quantite_utilise)
VALUES (
    (SELECT id_materiel FROM materiel WHERE nom_materiel = 'Filament PLA'),
    (SELECT id_projet FROM projet WHERE titre_projet = 'Bras Robotique'),
    2.5
);

INSERT INTO realiser (id_projet, id_membre)
VALUES (
    (SELECT id_projet FROM projet WHERE titre_projet = 'Drone Autonome'),
    (SELECT id_membre FROM membre WHERE email_membre = 'amine.bensalem@fablab.tn')
);

INSERT INTO realiser (id_projet, id_membre)
VALUES (
    (SELECT id_projet FROM projet WHERE titre_projet = 'Drone Autonome'),
    (SELECT id_membre FROM membre WHERE email_membre = 'yassine.haddad@fablab.tn')
);

INSERT INTO realiser (id_projet, id_membre)
VALUES (
    (SELECT id_projet FROM projet WHERE titre_projet = 'Station Meteo Connectee'),
    (SELECT id_membre FROM membre WHERE email_membre = 'sarra.trabelsi@fablab.tn')
);

INSERT INTO realiser (id_projet, id_membre)
VALUES (
    (SELECT id_projet FROM projet WHERE titre_projet = 'Station Meteo Connectee'),
    (SELECT id_membre FROM membre WHERE email_membre = 'rahma.zaier@fablab.tn')
);

INSERT INTO realiser (id_projet, id_membre)
VALUES (
    (SELECT id_projet FROM projet WHERE titre_projet = 'Bras Robotique'),
    (SELECT id_membre FROM membre WHERE email_membre = 'meriem.jlassi@fablab.tn')
);

INSERT INTO realiser (id_projet, id_membre)
VALUES (
    (SELECT id_projet FROM projet WHERE titre_projet = 'Bras Robotique'),
    (SELECT id_membre FROM membre WHERE email_membre = 'khalil.mansouri@fablab.tn')
);

INSERT INTO realiser (id_projet, id_membre)
VALUES (
    (SELECT id_projet FROM projet WHERE titre_projet = 'Mini CNC'),
    (SELECT id_membre FROM membre WHERE email_membre = 'omar.gharbi@fablab.tn')
);

COMMIT;

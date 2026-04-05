/*
    ============================================================
    Script : schema_gestion_fablab_oracle.sql
    Objet  : Creation du schema relationnel Oracle d'un systeme
             de gestion de fablab / atelier academique.

    Compatibilite cible :
      - Oracle Database 19c
      - Oracle Database 21c
      - Compatible avec Oracle Free recent pour validation locale

    Execution :
      - SQL*Plus      : @schema_gestion_fablab_oracle.sql
      - SQL Developer : Executer en tant que script
      - DBeaver       : Executer le script complet

    Contenu du script :
      1. Suppression idempotente des tables si elles existent
      2. Creation des tables independantes
      3. Creation des tables dependantes (relations 1:N)
      4. Creation des tables d'association (relations N:M)
      5. Creation des index de support sur les cles etrangeres

    Hypotheses de modelisation :
      - Les cles primaires simples utilisent GENERATED ALWAYS AS IDENTITY.
      - Les tables d'association utilisent ON DELETE CASCADE pour eviter
        les lignes orphelines.
      - Quelques contraintes CHECK sont ajoutees pour renforcer
        l'integrite fonctionnelle du schema.
    ============================================================
*/

/* ============================================================
   0. Bloc de nettoyage
   Suppression dans l'ordre inverse des dependances afin de rendre
   le script reexecutable sans intervention manuelle.
   ============================================================ */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE realiser CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE consommer CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE fournir CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE participer CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE organiser CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE logactivite CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE maintenance CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE reservation CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE materiel CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE fournisseur CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE projet CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE evenement CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE membre CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE machine CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE administrateur CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

/* ============================================================
   1. Tables independantes
   ============================================================ */

CREATE TABLE administrateur (
    id_admin             NUMBER GENERATED ALWAYS AS IDENTITY,
    login                VARCHAR2(50)  NOT NULL,
    mot_de_passe_admin   VARCHAR2(255) NOT NULL,
    droits               VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_administrateur PRIMARY KEY (id_admin),
    CONSTRAINT uq_administrateur_login UNIQUE (login)
);

CREATE TABLE evenement (
    id_evenement         NUMBER GENERATED ALWAYS AS IDENTITY,
    titre_evenement      VARCHAR2(150) NOT NULL,
    date_evenement       DATE          NOT NULL,
    type_evenement       VARCHAR2(50)  NOT NULL,
    CONSTRAINT pk_evenement PRIMARY KEY (id_evenement)
);

CREATE TABLE membre (
    id_membre            NUMBER GENERATED ALWAYS AS IDENTITY,
    nom_membre           VARCHAR2(100) NOT NULL,
    prenom_membre        VARCHAR2(100) NOT NULL,
    type_membre          VARCHAR2(30)  NOT NULL,
    email_membre         VARCHAR2(254) NOT NULL,
    CONSTRAINT pk_membre PRIMARY KEY (id_membre),
    CONSTRAINT uq_membre_email UNIQUE (email_membre),
    CONSTRAINT ck_membre_email_format
        CHECK (email_membre LIKE '%_@_%._%'),
    CONSTRAINT ck_membre_type
        CHECK (UPPER(type_membre) IN ('ETUDIANT', 'ENSEIGNANT', 'TECHNICIEN', 'EXTERNE'))
);

CREATE TABLE fournisseur (
    id_fournisseur       NUMBER GENERATED ALWAYS AS IDENTITY,
    nom_societe          VARCHAR2(150) NOT NULL,
    contact_fournisseur  VARCHAR2(150) NOT NULL,
    CONSTRAINT pk_fournisseur PRIMARY KEY (id_fournisseur),
    CONSTRAINT uq_fournisseur_nom_societe UNIQUE (nom_societe)
);

CREATE TABLE materiel (
    id_materiel                NUMBER GENERATED ALWAYS AS IDENTITY,
    nom_materiel               VARCHAR2(150) NOT NULL,
    quantite_stock_materiel    NUMBER(10,2)  NOT NULL,
    unite_materiel             VARCHAR2(30)  NOT NULL,
    CONSTRAINT pk_materiel PRIMARY KEY (id_materiel),
    CONSTRAINT ck_materiel_stock_non_negatif
        CHECK (quantite_stock_materiel >= 0)
);

CREATE TABLE projet (
    id_projet             NUMBER GENERATED ALWAYS AS IDENTITY,
    titre_projet          VARCHAR2(150)  NOT NULL,
    description_projet    VARCHAR2(1000) NOT NULL,
    date_debut_projet     DATE           NOT NULL,
    date_fin_projet       DATE,
    CONSTRAINT pk_projet PRIMARY KEY (id_projet),
    CONSTRAINT ck_projet_dates
        CHECK (date_fin_projet IS NULL OR date_fin_projet >= date_debut_projet)
);

CREATE TABLE machine (
    id_machine            NUMBER GENERATED ALWAYS AS IDENTITY,
    nom_machine           VARCHAR2(100) NOT NULL,
    type_machine          VARCHAR2(50)  NOT NULL,
    etat_machine          VARCHAR2(30)  NOT NULL,
    CONSTRAINT pk_machine PRIMARY KEY (id_machine),
    CONSTRAINT uq_machine_nom UNIQUE (nom_machine),
    CONSTRAINT ck_machine_etat
        CHECK (UPPER(etat_machine) IN ('DISPONIBLE', 'RESERVEE', 'EN_MAINTENANCE', 'HORS_SERVICE'))
);

/* ============================================================
   2. Tables dependantes avec cles etrangeres (relations 1:N)
   ============================================================ */

CREATE TABLE reservation (
    id_reservation            NUMBER GENERATED ALWAYS AS IDENTITY,
    date_reservation          DATE          NOT NULL,
    heure_debut_reservation   TIMESTAMP     NOT NULL,
    heure_fin_reservation     TIMESTAMP     NOT NULL,
    statut_reservation        VARCHAR2(20)  NOT NULL,
    id_membre                 NUMBER        NOT NULL,
    id_machine                NUMBER        NOT NULL,
    CONSTRAINT pk_reservation PRIMARY KEY (id_reservation),
    CONSTRAINT fk_reservation_membre
        FOREIGN KEY (id_membre)
        REFERENCES membre (id_membre),
    CONSTRAINT fk_reservation_machine
        FOREIGN KEY (id_machine)
        REFERENCES machine (id_machine),
    CONSTRAINT ck_reservation_horaires
        CHECK (heure_fin_reservation > heure_debut_reservation),
    CONSTRAINT ck_reservation_coherence_date
        CHECK (
            TRUNC(CAST(heure_debut_reservation AS DATE)) = TRUNC(date_reservation)
            AND TRUNC(CAST(heure_fin_reservation AS DATE)) = TRUNC(date_reservation)
        ),
    CONSTRAINT ck_reservation_statut
        CHECK (UPPER(statut_reservation) IN ('EN_ATTENTE', 'CONFIRMEE', 'ANNULEE', 'TERMINEE'))
);

CREATE TABLE maintenance (
    id_maintenance            NUMBER GENERATED ALWAYS AS IDENTITY,
    date_maintenance          DATE           NOT NULL,
    description_maintenance   VARCHAR2(1000) NOT NULL,
    type_maintenance          VARCHAR2(30)   NOT NULL,
    id_machine                NUMBER         NOT NULL,
    id_admin                  NUMBER         NOT NULL,
    CONSTRAINT pk_maintenance PRIMARY KEY (id_maintenance),
    CONSTRAINT fk_maintenance_machine
        FOREIGN KEY (id_machine)
        REFERENCES machine (id_machine),
    CONSTRAINT fk_maintenance_admin
        FOREIGN KEY (id_admin)
        REFERENCES administrateur (id_admin),
    CONSTRAINT ck_maintenance_type
        CHECK (UPPER(type_maintenance) IN ('PREVENTIVE', 'CORRECTIVE', 'URGENTE'))
);

CREATE TABLE logactivite (
    id_log                NUMBER GENERATED ALWAYS AS IDENTITY,
    description_action    VARCHAR2(1000)               NOT NULL,
    horodatage            TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    id_membre             NUMBER                       NOT NULL,
    CONSTRAINT pk_logactivite PRIMARY KEY (id_log),
    CONSTRAINT fk_logactivite_membre
        FOREIGN KEY (id_membre)
        REFERENCES membre (id_membre)
);

/* ============================================================
   3. Tables d'association (relations N:M)
   Les foreign keys utilisent ON DELETE CASCADE afin d'eliminer
   automatiquement les associations orphelines.
   ============================================================ */

CREATE TABLE organiser (
    id_admin              NUMBER NOT NULL,
    id_evenement          NUMBER NOT NULL,
    CONSTRAINT pk_organiser PRIMARY KEY (id_admin, id_evenement),
    CONSTRAINT fk_organiser_admin
        FOREIGN KEY (id_admin)
        REFERENCES administrateur (id_admin)
        ON DELETE CASCADE,
    CONSTRAINT fk_organiser_evenement
        FOREIGN KEY (id_evenement)
        REFERENCES evenement (id_evenement)
        ON DELETE CASCADE
);

CREATE TABLE participer (
    id_evenement          NUMBER NOT NULL,
    id_membre             NUMBER NOT NULL,
    CONSTRAINT pk_participer PRIMARY KEY (id_evenement, id_membre),
    CONSTRAINT fk_participer_evenement
        FOREIGN KEY (id_evenement)
        REFERENCES evenement (id_evenement)
        ON DELETE CASCADE,
    CONSTRAINT fk_participer_membre
        FOREIGN KEY (id_membre)
        REFERENCES membre (id_membre)
        ON DELETE CASCADE
);

CREATE TABLE fournir (
    id_fournisseur        NUMBER NOT NULL,
    id_materiel           NUMBER NOT NULL,
    CONSTRAINT pk_fournir PRIMARY KEY (id_fournisseur, id_materiel),
    CONSTRAINT fk_fournir_fournisseur
        FOREIGN KEY (id_fournisseur)
        REFERENCES fournisseur (id_fournisseur)
        ON DELETE CASCADE,
    CONSTRAINT fk_fournir_materiel
        FOREIGN KEY (id_materiel)
        REFERENCES materiel (id_materiel)
        ON DELETE CASCADE
);

CREATE TABLE consommer (
    id_materiel           NUMBER       NOT NULL,
    id_projet             NUMBER       NOT NULL,
    quantite_utilise      NUMBER(10,2) NOT NULL,
    CONSTRAINT pk_consommer PRIMARY KEY (id_materiel, id_projet),
    CONSTRAINT fk_consommer_materiel
        FOREIGN KEY (id_materiel)
        REFERENCES materiel (id_materiel)
        ON DELETE CASCADE,
    CONSTRAINT fk_consommer_projet
        FOREIGN KEY (id_projet)
        REFERENCES projet (id_projet)
        ON DELETE CASCADE,
    CONSTRAINT ck_consommer_quantite_positive
        CHECK (quantite_utilise > 0)
);

CREATE TABLE realiser (
    id_projet             NUMBER NOT NULL,
    id_membre             NUMBER NOT NULL,
    CONSTRAINT pk_realiser PRIMARY KEY (id_projet, id_membre),
    CONSTRAINT fk_realiser_projet
        FOREIGN KEY (id_projet)
        REFERENCES projet (id_projet)
        ON DELETE CASCADE,
    CONSTRAINT fk_realiser_membre
        FOREIGN KEY (id_membre)
        REFERENCES membre (id_membre)
        ON DELETE CASCADE
);

/* ============================================================
   4. Index de support
   Les index sur cles etrangeres ameliorent les jointures et limitent
   les verrous couteux lors des suppressions / mises a jour parentales.
   ============================================================ */

CREATE INDEX idx_reservation_membre
    ON reservation (id_membre);

CREATE INDEX idx_reservation_machine
    ON reservation (id_machine);

CREATE INDEX idx_maintenance_machine
    ON maintenance (id_machine);

CREATE INDEX idx_maintenance_admin
    ON maintenance (id_admin);

CREATE INDEX idx_logactivite_membre
    ON logactivite (id_membre);

CREATE INDEX idx_organiser_evenement
    ON organiser (id_evenement);

CREATE INDEX idx_participer_membre
    ON participer (id_membre);

CREATE INDEX idx_fournir_materiel
    ON fournir (id_materiel);

CREATE INDEX idx_consommer_projet
    ON consommer (id_projet);

CREATE INDEX idx_realiser_membre
    ON realiser (id_membre);

/* ============================================================
   5. Commentaires de documentation
   ============================================================ */

COMMENT ON TABLE administrateur IS 'Administrateurs responsables de la gestion et de la maintenance du systeme.';
COMMENT ON TABLE evenement IS 'Evenements organises dans le cadre du fablab ou du projet academique.';
COMMENT ON TABLE membre IS 'Membres autorises a participer aux projets, evenements et reservations.';
COMMENT ON TABLE fournisseur IS 'Fournisseurs de materiel et de consommables.';
COMMENT ON TABLE materiel IS 'Materiels et consommables disponibles en stock.';
COMMENT ON TABLE projet IS 'Projets realises dans le cadre du fablab.';
COMMENT ON TABLE machine IS 'Machines reservables ou maintenables.';
COMMENT ON TABLE reservation IS 'Reservations effectuees par les membres sur les machines.';
COMMENT ON TABLE maintenance IS 'Operations de maintenance effectuees sur les machines.';
COMMENT ON TABLE logactivite IS 'Journal des actions importantes effectuees par les membres.';
COMMENT ON TABLE organiser IS 'Association entre administrateurs et evenements organises.';
COMMENT ON TABLE participer IS 'Association entre membres et evenements auxquels ils participent.';
COMMENT ON TABLE fournir IS 'Association entre fournisseurs et materiels fournis.';
COMMENT ON TABLE consommer IS 'Association entre projets et materiels consommes.';
COMMENT ON TABLE realiser IS 'Association entre membres et projets realises.';

# Explication détaillée du script DDL Oracle

## 1. Objectif général

Le script `schema_gestion_fablab_oracle.sql` transforme le MCD fourni en **Modèle Physique de Données (MPD)** compatible avec **Oracle 19c/21c**.  
L’idée est de produire un livrable académique propre, exécutable directement, et défendable à l’oral.

Le domaine fonctionnel représenté est celui d’un **fablab / atelier académique** où :

- des administrateurs organisent des événements et gèrent la maintenance ;
- des membres participent à des événements, réservent des machines et réalisent des projets ;
- des fournisseurs fournissent du matériel ;
- des projets consomment du matériel.

---

## 2. Logique générale de construction du script

Le script a été organisé en plusieurs blocs pour respecter les dépendances entre tables :

1. **Bloc de suppression (`DROP`)**
2. **Création des tables indépendantes**
3. **Création des tables dépendantes avec clés étrangères**
4. **Création des tables d’association**
5. **Création d’index**
6. **Ajout de commentaires de documentation**

Cette structure est importante car Oracle refuse de créer une clé étrangère vers une table qui n’existe pas encore.

---

## 3. Pourquoi un bloc de suppression au début ?

J’ai ajouté des blocs PL/SQL du type :

```sql
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE ... CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/
```

### But

Rendre le script **réexécutable** sans erreur.

### Pourquoi cette méthode ?

- `DROP TABLE` simple échoue si la table n’existe pas.
- Le code intercepte uniquement l’erreur Oracle `ORA-00942` ("table or view does not exist").
- `CASCADE CONSTRAINTS` supprime les contraintes dépendantes.
- `PURGE` évite que les tables aillent dans la corbeille Oracle, ce qui garde un environnement plus propre.

### Intérêt pour ton projet

Pendant une soutenance ou une démonstration, tu peux relancer le script plusieurs fois sans devoir nettoyer la base à la main.

---

## 4. Choix des types Oracle

Les types utilisés respectent la demande :

- `NUMBER` pour les identifiants et les quantités
- `VARCHAR2` pour les attributs textuels
- `DATE` pour les dates métier
- `TIMESTAMP` pour les données horodatées ou les heures précises

### Détail des choix

- Les identifiants `id_...` sont en `NUMBER GENERATED ALWAYS AS IDENTITY`.
- Les dates comme `date_evenement`, `date_debut_projet`, `date_fin_projet` sont en `DATE`.
- `horodatage` dans `logactivite` est en `TIMESTAMP` car on veut conserver l’instant précis d’une action.
- Les heures de réservation sont en `TIMESTAMP` pour pouvoir faire une comparaison fiable entre début et fin.

---

## 5. Pourquoi utiliser `GENERATED ALWAYS AS IDENTITY` ?

Exemple :

```sql
id_membre NUMBER GENERATED ALWAYS AS IDENTITY
```

### Rôle

Oracle génère automatiquement la valeur de la clé primaire.

### Avantages

- pas besoin de séquence manuelle ;
- pas besoin de trigger ;
- syntaxe moderne et propre ;
- plus lisible pour un projet académique ;
- parfaitement adaptée à Oracle 19c/21c.

### Pourquoi `ALWAYS` et pas `BY DEFAULT` ?

- `ALWAYS` impose que la base contrôle réellement l’identifiant ;
- cela évite les insertions manuelles incohérentes ;
- c’est un bon choix pour un schéma académique où l’intégrité prime.

---

## 6. Tables indépendantes

Ce sont les tables qui ne dépendent d’aucune autre table.

### 6.1 `administrateur`

Contient les comptes d’administration.

Colonnes principales :

- `id_admin` : clé primaire
- `login` : identifiant de connexion
- `mot_de_passe_admin` : mot de passe stocké
- `droits` : niveau ou type de droits

Choix notables :

- `login` est en `UNIQUE` pour éviter les doublons.

### 6.2 `evenement`

Contient les événements.

Colonnes :

- `id_evenement`
- `titre_evenement`
- `date_evenement`
- `type_evenement`

### 6.3 `membre`

Contient les membres.

Colonnes :

- `id_membre`
- `nom_membre`
- `prenom_membre`
- `type_membre`
- `email_membre`

Choix notables :

- `email_membre` est en `UNIQUE` ;
- une contrainte `CHECK` simple vérifie la présence d’un format ressemblant à un email ;
- `type_membre` est limité à quelques valeurs cohérentes : `ETUDIANT`, `ENSEIGNANT`, `TECHNICIEN`, `EXTERNE`.

### 6.4 `fournisseur`

Contient les fournisseurs de matériel.

Colonnes :

- `id_fournisseur`
- `nom_societe`
- `contact_fournisseur`

Choix notable :

- `nom_societe` est mis en `UNIQUE` pour éviter deux fournisseurs strictement identiques dans le référentiel.

### 6.5 `materiel`

Contient le matériel ou les consommables.

Colonnes :

- `id_materiel`
- `nom_materiel`
- `quantite_stock_materiel`
- `unite_materiel`

Choix notable :

- `quantite_stock_materiel >= 0` grâce à une contrainte `CHECK`.

J’ai choisi `NUMBER(10,2)` pour permettre :

- des pièces entières ;
- mais aussi des quantités fractionnaires si l’unité est par exemple `kg`, `litre`, etc.

### 6.6 `projet`

Contient les projets.

Colonnes :

- `id_projet`
- `titre_projet`
- `description_projet`
- `date_debut_projet`
- `date_fin_projet`

Choix notable :

- `date_fin_projet` peut être nulle si le projet est encore en cours ;
- sinon, elle doit être supérieure ou égale à `date_debut_projet`.

### 6.7 `machine`

Contient les machines utilisables.

Colonnes :

- `id_machine`
- `nom_machine`
- `type_machine`
- `etat_machine`

Choix notables :

- `nom_machine` est `UNIQUE` ;
- `etat_machine` est limité à des états métier logiques :
  - `DISPONIBLE`
  - `RESERVEE`
  - `EN_MAINTENANCE`
  - `HORS_SERVICE`

---

## 7. Tables dépendantes avec relations 1:N

Ces tables possèdent leurs propres clés primaires, mais référencent d’autres tables par clés étrangères.

### 7.1 `reservation`

Relation métier :

- un membre peut faire plusieurs réservations ;
- une machine peut apparaître dans plusieurs réservations ;
- chaque réservation concerne un seul membre et une seule machine.

Colonnes :

- `id_reservation`
- `date_reservation`
- `heure_debut_reservation`
- `heure_fin_reservation`
- `statut_reservation`
- `id_membre`
- `id_machine`

Contraintes ajoutées :

- `heure_fin_reservation > heure_debut_reservation`
- cohérence entre la date de réservation et les timestamps de début/fin
- statut limité à :
  - `EN_ATTENTE`
  - `CONFIRMEE`
  - `ANNULEE`
  - `TERMINEE`

Pourquoi cette modélisation ?

Oracle ne possède pas de type `TIME` pur.  
Le choix de `TIMESTAMP` permet de garder une comparaison temporelle robuste.

### 7.2 `maintenance`

Relation métier :

- une machine peut avoir plusieurs maintenances ;
- un administrateur peut enregistrer plusieurs maintenances.

Colonnes :

- `id_maintenance`
- `date_maintenance`
- `description_maintenance`
- `type_maintenance`
- `id_machine`
- `id_admin`

Contrainte ajoutée :

- `type_maintenance` limité à `PREVENTIVE`, `CORRECTIVE`, `URGENTE`.

### 7.3 `logactivite`

Relation métier :

- un membre peut générer plusieurs logs ;
- un log appartient à un seul membre.

Colonnes :

- `id_log`
- `description_action`
- `horodatage`
- `id_membre`

Choix notable :

- `horodatage` a la valeur par défaut `SYSTIMESTAMP`, ce qui automatise la date/heure du log à l’insertion.

---

## 8. Tables d’association pour les relations N:M

Ces tables servent à représenter les associations plusieurs-à-plusieurs.

### Principe général

Chaque table d’association :

- contient les clés étrangères des deux entités liées ;
- définit une **clé primaire composée** ;
- utilise `ON DELETE CASCADE` sur les clés étrangères.

### Pourquoi `ON DELETE CASCADE` ici ?

Exemple : si un projet est supprimé, les lignes de `realiser` ou `consommer` qui pointent vers ce projet doivent disparaître automatiquement.  
Cela évite les **données orphelines** et renforce la cohérence du schéma.

### 8.1 `organiser`

Lie :

- `administrateur`
- `evenement`

Clé primaire composée :

- `(id_admin, id_evenement)`

### 8.2 `participer`

Lie :

- `evenement`
- `membre`

Clé primaire composée :

- `(id_evenement, id_membre)`

### 8.3 `fournir`

Lie :

- `fournisseur`
- `materiel`

Clé primaire composée :

- `(id_fournisseur, id_materiel)`

### 8.4 `consommer`

Lie :

- `materiel`
- `projet`

Clé primaire composée :

- `(id_materiel, id_projet)`

Attribut propre :

- `quantite_utilise`

Contrainte ajoutée :

- `quantite_utilise > 0`

Cette table est importante car elle montre une vraie relation N:M enrichie par un attribut métier.

### 8.5 `realiser`

Lie :

- `projet`
- `membre`

Clé primaire composée :

- `(id_projet, id_membre)`

---

## 9. Pourquoi nommer explicitement toutes les contraintes ?

J’ai volontairement utilisé des noms explicites comme :

- `pk_membre`
- `fk_reservation_machine`
- `ck_projet_dates`
- `uq_membre_email`

### Intérêt

1. Le schéma est plus lisible.
2. En cas d’erreur Oracle, le message est plus compréhensible.
3. Cela montre de bonnes pratiques de modélisation.
4. C’est plus professionnel qu’un nom généré automatiquement par Oracle.

---

## 10. Pourquoi ajouter des contraintes `NOT NULL` ?

Les colonnes obligatoires métier sont déclarées en `NOT NULL`.

Exemples :

- un membre doit avoir un nom, un prénom et un email ;
- une réservation doit avoir un membre, une machine, une date et un statut ;
- un projet doit avoir une date de début ;
- une maintenance doit avoir une description.

### Intérêt

Cela bloque les enregistrements incomplets directement au niveau base de données, même si l’application cliente fait une erreur.

---

## 11. Pourquoi ajouter des index sur les clés étrangères ?

Même si Oracle crée automatiquement les index de clé primaire et d’unicité, ce n’est pas le cas pour toutes les clés étrangères.

J’ai donc ajouté des index de support comme :

- `idx_reservation_membre`
- `idx_reservation_machine`
- `idx_maintenance_machine`
- `idx_logactivite_membre`

### Intérêt

- amélioration des jointures ;
- meilleures performances sur les recherches ;
- réduction des verrous coûteux lors de suppressions côté table parent ;
- bonne pratique classique dans un schéma relationnel Oracle.

---

## 12. Pourquoi ajouter des `COMMENT ON TABLE` ?

J’ai documenté les tables directement dans la base.

### Intérêt

- SQL Developer ou d’autres outils peuvent afficher cette documentation ;
- cela rend la base plus compréhensible ;
- c’est valorisant dans un projet académique.

---

## 13. Règles d’intégrité métier les plus importantes

Voici les règles que le script garantit directement :

1. Un identifiant simple est généré automatiquement.
2. Un login administrateur ne peut pas être dupliqué.
3. Un email membre ne peut pas être dupliqué.
4. Le stock matériel ne peut pas être négatif.
5. Une quantité consommée doit être strictement positive.
6. La date de fin d’un projet ne peut pas être avant sa date de début.
7. La fin d’une réservation doit être après le début.
8. Les associations N:M sont supprimées automatiquement si l’une des entités parentes est supprimée.
9. Les statuts et types majeurs sont limités à des valeurs cohérentes.

---

## 14. Pourquoi certains choix sont "académiques mais réalistes" ?

Le script cherche un équilibre entre :

- **fidélité au MCD fourni**
- **bonnes pratiques Oracle**
- **simplicité de démonstration**

Par exemple :

- les listes de valeurs (`CHECK ... IN (...)`) sont pratiques pour montrer l’intégrité métier ;
- dans un système industriel plus grand, certaines de ces listes pourraient être externalisées dans des tables de référence ;
- ici, les contraintes `CHECK` sont plus simples à expliquer et très adaptées à un projet évalué.

---

## 15. Compatibilité avec ton conteneur Oracle local

Le script a été conçu pour être exécuté tel quel dans :

- SQL*Plus
- Oracle SQL Developer
- DBeaver

### Points de compatibilité importants

- pas d’utilisation de syntaxe spécifique à PostgreSQL ou MySQL ;
- types 100 % Oracle (`VARCHAR2`, `NUMBER`, `DATE`, `TIMESTAMP`) ;
- blocs PL/SQL terminés par `/`, format standard Oracle ;
- identité gérée avec la syntaxe Oracle moderne.

---

## 16. Comment présenter ce travail à l’oral

Tu peux expliquer la logique avec ce fil directeur :

1. **J’ai commencé par transformer le MCD en tables physiques Oracle.**
2. **J’ai séparé les tables indépendantes, dépendantes et d’association pour respecter les dépendances.**
3. **J’ai utilisé des identifiants automatiques avec `GENERATED ALWAYS AS IDENTITY`.**
4. **J’ai nommé explicitement toutes les contraintes pour rendre le schéma professionnel et lisible.**
5. **J’ai renforcé l’intégrité avec des `NOT NULL`, `UNIQUE`, `CHECK` et `FOREIGN KEY`.**
6. **J’ai ajouté `ON DELETE CASCADE` dans les tables d’association pour éviter les enregistrements orphelins.**
7. **J’ai ajouté des index sur les clés étrangères et des commentaires de documentation pour améliorer la qualité globale.**

---

## 17. Limites ou évolutions possibles à mentionner si on te pose la question

Si l’enseignant veut aller plus loin, tu peux dire que le schéma pourrait évoluer avec :

- des tables de référence pour les statuts et types ;
- des triggers métier plus avancés ;
- des vues pour simplifier les requêtes applicatives ;
- des scripts d’insertion de données de test ;
- des procédures stockées pour gérer la réservation ou la maintenance.

Cela montre que tu comprends la différence entre :

- la structure de base bien conçue ;
- et les évolutions possibles d’un système plus complet.

---

## 18. Conclusion

Le script produit un schéma Oracle :

- fonctionnel ;
- propre ;
- réexécutable ;
- cohérent avec le MCD ;
- enrichi par de vraies règles d’intégrité ;
- adapté à une démonstration académique sérieuse.

Autrement dit, ce n’est pas seulement un script "qui crée des tables" : c’est un **schéma défendable techniquement** et **présentable proprement**.

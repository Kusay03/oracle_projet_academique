# Guide des 30 requêtes de soutenance

Ce fichier accompagne `requetes_soutenance_oracle.sql`.  
Le but est de t’aider à expliquer rapidement pourquoi chaque requête a du sens dans un cours de base de données relationnelle.

## Logique pédagogique

Les 30 requêtes couvrent les familles classiques suivantes :

1. sélection et projection
2. filtrage avec `WHERE`
3. tri avec `ORDER BY`
4. jointures `JOIN` et `LEFT JOIN`
5. agrégations `COUNT`, `SUM`, `AVG`
6. regroupement `GROUP BY`
7. filtrage de groupes avec `HAVING`
8. sous-requêtes simples
9. sous-requêtes corrélées avec `EXISTS` et `NOT EXISTS`
10. opérateurs ensemblistes `INTERSECT` et `MINUS`
11. classement avec fonctions analytiques
12. logique conditionnelle avec `CASE`

## Lecture rapide des 30 requêtes

1. Liste complète des membres.
2. Filtrage des membres de type étudiant.
3. Machines disponibles.
4. Projets en cours.
5. Réservations confirmées avec jointure entre trois tables.
6. Événements et administrateurs organisateurs.
7. Matériel en stock faible.
8. Nombre de membres par type.
9. Nombre de machines par état.
10. Nombre de participants par événement, y compris zéro participant.
11. Nombre de membres par projet.
12. Fournisseurs et matériels fournis.
13. Membres sans réservation.
14. Machines jamais réservées.
15. Administrateurs ayant organisé au moins un événement.
16. Projet avec le plus de membres.
17. Quantité totale consommée par projet.
18. Stock moyen par unité.
19. Consommations supérieures à la moyenne.
20. Événements au-dessus de la moyenne de participation.
21. Membres actifs à la fois dans les événements et les projets.
22. Membres présents dans les événements mais absents des projets.
23. Membres ayant réservé une machine précise.
24. Historique détaillé des maintenances.
25. Nombre de logs par membre.
26. Classement des projets avec `RANK`.
27. Classement des événements avec `DENSE_RANK`.
28. Intersection entre participants aux événements et réservataires.
29. Différence ensembliste entre réalisateurs de projets et participants.
30. Classification métier du stock avec `CASE`.

## Conseils pour la soutenance

- Ne montre pas forcément les 30 en une seule fois.
- Sélectionne 8 à 12 requêtes représentatives pour l’oral.
- Garde les autres comme réserve si l’enseignant demande plus de profondeur.

## Bon enchaînement pour la démonstration

Tu peux suivre cet ordre :

1. commencer par les requêtes simples : 1, 2, 3, 4
2. enchaîner avec les jointures : 5, 6, 12, 24
3. montrer les agrégations : 8, 9, 10, 11, 17, 18
4. terminer avec les sous-requêtes et opérateurs avancés : 13, 14, 15, 19, 20, 28, 29, 30

## Point important à dire à l’oral

Le jeu de requêtes n’est pas aléatoire.  
Il a été construit pour montrer que le schéma relationnel permet :

- de consulter les données,
- de croiser les entités,
- de produire des indicateurs,
- de détecter des absences de relation,
- et d’exprimer des besoins métier réalistes.

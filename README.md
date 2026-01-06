# Projet SQL B2 - Gestion de Flotte de Vélos Partagés

Système de gestion de locations de véhicules électriques partagés (Vélib) développé dans le cadre d'un projet SQL avancé.

## 📋 Description

Ce projet implémente une base de données complète pour gérer une flotte de vélos partagés, incluant :
- Gestion des stations et véhicules
- Suivi des réservations clients
- Système de maintenance et pannes
- Vues analytiques pour le monitoring

## 🗂️ Structure du Projet

```
├── data/                                    # Données sources (CSV)
│   ├── velib-disponibilite-en-temps-reel.csv
│   └── velib-emplacement-des-stations.csv
├── sql/                                     # Scripts SQL
│   ├── 00_init_db.sql                      # Initialisation DB
│   ├── 10_create_tables_flotte.sql         # Tables flotte
│   ├── 11_create_tables_clients.sql        # Tables clients
│   ├── 12_create_tables_maintenance.sql    # Tables maintenance
│   ├── 13_triggers_maintenance.sql         # Automatismes
│   ├── 20_insert_data_flotte.sql          # Import données flotte
│   ├── 21_insert_data_clients.sql         # Import données clients
│   ├── 22_insert_data_maintenance.sql     # Import données maintenance
│   ├── 30_views_flotte.sql                # Vues analytiques
│   └── 99_queries.sql                      # Requêtes métier
├── install.bat                             # Installation Windows
├── install.sh                              # Installation Linux/Mac
└── README.md
```

## 🚀 Installation

### Prérequis
- PostgreSQL 12+
- Accès utilisateur `postgres` avec droits de création de base

### Windows
```batch
install.bat
```

### Linux/Mac
```bash
chmod +x install.sh
./install.sh
```

Le script effectue :
1. Réinitialisation de la base `projet_flotte`
2. Création des tables (flotte, clients, maintenance)
3. Import des données CSV
4. Création des triggers
5. Création des vues analytiques

## 📊 Modèle de Données

### Tables Principales

#### Flotte
- `type_vehicule` : Types de vélos (mécanique/électrique)
- `station` : Stations Vélib
- `vehicule` : Vélos individuels

#### Clients
- `client` : Utilisateurs
- `reservation` : Locations
- `paiement` : Transactions

#### Maintenance
- `technicien` : Personnel technique
- `panne` : Signalements
- `intervention` : Réparations

## 🔍 Vues Analytiques

### `v_vehicules_disponibles`
Vélos disponibles à la location (batterie ≥ 50%)

### `v_stats_stations`
Statistiques par station :
- Taux de remplissage
- Nombre de vélos par type
- Capacité disponible

### `v_maintenance_urgence`
Alertes maintenance :
- Vélos en panne
- Batterie < 20%
- Actions requises

## 📈 Requêtes Métier

Le fichier `sql/99_queries.sql` contient :

- **Fonction de calcul** : `calculer_prix_course` - Tarification des trajets
- **Top clients** : Clients avec le plus de trajets
- **Revenus totaux** : Somme des paiements
- **Véhicules fragiles** : Historique des pannes
- **Productivité techniciens** : Nombre d'interventions
- **État de la flotte** : Véhicules immobilisés

## 🛠️ Configuration

### Paramètres par défaut
- **Base** : `projet_flotte`
- **Utilisateur** : `postgres`
- **Mot de passe** : `postgres`

Pour modifier, éditez `install.bat` ou `install.sh`.

## 📝 Données

Les données sources proviennent de :
- `data/velib-emplacement-des-stations.csv` : Localisation des stations
- `data/velib-disponibilite-en-temps-reel.csv` : État temps réel de la flotte

Import automatisé dans `sql/20_insert_data_flotte.sql`.

## 👥 Contributeurs

Projet développé par l'équipe B2 :
- **Matteo** : Partie gestion flotte
- **Thibaud** : Partie clients/réservations  
- **Raphaël** : Partie maintenance

## 📄 Licence

Projet éducatif - Cours SQL Avancé B2

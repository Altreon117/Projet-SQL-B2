#!/bin/bash

DB_NAME="projet_flotte"
DB_USER="postgres"

export PGPASSWORD="postgres"

echo "🚀 Lancement de l'installation..."

echo "---------------------------------------"
echo "1. Réinitialisation de la Base de Données..."
psql -U $DB_USER -f sql/00_init_db.sql

echo "---------------------------------------"
echo "2. Création des tables..."
psql -U $DB_USER -d $DB_NAME -f sql/10_create_tables_flotte.sql
psql -U $DB_USER -d $DB_NAME -f sql/11_create_tables_clients.sql
psql -U $DB_USER -d $DB_NAME -f sql/12_create_tables_maintenance.sql

echo "---------------------------------------"
echo "3. Import des données (CSV + Génération)..."
psql -U $DB_USER -d $DB_NAME -f sql/20_insert_data_flotte.sql
psql -U $DB_USER -d $DB_NAME -f sql/21_insert_data_clients.sql
psql -U $DB_USER -d $DB_NAME -f sql/22_insert_data_maintenance.sql

echo "---------------------------------------"
echo "4. Création des Automatismes (Triggers)..."
psql -U $DB_USER -d $DB_NAME -f sql/13_triggers_maintenance.sql

echo "---------------------------------------"
echo "5. Création des Vues (Mission 3)..."
psql -U $DB_USER -d $DB_NAME -f sql/30_views_flotte.sql
psql -U $DB_USER -d $DB_NAME -f sql/99_queries.sql

echo "---------------------------------------"
echo "✅ Installation terminée avec succès !"

read -p "Appuie sur une touche pour quitter..."

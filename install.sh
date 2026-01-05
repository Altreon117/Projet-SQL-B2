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

echo "---------------------------------------"
echo "3. Import des données (CSV + Génération)..."
psql -U $DB_USER -d $DB_NAME -f sql/20_insert_data_flotte.sql
psql -U $DB_USER -d $DB_NAME -f sql/13_create_tables_technicien.sql
psql -U $DB_USER -d $DB_NAME -f sql/14_create_tables_panne.sql
psql -U $DB_USER -d $DB_NAME -f sql/15_create_tables_intervention.sql

echo "---------------------------------------"
echo "4. Création des Vues (Mission 3)..."
psql -U $DB_USER -d $DB_NAME -f sql/30_views_flotte.sql

echo "---------------------------------------"
echo "✅ Installation terminée avec succès !"

read -p "Appuie sur une touche pour quitter..."
@echo off
chcp 65001 > nul
echo Lancement de l'installation...

set DB_NAME=projet_flotte
set USER=postgres
set PGPASSWORD=postgres

echo 1. Reset DB...
psql -U %USER% -f sql/00_init_db.sql

echo 2. Creation Tables (Flotte)...
psql -U %USER% -d %DB_NAME% -f sql/10_create_tables_flotte.sql

echo 3. Creation Tables (Maintenance : Technicien, Panne, Intervention)...
psql -U %USER% -d %DB_NAME% -f sql/13_create_tables_technicien.sql
psql -U %USER% -d %DB_NAME% -f sql/14_create_tables_panne.sql
psql -U %USER% -d %DB_NAME% -f sql/15_create_tables_intervention.sql

echo 4. Import Données...
psql -U %USER% -d %DB_NAME% -f sql/20_insert_data_flotte.sql

echo 5. Creation Vues...
psql -U %USER% -d %DB_NAME% -f sql/30_views_flotte.sql

echo Installation terminee !
pause
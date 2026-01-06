@echo off
chcp 65001 > nul
echo Lancement de l'installation...

set DB_NAME=projet_flotte
set USER=postgres
set PGPASSWORD=postgres

echo 1. Reset DB...
psql -U %USER% -f sql/00_init_db.sql

echo 2. Creation Tables...
psql -U %USER% -d %DB_NAME% -f sql/10_create_tables_flotte.sql
psql -U %USER% -d %DB_NAME% -f sql/11_create_tables_clients.sql
psql -U %USER% -d %DB_NAME% -f sql/12_create_tables_maintenance.sql

echo 3. Creation automatismes (Triggers)...
psql -U %USER% -d %DB_NAME% -f sql/13_triggers_maintenance.sql

echo 4. Import Données...
psql -U %USER% -d %DB_NAME% -f sql/20_insert_data_flotte.sql
psql -U %USER% -d %DB_NAME% -f sql/21_insert_data_clients.sql
psql -U %USER% -d %DB_NAME% -f sql/22_insert_data_maintenance.sql

echo 5. Creation Vues...
psql -U %USER% -d %DB_NAME% -f sql/30_views_flotte.sql
psql -U %USER% -d %DB_NAME% -f sql/99_queries.sql

echo Installation terminee !
pause
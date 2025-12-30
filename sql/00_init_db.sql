SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'projet_flotte'
  AND pid <> pg_backend_pid();

DROP DATABASE IF EXISTS projet_flotte;

CREATE DATABASE projet_flotte;
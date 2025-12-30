BEGIN;

DROP VIEW IF EXISTS v_maintenance_urgence CASCADE;
DROP VIEW IF EXISTS v_stats_stations CASCADE;
DROP VIEW IF EXISTS v_vehicules_disponibles CASCADE;

-- ==============================================================================
-- VUE 1 : LE "FINDER" CLIENT
-- On ne montre que les vélos disponibles avec > 50% de batterie.
-- ==============================================================================
CREATE OR REPLACE VIEW v_vehicules_disponibles AS
SELECT 
    v.matricule,
    t.libelle AS type_velo,
    v.niveau_batterie,
    s.nom AS station_actuelle,
    s.latitude,
    s.longitude
FROM vehicule v
JOIN station s ON v.id_station = s.id
JOIN type_vehicule t ON v.id_type = t.id
WHERE v.statut = 'DISPONIBLE'
  AND v.niveau_batterie >= 50;


-- ==============================================================================
-- VUE 2 : TABLEAU DE BORD "INFRASTRUCTURE"
-- Taux de remplissage en % et décompte par type de vélo.
-- ==============================================================================
CREATE OR REPLACE VIEW v_stats_stations AS
SELECT 
    s.id AS station_id,
    s.nom,
    s.capacite,
    COUNT(v.id) AS total_velos,
    
    ROUND((COUNT(v.id)::DECIMAL / NULLIF(s.capacite, 0)) * 100, 1) AS taux_remplissage_pct,
    
    SUM(CASE WHEN t.libelle LIKE '%Électrique%' THEN 1 ELSE 0 END) AS nb_electriques,
    SUM(CASE WHEN t.libelle LIKE '%Mécanique%' THEN 1 ELSE 0 END) AS nb_mecaniques

FROM station s
LEFT JOIN vehicule v ON s.id = v.id_station
LEFT JOIN type_vehicule t ON v.id_type = t.id
GROUP BY s.id, s.nom, s.capacite
ORDER BY taux_remplissage_pct DESC;


-- ==============================================================================
-- VUE 3 : ALERTE BATTERIE & MAINTENANCE
-- Vélos en dessous de 20% de batterie OU déclarés en panne.
-- ==============================================================================
CREATE OR REPLACE VIEW v_maintenance_urgence AS
SELECT 
    v.matricule,
    v.statut,
    v.niveau_batterie,
    s.nom AS localisation,
    CASE 
        WHEN v.statut = 'EN_PANNE' THEN 'Réparation requise'
        WHEN v.niveau_batterie < 20 THEN 'Recharge nécessaire'
        ELSE 'Contrôle routine'
    END AS action_requise
FROM vehicule v
LEFT JOIN station s ON v.id_station = s.id
WHERE v.statut IN ('EN_PANNE', 'MAINTENANCE') 
   OR v.niveau_batterie < 20;

COMMIT;
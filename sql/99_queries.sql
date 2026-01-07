--##### PARTIE MATTEO ###############################################

-- 1. Répartition de la flotte par type de véhicule
SELECT t.libelle AS type_vehicule, COUNT(v.id) as nombre_vehicules
FROM type_vehicule t
LEFT JOIN vehicule v ON t.id = v.id_type
GROUP BY t.libelle;

-- 2. Top 3 des stations avec le plus de véhicules disponibles
SELECT s.nom AS station_nom, COUNT(v.id) as nb_disponibles
FROM station s
JOIN vehicule v ON s.id = v.id_station
WHERE v.statut = 'DISPONIBLE'
GROUP BY s.nom
ORDER BY nb_disponibles DESC
LIMIT 3;

-- 3. Moyenne de batterie par type de véhicule (pour les véhicules électriques)
SELECT t.libelle AS type_vehicule, ROUND(AVG(v.niveau_batterie), 1) as batterie_moyenne
FROM vehicule v
JOIN type_vehicule t ON v.id_type = t.id
WHERE t.libelle LIKE '%Électrique%'
GROUP BY t.libelle;

-- 4. Taux d'occupation des stations (en %)
SELECT nom AS station_nom, capacite, 
       ROUND((SELECT COUNT(*) FROM vehicule WHERE id_station = s.id)::DECIMAL / NULLIF(capacite,0) * 100, 1) as taux_occupation
FROM station s
ORDER BY capacite DESC
LIMIT 50;


--##### PARTIE THIBAUD ###############################################

-- 1. Calculer le prix total d'une réservation en fonction de la durée
CREATE OR REPLACE FUNCTION calculer_prix_course(p_id_reservation INT, p_prix_minute DECIMAL) 
RETURNS DECIMAL AS $$
DECLARE
    v_minutes INT;
    v_prix_total DECIMAL(10,2);
BEGIN
    SELECT EXTRACT(EPOCH FROM (date_fin_reelle - date_debut)) / 60 
    INTO v_minutes
    FROM reservation
    WHERE id_reservation = p_id_reservation;

    IF v_minutes IS NULL THEN
        RETURN 0.00;
    END IF;

    v_prix_total := v_minutes * p_prix_minute;
    
    RETURN ROUND(v_prix_total, 2);
END;
$$ LANGUAGE plpgsql;

-- 2. Liste des réservations terminées avec leur prix total
SELECT id_reservation, statut, calculer_prix_course(id_reservation, 0.25) AS prix_final
FROM reservation    
WHERE statut = 'TERMINEE';

-- 3. Top 3 des clients les plus fidèles (nombre de trajets)
SELECT c.nom, c.prenom, COUNT(r.id_reservation) as total_trajets
FROM client c
JOIN reservation r ON c.id_client = r.id_client
GROUP BY c.id_client, c.nom, c.prenom
ORDER BY total_trajets DESC
LIMIT 3;

SELECT SUM(montant) as total_revenus_euros FROM paiement;


--##### PARTIE RAPHAEL ###############################################

-- Les véhicules les plus fragiles 
SELECT v.matricule, COUNT(p.id_panne) as total_pannes
FROM vehicule v
JOIN PANNE p ON v.id = p.id_vehicule
GROUP BY v.matricule
ORDER BY total_pannes DESC;

-- Nombre d'interventions
SELECT t.nom, t.prenom, COUNT(i.id_intervention) as nb_interventions
FROM TECHNICIEN t
LEFT JOIN INTERVENTION i ON t.id_technicien = i.id_technicien
GROUP BY t.id_technicien, t.nom, t.prenom;

-- 3. État actuel de la flotte immobilisée
SELECT statut, COUNT(*) as nb_vehicules
FROM vehicule
WHERE statut IN ('EN_PANNE', 'MAINTENANCE', 'HORS_SERVICE')
GROUP BY statut;
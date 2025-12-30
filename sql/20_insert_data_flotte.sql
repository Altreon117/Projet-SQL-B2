BEGIN;

INSERT INTO type_vehicule (id, libelle, vitesse_max_kmh, autonomie_moyen_km) VALUES
(1, 'Vélib Mécanique (Vert)', 25, 0),
(2, 'Vélib Électrique (Bleu)', 25, 50)
ON CONFLICT DO NOTHING;

CREATE TEMP TABLE temp_stations_import (
    identifiant BIGINT,
    nom TEXT,
    capacite INT,
    coordonnees TEXT,
    opening_hours TEXT
);

\copy temp_stations_import FROM 'data/velib-emplacement-des-stations.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8');

INSERT INTO station (id, nom, capacite, latitude, longitude)
SELECT 
    identifiant,
    nom,
    capacite,
    SPLIT_PART(coordonnees, ',', 1)::DECIMAL, 
    SPLIT_PART(coordonnees, ',', 2)::DECIMAL
FROM temp_stations_import
WHERE identifiant IS NOT NULL
ON CONFLICT (id) DO NOTHING;

CREATE TEMP TABLE temp_dispo_import (
    id_station BIGINT,
    nom_station TEXT,
    station_fonctionnement TEXT,
    capacite INT,
    bornettes_libres INT,
    total_velos INT,
    velos_meca INT,
    velos_elec INT,
    borne_paiement TEXT,
    retour_possible TEXT,
    actualisation TEXT,
    coordonnees TEXT,
    nom_communes TEXT,
    code_insee TEXT,
    opening_hours TEXT
);

\copy temp_dispo_import FROM 'data/velib-disponibilite-en-temps-reel.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8');

DO $$
DECLARE
    ligne RECORD;
    i INT;
BEGIN
    FOR ligne IN SELECT * FROM temp_dispo_import LOOP
        IF EXISTS (SELECT 1 FROM station WHERE id = ligne.id_station) THEN
            
            IF ligne.velos_meca > 0 THEN
                FOR i IN 1..ligne.velos_meca LOOP
                    INSERT INTO vehicule (matricule, id_type, id_station, niveau_batterie, statut)
                    VALUES ('MEC-' || ligne.id_station || '-' || i, 1, ligne.id_station, 100, 'DISPONIBLE')
                    ON CONFLICT DO NOTHING;
                END LOOP;
            END IF;

            IF ligne.velos_elec > 0 THEN
                FOR i IN 1..ligne.velos_elec LOOP
                    INSERT INTO vehicule (matricule, id_type, id_station, niveau_batterie, statut)
                    VALUES ('EL-' || ligne.id_station || '-' || i, 2, ligne.id_station, floor(random()*80+20)::int, 'DISPONIBLE')
                    ON CONFLICT DO NOTHING;
                END LOOP;
            END IF;
            
        END IF;
    END LOOP;
END $$;

DROP TABLE temp_stations_import;
DROP TABLE temp_dispo_import;

COMMIT;
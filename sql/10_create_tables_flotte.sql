BEGIN;

DROP TABLE IF EXISTS vehicule CASCADE;
DROP TABLE IF EXISTS station CASCADE;
DROP TABLE IF EXISTS type_vehicule CASCADE;

CREATE TABLE type_vehicule (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL,
    vitesse_max_kmh INT,
    autonomie_moyen_km INT
);

CREATE TABLE station (
    id BIGINT PRIMARY KEY,          
    nom VARCHAR(255) NOT NULL,
    capacite INT NOT NULL DEFAULT 0,
    latitude DECIMAL(15,12) NOT NULL,
    longitude DECIMAL(15,12) NOT NULL
);

CREATE TABLE vehicule (
    id SERIAL PRIMARY KEY,
    
    matricule VARCHAR(50) UNIQUE NOT NULL,
    
    niveau_batterie INT NOT NULL DEFAULT 100 CHECK (niveau_batterie BETWEEN 0 AND 100),
    
    statut VARCHAR(20) NOT NULL DEFAULT 'DISPONIBLE' 
        CHECK (statut IN ('DISPONIBLE', 'INDISPONIBLE', 'MAINTENANCE', 'EN_PANNE', 'HORS_SERVICE')),
    
    date_mise_en_service DATE DEFAULT CURRENT_DATE,
    
    id_type INT NOT NULL REFERENCES type_vehicule(id),
    
    id_station BIGINT REFERENCES station(id)
);

COMMIT;
DROP TABLE IF EXISTS paiement CASCADE;
DROP TABLE IF EXISTS reservation CASCADE;
DROP TABLE IF EXISTS client CASCADE;

CREATE TABLE client (
    id_client SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telephone VARCHAR(20),
    date_inscription DATE DEFAULT CURRENT_DATE
);

CREATE TABLE reservation (
    id_reservation SERIAL PRIMARY KEY,
    date_debut TIMESTAMP NOT NULL,
    date_fin_reelle TIMESTAMP,
    statut VARCHAR(20) CHECK (statut IN ('PLANIFIEE', 'EN_COURS', 'TERMINEE', 'ANNULEE')),
    

    id_client INT NOT NULL,
    id_vehicule INT NOT NULL, 
    
   
    CONSTRAINT fk_client FOREIGN KEY (id_client) REFERENCES client(id_client) ON DELETE CASCADE,
    
    
    CONSTRAINT fk_vehicule_flotte FOREIGN KEY (id_vehicule) REFERENCES flotte(id_vehicule),

    CONSTRAINT check_dates CHECK (date_fin_reelle > date_debut)
);


CREATE TABLE paiement (
    id_paiement SERIAL PRIMARY KEY,
    montant DECIMAL(10, 2) NOT NULL CHECK (montant > 0),
    date_paiement TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    methode_paiement VARCHAR(20) CHECK (methode_paiement IN ('CB', 'PAYPAL', 'VIREMENT')),
    
    id_reservation INT NOT NULL,
    CONSTRAINT fk_reservation_paiement FOREIGN KEY (id_reservation) REFERENCES reservation(id_reservation)
);
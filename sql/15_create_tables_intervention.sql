CREATE TABLE INTERVENTION (
    id_intervention SERIAL PRIMARY KEY,
    date_intervention DATE,
    id_technicien INT REFERENCES TECHNICIEN(id_technicien),
    id_panne INT REFERENCES PANNE(id_panne),
	id_vehicule INT REFERENCES VEHICULE(id)
);
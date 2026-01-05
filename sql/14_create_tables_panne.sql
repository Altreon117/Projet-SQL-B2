CREATE TABLE PANNE (
    id_panne SERIAL PRIMARY KEY,
    description TEXT,
    date_signalement DATE DEFAULT CURRENT_DATE,
    severite VARCHAR(20) CHECK (severite IN ('FAIBLE', 'MOYENNE', 'CRITIQUE')),
    id_vehicule INT REFERENCES VEHICULE(id)
);
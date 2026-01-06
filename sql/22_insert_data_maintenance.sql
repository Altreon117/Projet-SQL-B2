BEGIN;

INSERT INTO TECHNICIEN (nom, prenom, specialite) VALUES
('Leclerc', 'Marc', 'Électronique'),
('Garnier', 'Sophie', 'Mécanique');

INSERT INTO PANNE (description, severite, id_vehicule) 
VALUES ('Problème de déverrouillage électronique', 'CRITIQUE', 1);

INSERT INTO INTERVENTION (date_intervention, id_technicien, id_panne, id_vehicule)
VALUES (CURRENT_DATE, 1, (SELECT MAX(id_panne) FROM PANNE), 1);

COMMIT;
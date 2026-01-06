INSERT INTO client (nom, prenom, email, telephone) VALUES
('Phan', 'Raphael', 'raph.p@mail.com', '0666666666'),
('Tabard', 'Thibaud', 'thib.t@mail.com', '0777777777'),
('Petronelli', 'Matteo', 'matteo.p@mail.com', '0888888888');


INSERT INTO reservation (date_debut, date_fin_reelle, statut, id_client, id_vehicule) VALUES
('2025-06-01 14:00:00', '2025-06-01 14:30:00', 'TERMINEE', 1, 1), 
('2025-06-02 09:00:00', '2025-06-02 10:00:00', 'TERMINEE', 2, 2), 
('2025-06-03 08:30:00', '2025-06-03 08:45:00', 'TERMINEE', 1, 3), 
('2025-06-04 18:00:00', NULL, 'EN_COURS', 3, 1);


INSERT INTO paiement (montant, methode_paiement, id_reservation) VALUES
(7.50, 'CB', 1),
(15.00, 'PAYPAL', 2),
(3.75, 'CB', 3);
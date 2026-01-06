--##### PARTIE MATTEO ###############################################




--##### PARTIE THIBAUD ###############################################

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

SELECT id_reservation, statut, calculer_prix_course(id_reservation, 0.25) AS prix_final
FROM reservation
WHERE statut = 'TERMINEE';

SELECT c.nom, c.prenom, COUNT(r.id_reservation) as total_trajets
FROM client c
JOIN reservation r ON c.id_client = r.id_client
GROUP BY c.id_client, c.nom, c.prenom
ORDER BY total_trajets DESC
LIMIT 3;

SELECT SUM(montant) as total_revenus_euros FROM paiement;


--##### PARTIE RAPHAEL ###############################################
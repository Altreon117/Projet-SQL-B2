-- fonction du trigger 1 : Mettre un véhicule en panne après création d'une panne (dans la table PANNE)
CREATE OR REPLACE FUNCTION fn_declencher_panne()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE vehicule 
    SET statut = 'EN_PANNE' 
    WHERE id = NEW.id_vehicule;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- trigger 1 : Après insertion d'une panne, déclencher la fonction pour mettre le véhicule en panne
CREATE OR REPLACE TRIGGER trg_apres_signalement_panne
AFTER INSERT ON PANNE
FOR EACH ROW
EXECUTE FUNCTION fn_declencher_panne();

-- 2. Fonction : Retour auto vers 'DISPONIBLE' après réparation (dans la table INTERVENTION)
CREATE OR REPLACE FUNCTION fn_cloturer_intervention()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE vehicule 
    SET statut = 'DISPONIBLE', niveau_batterie = 100
    WHERE id = NEW.id_vehicule;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- trigger 2 : Après insertion d'une intervention, déclencher la fonction pour remettre le véhicule disponible
CREATE OR REPLACE TRIGGER trg_apres_intervention
AFTER INSERT ON INTERVENTION
FOR EACH ROW
EXECUTE FUNCTION fn_cloturer_intervention();
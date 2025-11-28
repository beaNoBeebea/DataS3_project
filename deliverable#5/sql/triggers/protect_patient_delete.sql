DELIMITER $$
CREATE TRIGGER patient_delete
BEFORE DELETE
ON Patient
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM ClinicalActivity WHERE IID = OLD.IID) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: reassign or delete dependent activities before deleting a Patient';
    END IF;
END$$
DELIMITER ;
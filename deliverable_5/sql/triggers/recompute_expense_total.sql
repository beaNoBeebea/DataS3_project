--Recompute Expense.Total when prescription lines change.
--trigger for insertions
DELIMITER $$
CREATE TRIGGER Expense_total_insert
AFTER INSERT ON Include_Medication
FOR EACH ROW
BEGIN
DECLARE new_total DECIMAL(10,2); -- declare the variable in which we'll put the total expense

-- if the price of any medication is missing we raise an error and do not compute de total

IF -- we check if the medication UPDATED doesn't have a unitprice in stock 
    (SELECT S.UnitPrice
    FROM Prescription P
    JOIN ClinicalActivity CA  ON CA.CAID = P.CAID
    JOIN Department D ON D.DEP_ID = CA.DEP_ID
    JOIN Stock S ON S.MID = NEW.MID AND S.HID = D.HID
    WHERE P.PID=NEW.PID ) IS NULL THEN 
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Price for medication is missing';
ELSE
    
    SELECT SUM(UnitPrice) INTO new_total
    FROM  Include_medication I JOIN Prescription P ON P.PID = I.PID
    JOIN ClinicalActivity CA  ON CA.CAID = P.CAID
    JOIN Department D ON D.DEP_ID = CA.DEP_ID
    JOIN Stock S ON S.MID = I.MID AND S.HID = D.HID
    WHERE P.PID=NEW.PID; -- we want all of the medication in the prescription 
        
    -- updating the expense of the medication added to the prescription
    UPDATE Expense
    SET total=new_total
    WHERE CAID=(SELECT CAID FROM PrescriPtion P WHERE P.PID=NEW.PID); -- here we are navigating throught the relations to find the corresponding expense row to the new medication added in the precription
END IF;
 
END$$
DELIMITER ;



-- trigger for updates
DELIMITER $$
CREATE TRIGGER Expense_total_update
AFTER UPDATE ON Include_Medication
FOR EACH ROW
BEGIN
DECLARE new_total DECIMAL(10,2); -- declare the variable in which we'll put the total expense
DECLARE new_total_OLD_PRESCRIPTION DECIMAL(10,2); -- IN CASE WHERE WE UPDATE PRESCRIPTION, WE NEED TO UPDATE THE EXPENSE TOTAL FOR THE NEW AND OLD ONE
DECLARE new_total_NEW_PRESCRIPTION DECIMAL(10,2);

-- if the price of any medication is missing we raise an error and do not compute de total

IF -- we check if the medication inserted has a unitprice in stock 
    (SELECT S.UnitPrice
    FROM Prescription P
    JOIN ClinicalActivity CA  ON CA.CAID = P.CAID
    JOIN Department D ON D.DEP_ID = CA.DEP_ID
    JOIN Stock S ON S.MID = NEW.MID AND S.HID = D.HID
    WHERE P.PID=NEW.PID ) IS NULL THEN 
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Price for medication is missing';
ELSE
    -- now, if NEW.PID is different from OLD.PID, then we need to compute the total for both prescriptions, and if the PID did not change and it was only the medication that did, we only update for one prescription
    IF NEW.PID=OLD.PID THEN 
        -- WE ONLY CALCULATE THE SUM AFTER ADDING THE NEW MEDICATION (IT'S THE SAME PRESCRIPTION)
        SELECT SUM(UnitPrice) INTO new_total
        FROM  Include_medication I JOIN Prescription P ON P.PID = I.PID
        JOIN ClinicalActivity CA  ON CA.CAID = P.CAID
        JOIN Department D ON D.DEP_ID = CA.DEP_ID
        JOIN Stock S ON S.MID = I.MID AND S.HID = D.HID
        WHERE P.PID=NEW.PID; -- we want all of the medication in the prescription 

        -- updating the expense of the medication added to the prescription
        UPDATE Expense
        SET total=new_total
        WHERE CAID=(SELECT CAID FROM PrescriPtion P WHERE P.PID=NEW.PID);

    ELSE -- IF THE PRESCRIPTION CHANGED

    -- WE GET EXPENSE TOTAL FOR OLD.PID
    -- COALESCE() SOLVES THE PROBLEM: IF THE PRESCRIPTION BECOMES EMPTY IE: SUM(NULL), IT RETURN 0 INSTEAD OF NULL
    SELECT COALESCE(SUM(UnitPrice),0) INTO new_total_OLD_PRESCRIPTION 
    FROM  Include_medication I JOIN Prescription P ON P.PID = I.PID
    JOIN ClinicalActivity CA  ON CA.CAID = P.CAID
    JOIN Department D ON D.DEP_ID = CA.DEP_ID
    JOIN Stock S ON S.MID = I.MID AND S.HID = D.HID
    WHERE P.PID=OLD.PID;

    -- UPDATE EXPENSE FOR THE OLD PRESCRIPTION:
    UPDATE Expense
    SET total=new_total_OLD_PRESCRIPTION
    WHERE CAID=(SELECT CAID FROM PrescriPtion P WHERE P.PID=OLD.PID);

   -- WE GET EXPENSE TOTAL FOR NEW.PID
    SELECT SUM(UnitPrice) INTO new_total_NEW_PRESCRIPTION
    FROM  Include_medication I JOIN Prescription P ON P.PID = I.PID
    JOIN ClinicalActivity CA  ON CA.CAID = P.CAID
    JOIN Department D ON D.DEP_ID = CA.DEP_ID
    JOIN Stock S ON S.MID = I.MID AND S.HID = D.HID
    WHERE P.PID=NEW.PID;

    -- UPDATE EXPENSE FOR THE NEW PRESCRITION
    UPDATE Expense
    SET total=new_total_NEW_PRESCRIPTION
    WHERE CAID=(SELECT CAID FROM PrescriPtion P WHERE P.PID=NEW.PID);

    END IF;
END IF;

END$$

DELIMITER ;

--trigger for deletes
DELIMITER $$
CREATE TRIGGER Expense_total_delete
AFTER DELETE ON Include_Medication
FOR EACH ROW
BEGIN
DECLARE new_total DECIMAL(10,2); -- declare the variable in which we'll put the total expense
-- in the delete trigger we don't need to check if any medication is missing because we only delete womething that already did not have an issue in it
-- WE ONLY NEED TO UPDATE THE EXPENSE FOR THE PRESCRIPTION AFTER REMOVING THE MODIFICATION
SELECT COALESCE(SUM(UnitPrice),0) INTO new_total 
FROM  Include_medication I JOIN Prescription P ON P.PID = I.PID
JOIN ClinicalActivity CA  ON CA.CAID = P.CAID
JOIN Department D ON D.DEP_ID = CA.DEP_ID
JOIN Stock S ON S.MID = I.MID AND S.HID = D.HID
WHERE I.PID=OLD.PID; -- we want all of the medication in the prescription 
    
-- updating the expense of the medication added to the prescription
UPDATE Expense
SET total=new_total
WHERE CAID=(SELECT CAID FROM PrescriPtion P WHERE P.PID=OLD.PID); -- here we are navigating throught the relations to find the corresponding expense row to the precription


END$$
DELIMITER ;




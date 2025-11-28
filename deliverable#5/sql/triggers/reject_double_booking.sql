DELIMITER $$

CREATE TRIGGER reject_double_booking_insert
BEFORE INSERT ON ClinicalActivity
FOR EACH ROW 
BEGIN
	DECLARE existing_count INT;
    SELECT COUNT(*) INTO existing_count
    FROM ClinicalActivity 
    WHERE STAFF_ID = New.STAFF_ID
		AND Date = New.Date
        AND Time = New.Time;
        
	IF existing_count > 0 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'INSERT: The staff member has already an appointement scheduled at the same date and time of insertion.';
	END IF;
END$$

DELIMITER ;



DELIMITER $$

CREATE TRIGGER reject_double_booking_update
BEFORE UPDATE ON ClinicalActivity
FOR EACH ROW 
BEGIN
	DECLARE existing_count INT;
    
    IF (NEW.Date != OLD.Date OR NEW.Time != OLD.Time OR NEW.STAFF_ID != OLD.STAFF_ID) 
    THEN 
		SELECT COUNT(*) INTO existing_count
		FROM ClinicalActivity 
		WHERE STAFF_ID = New.STAFF_ID
			AND Date = New.Date
			AND Time = New.Time
			AND CAID != OLD.CAID;
			
		IF existing_count > 0 THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'UPDATE: The staff member has already an appointement scheduled at the same date and time of update.';
		END IF;
	END IF;
END$$

DELIMITER ;
--  ---------------------
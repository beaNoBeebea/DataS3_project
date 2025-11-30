DELIMITER $$

DROP TRIGGER IF EXISTS reject_double_booking_insert $$

CREATE TRIGGER reject_double_booking_insert
BEFORE INSERT ON ClinicalActivity
FOR EACH ROW 
BEGIN
    DECLARE existing_count INT;

    SELECT COUNT(*) INTO existing_count
    FROM ClinicalActivity 
    WHERE STAFF_ID = NEW.STAFF_ID
      AND `Date`   = NEW.`Date`
      AND `Time`   = NEW.`Time`;

    IF existing_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'INSERT: The staff member has already an appointement scheduled at the same date and time of insertion.';
    END IF;
END$$

DELIMITER ;



DELIMITER $$

DROP TRIGGER IF EXISTS reject_double_booking_update $$

CREATE TRIGGER reject_double_booking_update
BEFORE UPDATE ON ClinicalActivity
FOR EACH ROW 
BEGIN
    DECLARE existing_count INT;
    
    -- Only check if date/time/staff actually changed
    IF (NEW.`Date` <> OLD.`Date`
        OR NEW.`Time` <> OLD.`Time`
        OR NEW.STAFF_ID <> OLD.STAFF_ID) 
    THEN 
        SELECT COUNT(*) INTO existing_count
        FROM ClinicalActivity 
        WHERE STAFF_ID = NEW.STAFF_ID
          AND `Date`   = NEW.`Date`
          AND `Time`   = NEW.`Time`
          AND CAID    <> OLD.CAID;  -- ignore the same row being updated
			
        IF existing_count > 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'UPDATE: The staff member has already an appointment scheduled at the same date and time of update.';
        END IF;
    END IF;
END$$

DELIMITER ;

--  ---------------------
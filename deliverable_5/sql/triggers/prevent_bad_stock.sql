DROP TRIGGER IF EXISTS check_stock_ins;
DROP TRIGGER IF EXISTS check_stock_upd;


DELIMITER $$

CREATE TRIGGER check_stock_ins
BEFORE INSERT ON Stock
FOR EACH ROW
BEGIN 
    IF NEW.Qty < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Quantity invalid.';
    ELSEIF NEW.UnitPrice <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Price invalid.';
    ELSEIF NEW.ReorderLevel < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'ReorderLevel invalid.';
    END IF;
END$$

DELIMITER ;

    
DELIMITER $$
        CREATE TRIGGER check_stock_upd BEFORE UPDATE ON Stock
        For each row
        BEGIN 
            IF new.Qty < 0 THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Quantity invalid.';
            ELSEIF new.UnitPrice <= 0 THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Price invalid.';
            ELSEIF new.ReorderLevel < 0 THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'ReorderLevel invalid.';
            END IF;
        END$$

DELIMITER ;
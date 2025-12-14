DELIMITER //

CREATE PROCEDURE PopulateClinicalData(IN n INT)
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= n DO
        -- 1. Insert into ClinicalActivity
        -- We manually assign 'i' as the CAID
        INSERT INTO ClinicalActivity (CAID, IID, STAFF_ID, DEP_ID, Date, Time)
        VALUES (
            i,                                  -- Manual CAID
            FLOOR(1 + RAND() * 1000),           -- Random Patient IID (1-1000)
            FLOOR(1 + RAND() * 100),            -- Random Staff ID (1-100)
            FLOOR(1 + RAND() * 50),             -- Random Dept ID (1-50)
            -- Random date between 2020 and 2025
            DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND() * 365 * 5) DAY),
            -- Random Time 
            SEC_TO_TIME(FLOOR(RAND() * 86400))
        );

        -- 2. Insert into Appointment
        -- We use the same 'i' to ensure the foreign key link is correct
        INSERT INTO Appointment (CAID, Reason, Status)
        VALUES (
            i,
            CONCAT('Consultation Reason ', i),
            -- Random status for  indexing experiments
            ELT(1 + FLOOR(RAND() * 3), 'Scheduled', 'Completed', 'Cancelled')
        );

        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;
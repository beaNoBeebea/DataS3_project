-- ==========================================
-- 1. REJECT DOUBLE BOOKING TRIGGER
-- ==========================================

-- Test 1a: Try to INSERT conflicting appointment (SHOULD FAIL)
INSERT INTO ClinicalActivity (CAID, IID, STAFF_ID, DEP_ID, Date, Time)
VALUES (999001, 1001, 2001, 51, '2025-12-20', '10:00:00');

INSERT INTO Appointment (CAID, Reason, Status)
VALUES (999001, 'First appointment', 'Scheduled');

-- This should FAIL with error message
INSERT INTO ClinicalActivity (CAID, IID, STAFF_ID, DEP_ID, Date, Time)
VALUES (999002, 1002, 2001, 51, '2025-12-20', '10:00:00');
-- RESULT:
-- mysql> INSERT INTO ClinicalActivity (CAID, IID, STAFF_ID, DEP_ID, Date, Time)
--    -> VALUES (999002, 1002, 2001, 51, '2025-12-20', '10:00:00');
-- ERROR 1644 (45000): INSERT: The staff member has already an appointement scheduled at the same date and time of insertion.

-- Cleanup
DELETE FROM Appointment WHERE CAID = 999001;
DELETE FROM ClinicalActivity WHERE CAID = 999001;


-- Test 1b: Try to UPDATE to conflicting time (SHOULD FAIL)
INSERT INTO ClinicalActivity (CAID, IID, STAFF_ID, DEP_ID, Date, Time)
VALUES (999011, 1001, 2001, 51, '2025-12-20', '10:00:00');
INSERT INTO Appointment (CAID, Reason, Status)
VALUES (999011, 'Appointment A', 'Scheduled');

INSERT INTO ClinicalActivity (CAID, IID, STAFF_ID, DEP_ID, Date, Time)
VALUES (999012, 1002, 2001, 51, '2025-12-20', '14:00:00');
INSERT INTO Appointment (CAID, Reason, Status)
VALUES (999012, 'Appointment B', 'Scheduled');

-- This should FAIL
UPDATE ClinicalActivity
SET Time = '10:00:00'
WHERE CAID = 999012;
-- RESULT:
-- mysql> UPDATE ClinicalActivity
--    -> SET Time = '10:00:00'
--    -> WHERE CAID = 999012;
-- ERROR 1644 (45000): UPDATE: The staff member has already an appointment scheduled at the same date and time of update.

-- Cleanup
DELETE FROM Appointment WHERE CAID IN (999011, 999012);
DELETE FROM ClinicalActivity WHERE CAID IN (999011, 999012);


-- Test 1c: Valid operations (SHOULD SUCCEED)
-- Same staff, different times - OK
INSERT INTO ClinicalActivity (CAID, IID, STAFF_ID, DEP_ID, Date, Time)
VALUES (999021, 1001, 2001, 51, '2025-12-21', '10:00:00');
INSERT INTO Appointment (CAID, Reason, Status) 
VALUES (999021, 'Valid A', 'Scheduled');

INSERT INTO ClinicalActivity (CAID, IID, STAFF_ID, DEP_ID, Date, Time)
VALUES (999022, 1002, 2001, 51, '2025-12-21', '11:00:00');
INSERT INTO Appointment (CAID, Reason, Status) 
VALUES (999022, 'Valid B', 'Scheduled');

-- Different staff, same time - OK
INSERT INTO ClinicalActivity (CAID, IID, STAFF_ID, DEP_ID, Date, Time)
VALUES (999023, 1003, 2002, 52, '2025-12-21', '10:00:00');
INSERT INTO Appointment (CAID, Reason, Status) 
VALUES (999023, 'Valid C', 'Scheduled');

SELECT * FROM ClinicalActivity WHERE CAID IN (999021, 999022, 999023);
-- RESULT:
-- mysql> SELECT * FROM ClinicalActivity WHERE CAID IN (999021, 999022, 999023);
-- +--------+------+----------+--------+------------+----------+
-- | CAID   | IID  | STAFF_ID | DEP_ID | Date       | Time     |
-- +--------+------+----------+--------+------------+----------+
-- | 999021 | 1001 |     2001 |     51 | 2025-12-21 | 10:00:00 |
-- | 999022 | 1002 |     2001 |     51 | 2025-12-21 | 11:00:00 |
-- | 999023 | 1003 |     2002 |     52 | 2025-12-21 | 10:00:00 |
-- +--------+------+----------+--------+------------+----------+
-- 3 rows in set (0.000 sec)

-- Cleanup
DELETE FROM Appointment WHERE CAID IN (999021, 999022, 999023);
DELETE FROM ClinicalActivity WHERE CAID IN (999021, 999022, 999023);


-- ==========================================
-- 2. RECOMPUTE EXPENSE TOTAL TRIGGER
-- ==========================================

-- Test 2a: INSERT medications - total should auto-update
INSERT INTO ClinicalActivity (CAID, IID, STAFF_ID, DEP_ID, Date, Time)
VALUES (888001, 1001, 2001, 51, '2025-12-01', '09:00:00');

INSERT INTO Expense (CAID, Total)
VALUES (888001, 0.00);

INSERT INTO Prescription (PID, CAID)
VALUES (777001, 888001);

-- Check initial total
SELECT CAID, Total FROM Expense WHERE CAID = 888001;

-- Add first medication (Doliprane from Hospital 10 - Rabat)
INSERT INTO Include_Medication (PID, MID)
VALUES (777001, 3001);

-- Check updated total (should auto-increase to 1.45)
SELECT CAID, Total FROM Expense WHERE CAID = 888001;

-- Add second medication (Amlor from Hospital 10 - Rabat)
INSERT INTO Include_Medication (PID, MID)
VALUES (777001, 3004);

-- Check total again (should increase to 1.45 + 0.90 = 2.35)
SELECT CAID, Total FROM Expense WHERE CAID = 888001;

-- Cleanup
DELETE FROM Include_Medication WHERE PID = 777001;
DELETE FROM Prescription WHERE PID = 777001;
DELETE FROM Expense WHERE CAID = 888001;
DELETE FROM ClinicalActivity WHERE CAID = 888001;


-- Test 2b: DELETE medication - total should auto-decrease
INSERT INTO ClinicalActivity (CAID, IID, STAFF_ID, DEP_ID, Date, Time)
VALUES (888002, 1001, 2001, 51, '2025-12-01', '10:00:00');
INSERT INTO Expense (CAID, Total) VALUES (888002, 0.00);
INSERT INTO Prescription (PID, CAID) VALUES (777002, 888002);

-- Add three medications
INSERT INTO Include_Medication (PID, MID) VALUES (777002, 3001);
INSERT INTO Include_Medication (PID, MID) VALUES (777002, 3004);
INSERT INTO Include_Medication (PID, MID) VALUES (777002, 3008);

-- Check total with 3 medications (1.45 + 0.90 + 2.50 = 4.85)
SELECT CAID, Total FROM Expense WHERE CAID = 888002;

-- Delete one medication (Amlor - 0.90)
DELETE FROM Include_Medication WHERE PID = 777002 AND MID = 3004;

-- Check reduced total (should auto-decrease to 3.95)
SELECT CAID, Total FROM Expense WHERE CAID = 888002;

-- Cleanup
DELETE FROM Include_Medication WHERE PID = 777002;
DELETE FROM Prescription WHERE PID = 777002;
DELETE FROM Expense WHERE CAID = 888002;
DELETE FROM ClinicalActivity WHERE CAID = 888002;


-- Test 2c: Add medication without price (SHOULD FAIL)
INSERT INTO ClinicalActivity (CAID, IID, STAFF_ID, DEP_ID, Date, Time)
VALUES (888003, 1001, 2001, 51, '2025-12-01', '11:00:00');
INSERT INTO Expense (CAID, Total) VALUES (888003, 0.00);
INSERT INTO Prescription (PID, CAID) VALUES (777003, 888003);

-- This should FAIL (medication doesn't exist in stock for this hospital)
INSERT INTO Include_Medication (PID, MID) VALUES (777003, 99999);
-- Expected: Error - "Price for medication is missing"

-- Cleanup
DELETE FROM Prescription WHERE PID = 777003;
DELETE FROM Expense WHERE CAID = 888003;
DELETE FROM ClinicalActivity WHERE CAID = 888003;


-- ==========================================
-- 3. PREVENT BAD STOCK TRIGGER
-- ==========================================

-- Test 3a: Negative quantity (SHOULD FAIL)
INSERT INTO Stock (MID, HID, Qty, UnitPrice, ReorderLevel, StockTimestamp)
VALUES (3001, 10, -10, 15.00, 5, NOW());
-- RESULT:
-- mysql> INSERT INTO Stock (MID, HID, Qty, UnitPrice, ReorderLevel, StockTimestamp)
--     -> VALUES (3001, 10, -10, 15.00, 5, NOW());
-- ERROR 1644 (45000): Quantity invalid.


-- Test 3b: Zero/negative price (SHOULD FAIL)
INSERT INTO Stock (MID, HID, Qty, UnitPrice, ReorderLevel, StockTimestamp)
VALUES (3001, 10, 100, 0, 5, NOW());

INSERT INTO Stock (MID, HID, Qty, UnitPrice, ReorderLevel, StockTimestamp)
VALUES (3001, 10, 100, -5.00, 5, NOW());

-- Test 3c: Negative reorder level (SHOULD FAIL)
INSERT INTO Stock (MID, HID, Qty, UnitPrice, ReorderLevel, StockTimestamp)
VALUES (3001, 10, 100, 15.00, -5, NOW());

-- RESULT FOR ALL PREVIOUS 3:
-- ERROR 1644 (45000): Price invalid.

-- Test 3d: Valid stock operations (SHOULD SUCCEED)
INSERT INTO Stock (MID, HID, Qty, UnitPrice, ReorderLevel, StockTimestamp)
VALUES (3001, 10, 100, 25.50, 20, NOW());

SELECT * FROM Stock 
WHERE MID = 3001 AND HID = 10
ORDER BY StockTimestamp DESC LIMIT 1;

-- Valid update
UPDATE Stock
SET Qty = 150
WHERE MID = 3001 AND HID = 10
  AND StockTimestamp = (
    SELECT StockTimestamp FROM (
      SELECT StockTimestamp FROM Stock 
      WHERE MID = 3001 AND HID = 10 
      ORDER BY StockTimestamp DESC LIMIT 1
    ) AS temp
  );

SELECT * FROM Stock 
WHERE MID = 3001 AND HID = 10
ORDER BY StockTimestamp DESC LIMIT 1;

-- RESULT:
-- mysql> SELECT * FROM Stock 
--     -> WHERE MID = 3001 AND HID = 10
--     -> ORDER BY StockTimestamp DESC LIMIT 1;
-- +-----+------+---------------------+-----------+------+--------------+
-- | HID | MID  | StockTimestamp      | UnitPrice | Qty  | ReorderLevel |
-- +-----+------+---------------------+-----------+------+--------------+
-- |  10 | 3001 | 2025-11-30 11:47:37 |     25.50 |  150 |           20 |
-- +-----+------+---------------------+-----------+------+--------------+
-- 1 row in set (0.000 sec)


-- ==========================================
-- 4. PROTECT PATIENT DELETE TRIGGER
-- ==========================================

-- Test 4a: Try to delete patient WITH activities (SHOULD FAIL)
SELECT 
    P.IID,
    CONCAT(P.FirstName, ' ', P.LastName) AS FullName,
    COUNT(CA.CAID) AS ActivityCount
FROM Patient P
LEFT JOIN ClinicalActivity CA ON CA.IID = P.IID
WHERE P.IID = 1001
GROUP BY P.IID, P.FirstName, P.LastName;

-- This should FAIL
DELETE FROM Patient WHERE IID = 1001;
-- RESULT:
-- mysql> DELETE FROM Patient WHERE IID = 1001;
-- ERROR 1644 (45000): Error: reassign or delete dependent activities before deleting a Patient


-- Test 4b: Delete patient WITHOUT activities (SHOULD SUCCEED)
INSERT INTO Patient (IID, CIN, FirstName, LastName, Birth, Sex, BloodGroup, Phone)
VALUES (99999, 'TEST999', 'Test', 'Patient', '1990-01-01', 'M', 'O+', '0600000000');

-- Verify no activities
SELECT COUNT(*) AS ActivityCount
FROM ClinicalActivity
WHERE IID = 99999;

-- This should SUCCEED
DELETE FROM Patient WHERE IID = 99999;

-- Verify deletion
SELECT COUNT(*) AS PatientExists FROM Patient WHERE IID = 99999;

-- RESULT:
-- mysql> SELECT COUNT(*) AS PatientExists FROM Patient WHERE IID = 99999;
-- +---------------+
-- | PatientExists |
-- +---------------+
-- |             0 |
-- +---------------+
-- 1 row in set (0.000 sec)

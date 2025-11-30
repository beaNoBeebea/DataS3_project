USE MNHS;

-- ------------------------------
-- 1. Base Tables
-- ------------------------------

-- Hospital Data (3 major cities)
INSERT INTO Hospital (HID, Name, City, Region) VALUES
(10, 'Hôpital Ibn Sina', 'Rabat', 'Rabat-Salé-Kénitra'),
(20, 'Centre Hospitalier Universitaire (CHU) Casablanca', 'Casablanca', 'Casablanca-Settat'),
(30, 'Hôpital Privé Atlas', 'Marrakesh', 'Marrakesh-Safi');

-- Department Data (8 Departments across the hospitals)
INSERT INTO Department (DEP_ID, Name, Specialty, HID) VALUES
-- Rabat
(51, 'Cardiologie', 'Santé Cardiaque', 10),
(52, 'Pédiatrie', 'Soins Enfants', 10),
(53, 'Oncologie', 'Traitement du Cancer', 10),
-- Casablanca
(61, 'Urgences', 'Traumatologie & Soins Aigus', 20),
(62, 'Neurologie', 'Système Nerveux', 20),
-- Marrakesh
(71, 'Maternité', 'Obstétrique & Gynécologie', 30),
(72, 'Dermatologie', 'Peau et Allergies', 30);

-- Patient Data (20 records, Moroccan Names)
INSERT INTO Patient (IID, CIN, FirstName, LastName, Birth, Sex, BloodGroup, Phone) VALUES
(1001, 'MA9001', 'Fouad', 'El Idrissi', '1975-10-20', 'M', 'A+', '+21266101001'),
(1002, 'MB9002', 'Layla', 'Bennani', '1998-03-15', 'F', 'O-', '+21266101002'),
(1003, 'MC9003', 'Youssef', 'Alaoui', '1960-07-01', 'M', 'B+', '+21266101003'),
(1004, 'MD9004', 'Fatima', 'Zahra', '2010-12-25', 'F', 'AB+', '+21266101004'),
(1005, 'ME9005', 'Omar', 'Khatib', '1982-01-11', 'M', 'O+', '+21266101005'),
(1006, 'MF9006', 'Aisha', 'Amrani', '1955-05-30', 'F', 'A-', '+21266101006'),
(1007, 'MG9007', 'Reda', 'Sefrioui', '1995-09-02', 'M', 'B-', '+21266101007'),
(1008, 'MH9008', 'Nadia', 'Tazi', '1988-11-08', 'F', 'O+', '+21266101008'),
(1009, 'MI9009', 'Ali', 'Benali', '1970-04-17', 'M', 'AB-', '+21266101009'),
(1010, 'MJ9010', 'Samira', 'Cherkaoui', '1999-02-28', 'F', 'A+', '+21266101010'),
(1011, 'MK9011', 'Hamza', 'Kadiri', '2005-06-05', 'M', 'B+', '+21266101011'),
(1012, 'ML9012', 'Maha', 'Idrissi', '1981-08-14', 'F', 'O-', '+21266101012'),
(1013, 'MM9013', 'Karim', 'Fassi', '1968-12-03', 'M', 'A-', '+21266101013'),
(1014, 'MN9014', 'Salma', 'Boutayeb', '1993-01-22', 'F', 'O+', '+21266101014'),
(1015, 'MO9015', 'Nabil', 'Moussaoui', '1977-10-10', 'M', 'A+', '+21266101015'),
(1016, 'MP9016', 'Hiba', 'El Mansour', '1989-03-29', 'F', 'AB+', '+21266101016'),
(1017, 'MQ9017', 'Amine', 'Hassan', '2001-09-07', 'M', 'B+', '+21266101017'),
(1018, 'MR9018', 'Zineb', 'Rachidi', '1962-04-18', 'F', 'O-', '+21266101018'),
(1019, 'MS9019', 'Imane', 'Guessous', '1996-01-20', 'F', 'A-', '+21266101019'),
(1020, 'MT9020', 'Tariq', 'Benkirane', '1985-05-15', 'M', 'O+', '+21266101020');

-- Staff Data (15 records: 5 Practitioner, 5 Caregiving, 5 Technical)
INSERT INTO Staff (STAFF_ID, FullName, Status) VALUES
-- Practitioners (Doctors)
(2001, 'Dr. Samir Tazi', 'Active'),
(2002, 'Dr. Leila Benchekroun', 'Active'),
(2003, 'Dr. Hicham Alaoui', 'Active'),
(2004, 'Dr. Sanaa Mounir', 'Active'),
(2005, 'Dr. Younes El Fassi', 'Active'),
-- Caregiving (Nurses)
(2011, 'Nurse Fatima Zahra', 'Active'),
(2012, 'Nurse Rachid Amrani', 'Active'),
(2013, 'Nurse Malika Sefrioui', 'Active'),
(2014, 'Nurse Khalil Idrissi', 'Retired'), -- FIX: Changed 'Inact' to 'Retired' to match ENUM constraint.
(2015, 'Nurse Sofia El Moutawakil', 'Active'),
-- Technical (Admin/IT/Lab)
(2021, 'Admin Ali Tazi', 'Active'),
(2022, 'IT Amina Bennani', 'Active'),
(2023, 'Lab Technician Younes', 'Active'),
(2024, 'Admin Zineb Bounou', 'Active');

-- 5. Staff Sub-Tables
INSERT INTO Practitioner (STAFF_ID, License_Number, Specialty) VALUES
(2001, 'L1-001', 'Cardiology'),
(2002, 'L1-002', 'Pediatrics'),
(2003, 'L1-003', 'Emergency Medicine'),
(2004, 'L1-004', 'Neurology'),
(2005, 'L1-005', 'Oncology');

-- Note: Technical table requires 'Modality' and 'Certifications' columns as per schema,
-- but the original data insertion used 'Role' and 'Department_Type'.
-- I will use the columns available in the provided schema: Modality and Certifications,
-- assuming a mapping is acceptable for testing purposes.

INSERT INTO Caregiving (STAFF_ID, Grade, Ward) VALUES
(2011, 'RN-ICU', 'ICU'),
(2012, 'RN-PEDS', 'PEDIATRICS'),
(2013, 'LPN-ER', 'ER'),
(2014, 'RN-GEN', 'GENERAL'),
(2015, 'RN-ONCO', 'ONCOLOGY');

INSERT INTO Technical (STAFF_ID, Modality, Certifications) VALUES
(2021, 'Administration', 'Finance Cert'),
(2022, 'IT Support', 'CompTIA'),
(2023, 'Laboratory Technician', 'Lab Cert'),
(2024, 'Administration', 'HR Cert');


-- Work_In (Link Staff to Departments)
INSERT INTO Work_In (STAFF_ID, DEP_ID) VALUES
(2001, 51), (2001, 53), -- Dr. Samir works in Cardiology and Oncology
(2002, 52),
(2003, 61),
(2004, 62),
(2005, 53),
(2011, 51), (2011, 53), -- Nurse Fatima works in Cardiology and Oncology
(2012, 52),
(2013, 61),
(2015, 53),
(2021, 51), -- Admin Ali in Cardiology
(2024, 62); -- Admin Zineb in Neurology

-- Medication Data (8 drugs)
INSERT INTO Medication (MID, Name, Form, Strength, ActiveIngredient, TherapeuticClass, Manufacturer) VALUES
(3001, 'Doliprane', 'Comprimé', '1000mg', 'Paracétamol', 'Analgésique', 'Pharma Nord'),
(3002, 'Amoclan', 'Gélule', '500mg', 'Amoxicilline', 'Antibiotique', 'Sanofi Maroc'),
(3003, 'Ventoline', 'Inhalateur', '100mcg', 'Salbutamol', 'Bronchodilatateur', 'GlaxoSmithKline'),
(3004, 'Amlor', 'Comprimé', '5mg', 'Amlodipine', 'Antihypertenseur', 'Pfizer'),
(3005, 'Insuline Rapid', 'Injection', '100U/ml', 'Insuline', 'Antidiabétique', 'Novo Nordisk'),
(3006, 'Doxycycline', 'Comprimé', '100mg', 'Doxycycline', 'Tetracycline', 'Pharma Sud'),
(3007, 'Lipitor', 'Comprimé', '20mg', 'Atorvastatine', 'Statine', 'Pharma Nord'),
(3008, 'Profenid', 'Suppositoire', '100mg', 'Ketoprofène', 'AINS', 'Sanofi Maroc');


-- ------------------------------
-- 2. Stock Data for Pricing
-- ------------------------------

INSERT INTO Stock (HID, MID, StockTimestamp, Qty, UnitPrice, ReorderLevel) VALUES
-- Hospital 10 (Rabat)
(10, 3001, DATE(NOW() - INTERVAL 10 DAY), 100, 1.50, 20), -- Doliprane (Old Price)
(10, 3001, NOW(), 15, 1.45, 20), -- Doliprane (New Price, LOW STOCK: 15 < 20)
(10, 3004, NOW(), 500, 0.90, 50), -- Amlor
(10, 3005, NOW(), 20, 15.00, 30), -- Insuline (LOW STOCK: 20 < 30)
(10, 3008, NOW(), 300, 2.50, 100),

-- Hospital 20 (Casablanca)
(20, 3001, NOW(), 120, 1.60, 20), -- Doliprane
(20, 3004, NOW(), 450, 1.10, 50), -- Amlor
(20, 3002, NOW(), 10, 4.00, 15), -- Amoclan (LOW STOCK: 10 < 15)
(20, 3006, NOW(), 80, 5.50, 50),

-- Hospital 30 (Marrakesh)
(30, 3001, NOW(), 5, 1.55, 10), -- Doliprane (LOW STOCK: 5 < 10)
(30, 3003, NOW(), 50, 7.00, 20),
(30, 3004, NOW(), 600, 1.05, 50); -- Amlor

-- ------------------------------
-- 3. Clinical Activity & Appointment Data
-- ------------------------------

SET @CA_COUNT = 0;
SET @START_DATE = DATE(NOW() - INTERVAL 40 DAY);

-- Insert 40 CAs (1 per day, spread out)
INSERT INTO ClinicalActivity (CAID, IID, STAFF_ID, DEP_ID, Date, Time)
SELECT
    (@CA_COUNT := @CA_COUNT + 100) AS CAID,
    (1001 + (CAST(RAND() * 19 AS UNSIGNED))) AS IID, -- Random Patient 1001-1020
    (CASE WHEN MOD(@CA_COUNT, 4) = 0 THEN 2001 ELSE 2002 END) AS STAFF_ID, -- Alternating Drs
    (CASE WHEN MOD(@CA_COUNT, 4) = 0 THEN 51 ELSE 52 END) AS DEP_ID, -- Alternating Depts
    DATE_ADD(@START_DATE, INTERVAL (@CA_COUNT/100) - 1 DAY) AS Date,
    '10:00:00' AS Time
FROM
    information_schema.tables a, information_schema.tables b
LIMIT 40;

-- Additional CAs to test specific conditions:

-- CAIDs 4100-4104: Peak Day Testing (Multiple CAs on one day, 7 days ago)
INSERT INTO ClinicalActivity (CAID, IID, STAFF_ID, DEP_ID, Date, Time) VALUES
(4100, 1001, 2001, 51, DATE(NOW() - INTERVAL 7 DAY), '14:00:00'),
(4101, 1005, 2001, 51, DATE(NOW() - INTERVAL 7 DAY), '14:30:00'),
(4102, 1010, 2001, 51, DATE(NOW() - INTERVAL 7 DAY), '15:00:00'),
(4103, 1002, 2002, 52, DATE(NOW() - INTERVAL 7 DAY), '15:30:00'),
(4104, 1003, 2003, 61, DATE(NOW() - INTERVAL 7 DAY), '16:00:00');

-- CAIDs 4110-4112: Workload Edge Cases
INSERT INTO ClinicalActivity (CAID, IID, STAFF_ID, DEP_ID, Date, Time) VALUES
(4110, 1004, 2001, 51, DATE(NOW() - INTERVAL 31 DAY), '09:00:00'), -- OUTSIDE 30-day window
(4111, 1006, 2001, 51, DATE(NOW() - INTERVAL 1 DAY), '11:00:00'), -- INSIDE 30-day window (Recent Completed)
(4112, 1007, 2002, 52, DATE(NOW() + INTERVAL 2 DAY), '10:00:00'); -- Upcoming Appointment

-- Appointment Data (Link CAIDs, focusing on recent/upcoming CAs)
INSERT INTO Appointment (CAID, Reason, Status)
SELECT CAID, CONCAT('Consultation de routine: ', IID), 'Completed'
FROM ClinicalActivity
WHERE CAID BETWEEN 100 AND 3900 -- Mark the initial 39 CAs as completed
UNION ALL
SELECT 4100, 'Douleurs thoraciques', 'Completed'
UNION ALL
SELECT 4101, 'Contrôle tension', 'Completed'
UNION ALL
SELECT 4102, 'Suivi post-opératoire', 'Completed'
UNION ALL
SELECT 4103, 'Vaccin ROR', 'Completed'
UNION ALL
SELECT 4111, 'Examen général', 'Completed'
UNION ALL
SELECT 4112, 'Rendez-vous futur', 'Scheduled'; -- Upcoming

-- ------------------------------
-- 4. Prescription & Expense Data for Trigger Testing
-- ------------------------------

-- Scenario 1: Completed Appointment (4100) with Expense and Prescription
-- CAID 4100 done by Dr. Samir (2001) in Cardiology (51) at Hospital Rabat (10)

-- 1. Create Expense record (Initial Total should be 0.00)
INSERT INTO Expense (ExpID, CAID, Total) VALUES (5001, 4100, 0.00);

-- 2. Create Prescription
INSERT INTO Prescription (PID, CAID, DateIssued) VALUES (6001, 4100, CURDATE());



-- 1. Create Expense record
INSERT INTO Expense (ExpID, CAID, Total) VALUES (5002, 4101, 0.00);

-- 2. Create Prescription
INSERT INTO Prescription (PID, CAID, DateIssued) VALUES (6002, 4101, CURDATE());


-- 1. Create Expense record
INSERT INTO Expense (ExpID, CAID, Total) VALUES (5003, 4103, 0.00);

-- 2. Create Prescription
INSERT INTO Prescription (PID, CAID, DateIssued) VALUES (6003, 4103, CURDATE());


-- ------------------------------
-- 5. Insurance Data (Minimal)
-- ------------------------------
INSERT INTO Insurance (InsID, Type) VALUES
(7001, 'CNOPS'),
(7002, 'Private');

-- Link Patients to Insurance
INSERT INTO Insurance_Covers (IID, InsID) VALUES
(1001, 7001),
(1002, 7002),
(1010, 7001);

-- ------------------------------
-- 6. Contact Location Data (Minimal)
-- ------------------------------
-- Note: Original script used IID_CO and Policy_Number columns which are not in the new schema.
-- The provided schema uses IID and InsID in Insurance_Covers. The insertion is adapted.
-- Also, the original script used IID_CO and Name in Insurance table, the new schema uses InsID and Type.

INSERT INTO Contact_Location (CLID, Address, City) VALUES
(8001, '12 Rue Al Maghrib Al Arabi', 'Rabat'),
(8002, 'Appt 4, Bd Mohammed V', 'Casablanca');

-- Link Staff to Contact Location (The schema provided does not have a Has_Contact_Location linking Staff to Contact_Location,
-- it only links Patient (IID) to Contact_Location (CLID). I will adjust the insertion to link Patients to locations.)
-- The original code snippet that caused the error:
-- INSERT INTO Has_Contact_Location (STAFF_ID, LocID) VALUES (2001, 8001), (2003, 8002);
-- Now, using IID and CLID:
INSERT INTO Has_Contact_Location (IID, CLID) VALUES
(1001, 8001), -- Patient Fouad lives in Rabat
(1003, 8002); -- Patient Youssef lives in Casablanca


USE MNHS;

-- =========================================================
-- 1. EXTRA HOSPITALS & DEPARTMENTS
-- =========================================================

INSERT INTO Hospital (HID, Name, City, Region) VALUES
(40, 'Clinique Al Amal', 'Tangier', 'Tanger-Tétouan-Al Hoceima'),
(50, 'Centre Médical Agadir', 'Agadir', 'Souss-Massa');

-- Extra Departments (new and existing hospitals)
INSERT INTO Department (DEP_ID, Name, Specialty, HID) VALUES
-- Extra for Rabat (HID 10)
(54, 'Radiologie', 'Imagerie Médicale', 10),
-- Extra for Casablanca (HID 20)
(63, 'Chirurgie Générale', 'Chirurgie', 20),
-- Extra for Marrakesh (HID 30)
(73, 'Gastroentérologie', 'Appareil Digestif', 30),
-- New for Tangier (HID 40)
(81, 'Ophtalmologie', 'Soin des Yeux', 40),
(82, 'Radiologie', 'Imagerie Médicale', 40),
-- New for Agadir (HID 50)
(91, 'Urgences', 'Soins Aigus', 50),
(92, 'Pédiatrie', 'Soins Enfants', 50);

-- =========================================================
-- 2. EXTRA PATIENTS (IID 1021–1030)
-- =========================================================

INSERT INTO Patient (IID, CIN, FirstName, LastName, Birth, Sex, BloodGroup, Phone) VALUES
(1021, 'MU9021', 'Sara', 'El Alaoui', '2000-07-19', 'F', 'A+', '+21266101021'),
(1022, 'MV9022', 'Yassin', 'Berrada', '1992-02-11', 'M', 'O+', '+21266101022'),
(1023, 'MW9023', 'Houda', 'Mannar', '1987-09-03', 'F', 'B-', '+21266101023'),
(1024, 'MX9024', 'Issam', 'Ouazzani', '1979-04-27', 'M', 'AB+', '+21266101024'),
(1025, 'MY9025', 'Nora', 'Zerouali', '1994-12-09', 'F', 'O-', '+21266101025'),
(1026, 'MZ9026', 'Salim', 'Jebbour', '1965-01-15', 'M', 'A-', '+21266101026'),
(1027, 'NA9027', 'Rania', 'Chafik', '2003-03-21', 'F', 'B+', '+21266101027'),
(1028, 'NB9028', 'Othmane', 'Karroumi', '1990-06-30', 'M', 'O+', '+21266101028'),
(1029, 'NC9029', 'Meryem', 'Haddadi', '1983-11-13', 'F', 'AB-', '+21266101029'),
(1030, 'ND9030', 'Adil', 'Bouazza', '1972-08-06', 'M', 'A+',
 '+21266101030');

-- =========================================================
-- 3. EXTRA STAFF + SUBTABLES + WORK_IN
-- =========================================================

-- More staff (keep Status only 'Active' or 'Retired')
INSERT INTO Staff (STAFF_ID, FullName, Status) VALUES
(2006, 'Dr. Imane El Ghali', 'Active'),
(2007, 'Dr. Rachid El Khou', 'Active'),
(2016, 'Nurse Yassine El Fadili', 'Active'),
(2025, 'Radiology Tech Hassan', 'Active');

-- Practitioners
INSERT INTO Practitioner (STAFF_ID, License_Number, Specialty) VALUES
(2006, 'L1-006', 'Radiology'),
(2007, 'L1-007', 'Gastroenterology');

-- Caregiving
INSERT INTO Caregiving (STAFF_ID, Grade, Ward) VALUES
(2016, 'RN-MAT', 'MATERNITY');

-- Technical
INSERT INTO Technical (STAFF_ID, Modality, Certifications) VALUES
(2025, 'Radiologie', 'Imagerie Certifiée');

-- Work_In links
INSERT INTO Work_In (STAFF_ID, DEP_ID) VALUES
(2006, 54),   -- Radiologie Rabat
(2006, 82),   -- Radiologie Tangier
(2007, 73),   -- Gastroentérologie Marrakesh
(2016, 71),   -- Maternité Marrakesh
(2025, 81);   -- Ophtalmologie Tangier

-- =========================================================
-- 4. EXTRA MEDICATIONS + STOCK
-- =========================================================

INSERT INTO Medication (MID, Name, Form, Strength, ActiveIngredient, TherapeuticClass, Manufacturer) VALUES
(3009, 'Augmentin', 'Comprimé', '1g', 'Amoxicilline/Clavulanate', 'Antibiotique', 'GSK Maroc'),
(3010, 'Lantus', 'Injection', '100U/ml', 'Insuline Glargine', 'Antidiabétique', 'Sanofi Maroc'),
(3011, 'Seretide', 'Inhalateur', '25/250mcg', 'Salmeterol/Fluticasone', 'Antiasthmatique', 'GSK'),
(3012, 'Zyrtec', 'Comprimé', '10mg', 'Cétirizine', 'Antihistaminique', 'UCB Pharma');

-- Extra Stock (include some low stock cases)
INSERT INTO Stock (HID, MID, StockTimestamp, Qty, UnitPrice, ReorderLevel) VALUES
-- Rabat (10)
(10, 3009, NOW(), 40, 6.50, 30),
(10, 3010, NOW(), 8, 22.00, 20),     -- LOW STOCK
-- Casablanca (20)
(20, 3009, NOW(), 15, 6.80, 25),     -- LOW STOCK
(20, 3011, NOW(), 90, 18.00, 40),
-- Marrakesh (30)
(30, 3012, NOW(), 12, 5.00, 15),
(30, 3005, NOW(), 9, 15.50, 25),     -- LOW STOCK
-- Tangier (40)
(40, 3001, NOW(), 50, 1.55, 20),
(40, 3012, NOW(), 5, 5.20, 10),      -- LOW STOCK
-- Agadir (50)
(50, 3003, NOW(), 35, 7.20, 20),
(50, 3004, NOW(), 18, 1.15, 30);     -- LOW STOCK

-- =========================================================
-- 5. EXTRA CLINICAL ACTIVITIES (FUTURE) + APPOINTMENTS
--     good for UpcomingHospital & Staff workload views
-- =========================================================

-- Future Clinical Activities (within next 14 days)
INSERT INTO ClinicalActivity (CAID, IID, STAFF_ID, DEP_ID, Date, Time) VALUES
(4200, 1008, 2003, 61, DATE(NOW() + INTERVAL 3 DAY), '09:00:00'),  -- Urgences Casablanca
(4201, 1014, 2001, 51, DATE(NOW() + INTERVAL 5 DAY), '10:30:00'),  -- Cardio Rabat
(4202, 1021, 2002, 52, DATE(NOW() + INTERVAL 6 DAY), '11:00:00'),  -- Pédiatrie Rabat
(4203, 1016, 2005, 53, DATE(NOW() + INTERVAL 7 DAY), '14:00:00'),  -- Oncologie Rabat
(4204, 1025, 2006, 54, DATE(NOW() + INTERVAL 8 DAY), '15:00:00'),  -- Radiologie Rabat
(4205, 1002, 2007, 73, DATE(NOW() + INTERVAL 4 DAY), '09:30:00'),  -- Gastro Marrakesh
(4206, 1030, 2006, 82, DATE(NOW() + INTERVAL 10 DAY), '13:00:00'), -- Radiologie Tangier
(4207, 1028, 2003, 63, DATE(NOW() + INTERVAL 12 DAY), '16:00:00'), -- Chirurgie Générale Casablanca
(4208, 1027, 2002, 92, DATE(NOW() + INTERVAL 2 DAY), '10:00:00'),  -- Pédiatrie Agadir
(4209, 1023, 2003, 91, DATE(NOW() + INTERVAL 1 DAY), '18:30:00');  -- Urgences Agadir

-- Matching Appointments (all Scheduled so they appear in upcoming views)
INSERT INTO Appointment (CAID, Reason, Status) VALUES
(4200, 'Douleur abdominale aiguë', 'Scheduled'),
(4201, 'Suivi hypertension', 'Scheduled'),
(4202, 'Contrôle de croissance', 'Scheduled'),
(4203, 'Suivi chimiothérapie', 'Scheduled'),
(4204, 'IRM cardiaque', 'Scheduled'),
(4205, 'Douleurs digestives chroniques', 'Scheduled'),
(4206, 'Contrôle vision', 'Scheduled'),
(4207, 'Pré-op appendicectomie', 'Scheduled'),
(4208, 'Fièvre prolongée', 'Scheduled'),
(4209, 'Accident léger de la route', 'Scheduled');

-- Optionally add a couple of expenses/prescriptions for trigger tests
INSERT INTO Expense (ExpID, CAID, Total) VALUES
(5004, 4200, 0.00),
(5005, 4203, 0.00);

INSERT INTO Prescription (PID, CAID, DateIssued) VALUES
(6004, 4200, CURDATE()),
(6005, 4203, CURDATE());

-- =========================================================
-- 6. EXTRA INSURANCE & CONTACT LOCATIONS
-- =========================================================

INSERT INTO Insurance (InsID, Type) VALUES
(7003, 'RAMED');

INSERT INTO Insurance_Covers (IID, InsID) VALUES
(1021, 7003),
(1025, 7003),
(1030, 7002);

INSERT INTO Contact_Location (CLID, Address, City) VALUES
(8003, 'Lotissement Ennakhil, Villa 7', 'Marrakesh'),
(8004, 'Résidence Florida, Imm B, Appt 12', 'Tangier'),
(8005, 'Quartier Dakhla, Rue 5', 'Agadir');

INSERT INTO Has_Contact_Location (IID, CLID) VALUES
(1010, 8003),
(1022, 8004),
(1027, 8005);


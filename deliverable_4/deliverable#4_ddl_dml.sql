CREATE DATABASE MNHS;
USE MNHS;


-- Patient

CREATE TABLE Patient (
    IID INT PRIMARY KEY,
    CIN VARCHAR(10) UNIQUE NOT NULL,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Birth DATE,
    Sex ENUM ('M', 'F') NOT NULL,
    BloodGroup ENUM ('A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'),
    Phone VARCHAR(15)
);


-- Hospital

CREATE TABLE Hospital (
    HID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    Region VARCHAR(50)
);


-- Department

CREATE TABLE Department (
    DEP_ID INT PRIMARY KEY,
    HID INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Specialty VARCHAR(100),
    FOREIGN KEY (HID) REFERENCES Hospital(HID)
);

-- Staff

CREATE TABLE Staff (
    STAFF_ID INT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Status ENUM ('Active','Retired') DEFAULT 'Active'
);

-- Practitioner / Caregiving / Technical
CREATE TABLE Practitioner (
    STAFF_ID INT PRIMARY KEY,
    License_Number VARCHAR(30),
    Specialty VARCHAR(50),
    FOREIGN KEY (STAFF_ID) REFERENCES Staff(STAFF_ID) ON DELETE CASCADE
);

CREATE TABLE Caregiving (
    STAFF_ID INT PRIMARY KEY,
    Grade VARCHAR(50),
    Ward VARCHAR(50),
    FOREIGN KEY (STAFF_ID) REFERENCES Staff(STAFF_ID) ON DELETE CASCADE
);

CREATE TABLE Technical (
    STAFF_ID INT PRIMARY KEY,
    Modality VARCHAR(100),
    Certifications VARCHAR(50),
    FOREIGN KEY (STAFF_ID) REFERENCES Staff(STAFF_ID) ON DELETE CASCADE
);


-- Clinical Activity

CREATE TABLE ClinicalActivity (
    CAID INT PRIMARY KEY,
    IID INT NOT NULL,
    STAFF_ID INT NOT NULL,
    DEP_ID INT NOT NULL,
    Date DATE NOT NULL,
    Time TIME,
    FOREIGN KEY (IID) REFERENCES Patient(IID),
    FOREIGN KEY (STAFF_ID) REFERENCES Staff(STAFF_ID),
    FOREIGN KEY (DEP_ID) REFERENCES Department(DEP_ID)
);


-- Appointment

CREATE TABLE Appointment (
    CAID INT PRIMARY KEY,
    Reason VARCHAR(100),
    Status ENUM ('Scheduled','Completed','Cancelled') DEFAULT 'Scheduled',
    FOREIGN KEY (CAID) REFERENCES ClinicalActivity(CAID)
);


-- Emergency

CREATE TABLE Emergency (
    CAID INT PRIMARY KEY,
    TriageLevel INT CHECK (TriageLevel BETWEEN 1 AND 5),
    Outcome ENUM('Discharged','Admitted','Transferred','Deceased'),
    FOREIGN KEY (CAID) REFERENCES ClinicalActivity(CAID)
);


-- Insurance

CREATE TABLE Insurance (
    InsID INT PRIMARY KEY,
    Type ENUM('CNOPS','CNSS','RAMED','Private','None') NOT NULL
);

CREATE TABLE Insurance_Covers(  
    InsID INT,
    IID INT,
    PRIMARY KEY (IID,InsID),
    FOREIGN KEY (IID) REFERENCES Patient(IID),
    FOREIGN KEY (InsID) REFERENCES Insurance(InsID)
);


-- Expense

CREATE TABLE Expense (
    ExpID INT PRIMARY KEY,
    InsID INT,
    CAID INT UNIQUE NOT NULL,
    Total DECIMAL(10,2) NOT NULL CHECK (Total >= 0),
    FOREIGN KEY (InsID) REFERENCES Insurance(InsID),
    FOREIGN KEY (CAID) REFERENCES ClinicalActivity(CAID)
);


-- Medication

CREATE TABLE Medication (
    MID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Form VARCHAR(50),
    Strength VARCHAR(50),
    ActiveIngredient VARCHAR(100),
    TherapeuticClass VARCHAR(100),
    Manufacturer VARCHAR(100)
);


-- Stock 

CREATE TABLE Stock (
    HID INT,
    MID INT,
    StockTimestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    UnitPrice DECIMAL(10,2) CHECK (UnitPrice >= 0),
    Qty INT DEFAULT 0 CHECK (Qty >= 0),
    ReorderLevel INT DEFAULT 10 CHECK (ReorderLevel >= 0),
    PRIMARY KEY (HID, MID, StockTimestamp),
    FOREIGN KEY (HID) REFERENCES Hospital(HID),
    FOREIGN KEY (MID) REFERENCES Medication(MID)
);


-- Prescription

CREATE TABLE Prescription (
    PID INT PRIMARY KEY,
    CAID INT UNIQUE NOT NULL,
    DateIssued DATE NOT NULL,
    FOREIGN KEY (CAID) REFERENCES ClinicalActivity(CAID)
);


-- Include_Medication (Prescription ↔ Medication)

CREATE TABLE Include_Medication (
    PID INT,
    MID INT,
    PRIMARY KEY (PID, MID),
    FOREIGN KEY (PID) REFERENCES Prescription(PID),
    FOREIGN KEY (MID) REFERENCES Medication(MID)
);


-- Contact Location + Has_Contact_Location

CREATE TABLE Contact_Location (
    CLID INT PRIMARY KEY,
    Address VARCHAR(200),
    City VARCHAR(50),
    Phone VARCHAR(20)
);

CREATE TABLE Has_Contact_Location (
    IID INT,
    CLID INT,
    PRIMARY KEY(IID, CLID),
    FOREIGN KEY (IID) REFERENCES Patient(IID),
    FOREIGN KEY (CLID) REFERENCES Contact_Location(CLID)
);


-- Work_In (Staff ↔ Department)

CREATE TABLE Work_In (
    STAFF_ID INT,
    DEP_ID INT,
    PRIMARY KEY(STAFF_ID, DEP_ID),
    FOREIGN KEY (STAFF_ID) REFERENCES Staff(STAFF_ID),
    FOREIGN KEY (DEP_ID) REFERENCES Department(DEP_ID)
);




--- DATA INSERTION
INSERT INTO Patient VALUES
(1,'AA123456','Sara','El Mansouri','1995-04-12','F','A+','0611223344'),
(2,'BB987654','Youssef','Haddad','1988-11-03','M','O-','0677889900'),
(3,'CC556677','Mona','Bennani','2001-07-21','F','B+','0655332211'),
(4,'DD112233','Omar','Chakir','1979-02-17','M','AB+','0611557799'),
(5,'EE998877','Imane','Fassi','1990-12-30','F','O+','0622446688');


INSERT INTO Hospital VALUES
(1,'CHU Rabat','Rabat','Rabat-Salé'),
(2,'CHU Marrakech','Marrakech','Marrakech-Safi'),
(3,'CHU Casablanca','Casablanca','Casablanca-Settat'),
(4,'Avicenne','Rabat','Rabat-Salé'),
(5,'Ibn Sina','Fes','Fes-Meknes');


INSERT INTO Department VALUES
(10,1,'Cardiology','Heart'),
(11,1,'Emergency','Urgent Care'),
(12,2,'Pediatrics','Children'),
(13,3,'Oncology','Cancer'),
(14,4,'Radiology','Imaging');


INSERT INTO Staff VALUES
(100,'Ahmed Idrissi','Active'),
(101,'Salma Zahra','Active'),
(102,'Laila Amrani','Active'),
(103,'Reda El Fassi','Active'),
(104,'Yassine Toumi','Retired'),
(105, 'Amina Rahali', 'Active'),
(106, 'Yassin El Baroudi', 'Active'),
(107, 'Hajar Benhima', 'Active'),
(108, 'Othmane Karimi', 'Active');


INSERT INTO Practitioner VALUES
(100,'LIC123','Cardiology'),
(101,'LIC456','Pediatrics'),
(104,'LIC789','Internal Medicine');


INSERT INTO Caregiving VALUES
(102,'Senior Nurse','Ward A'),
(105,'Nurse','Ward B'),
(106,'Assistant Nurse','Ward C');


INSERT INTO Technical VALUES
(103,'Radiology','CT Certified'),
(107,'Lab','Blood Analysis'),
(108,'Radiology','MRI Certified');


INSERT INTO ClinicalActivity VALUES
(500,1,100,10,'2025-02-10','09:00:00'),
(501,2,101,12,'2025-02-11','10:30:00'),
(502,3,102,11,'2025-02-12','14:00:00'),
(503,4,103,14,'2025-02-13','08:45:00'),
(504,5,104,13,'2025-02-14','11:15:00'),
(600,1,100,10,'2025-02-10','09:00:00'),
(601,2,101,12,'2025-02-11','10:30:00'),
(602,3,102,11,'2025-02-12','14:00:00'),
(603,4,103,14,'2025-02-13','08:45:00'),
(604,5,104,13,'2025-02-14','11:15:00');


INSERT INTO Appointment VALUES
(500,'Routine Checkup','Scheduled'),
(501,'Follow-up','Completed'),
(502,'Vaccination','Scheduled'),
(503,'Imaging','Cancelled'),
(504,'Consultation','Scheduled');

INSERT INTO Emergency VALUES
(600,3,'Admitted'),
(601,5,'Transferred'),
(602,1,'Discharged'),
(603,4,'Admitted'),
(604,2,'Deceased');

INSERT INTO Insurance VALUES
(1,'CNOPS'),
(2,'CNSS'),
(3,'RAMED'),
(4,'Private'),
(5,'None');


INSERT INTO Insurance_Covers VALUES
('1',1),
('2',2),
('3',3),
('4',4),
('2',5);


INSERT INTO Expense VALUES
(900,1,500,250.00),
(901,2,501,120.00),
(902,3,502,80.00),
(903,4,503,300.00),
(904,5,504,0.00);


INSERT INTO Medication VALUES
(200,'Amoxicillin','Capsule','500mg','Amoxicillin','Antibiotic','Pfizer'),
(201,'Paracetamol','Tablet','1g','Acetaminophen','Analgesic','Sanofi'),
(202,'Ibuprofen','Tablet','400mg','Ibuprofen','Anti-inflammatory','Bayer'),
(203,'Ceftriaxone','Injection','1g','Ceftriaxone','Antibiotic','Roche'),
(204,'Azithromycin','Tablet','500mg','Azithromycin','Antibiotic','Pfizer');


INSERT INTO Stock (HID, MID, UnitPrice, Qty) VALUES
(1,200,50,100),
(1,201,20,200),
(2,202,35,300),
(3,203,120,50),
(4,204,90,80);


INSERT INTO Prescription VALUES
(300,500,'2025-02-10'),
(301,501,'2025-02-11'),
(302,502,'2025-02-12'),
(303,503,'2025-02-13'),
(304,504,'2025-02-14');


INSERT INTO Include_Medication VALUES
(300,200),
(301,201),
(302,202),
(303,203),
(304,204);


INSERT INTO Contact_Location VALUES
(1,'123 Rue Hassan II','Rabat','0611223344'),
(2,'45 Bd Zerktouni','Casablanca','0622334455'),
(3,'Hay Illiot','Fes','0633445566'),
(4,'Centre Ville','Marrakech','0644556677'),
(5,'Oued Fes','Fes','0655667788');


INSERT INTO Has_Contact_Location VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5);


INSERT INTO Work_In VALUES
(100,10),
(101,12),
(102,11),
(103,14),
(104,13);


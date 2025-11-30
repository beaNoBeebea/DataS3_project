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




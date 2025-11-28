CREATE DATABASE LAB3;
USE LAB3;
CREATE TABLE Patient (
	  IID INT PRIMARY KEY,
    CIN CHAR(11) UNIQUE,
    Name VARCHAR(50) NOT NULL,
    Sex ENUM('M', 'F') NOT NULL,
    Birth DATE,
    Bloodgroup ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    Phone VARCHAR(20)
);
CREATE TABLE Hospital(
	HID CHAR(11) PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	City VARCHAR(50),
	Region VARCHAR(50)
);
CREATE TABLE Department(   
    DEP_ID CHAR(11) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Speciality VARCHAR(50),
    HID CHAR(11) NOT NULL,  -- ONE-TO-MANY
    FOREIGN KEY (HID) REFERENCES Hospital(HID)
);
CREATE TABLE Staff (
  STAFF_ID CHAR(11) PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  status VARCHAR(20)
);
CREATE TABLE Insurance (
  InsID CHAR(11) PRIMARY KEY,
  Type VARCHAR(50)
);
CREATE TABLE Expense (
  EX_ID CHAR(11) PRIMARY KEY,
  TOTAL DECIMAL,
  InsID CHAR(11) NOT NULL, -- ONE-TO-MANY
  -- EXPENSE IS IN A ONE-TO-ONE RELATIONSHIP WITH CLINICAL ACTIVITY, SO, LOGICALLY, WE SHOULD ADD A NOT NULL REFERENCE
  -- TO CLINICAL ACTIVITY HERE AS WELL, THIS HOWEVER CREATES AN EGG AND CHICKEN PROBLEM SO WE ABSTAIN
  FOREIGN KEY (InsID) REFERENCES Insurance(InsID)
);
CREATE TABLE Clinical_Activity (
  CAID CHAR(11) PRIMARY KEY,
  Date DATE,
  Time TIME,
  DEP_ID CHAR(11) NOT NULL,
  STAFF_ID CHAR(11) NOT NULL,
  EX_ID CHAR(11) NOT NULL,
  IID INT NOT NULL,
  FOREIGN KEY (DEP_ID) REFERENCES Department(DEP_ID),
  FOREIGN KEY (STAFF_ID) REFERENCES Staff(STAFF_ID) ,
  FOREIGN KEY (IID) REFERENCES Patient(IID),
  FOREIGN KEY (EX_ID) REFERENCES Expense(EX_ID)
);
CREATE TABLE Appointment(
  CAID CHAR(11) PRIMARY KEY,
  Status VARCHAR(50), 
  Reason VARCHAR(50),
  FOREIGN KEY (CAID) REFERENCES Clinical_Activity(CAID)
  ON DELETE CASCADE   
);
INSERT INTO Patient VALUES
(1, 'CIN001', 'Aymane Tahiri', 'M', '2003-06-15', 'A+', '0612345678'),
(2, 'CIN002', 'Sara El Fassi', 'F', '1999-03-21', 'B-', '0623456789'),
(3, 'CIN003', 'Youssef Idrissi', 'M', '1988-11-02', 'O+', '0634567890');
INSERT INTO Hospital VALUES
('H1', 'Mohammed VI Hospital', 'Benguerir', 'Marrakech-Safi'),
('H2', 'Avicenne Hospital', 'Casablanca', 'Casablanca-Settat'),
('H3', 'CHU Rabat', 'Rabat', 'Rabat-Salé-Kénitra');
INSERT INTO Department VALUES
('D1', 'Cardiology', 'Heart', 'H1'),
('D2', 'Neurology', 'Brain', 'H2'),
('D3', 'Orthopedics', 'Bones', 'H3');

INSERT INTO Staff VALUES
('S1', 'Dr. Amina Rahimi', 'Active'),
('S2', 'Dr. Karim El Mansouri', 'Active'),
('S3', 'Dr. Yasmine Berrada', 'Active');

INSERT INTO Insurance VALUES
('I1', 'Basic'),
('I2', 'Premium'),
('I3', 'VIP');

INSERT INTO Expense VALUES
('E1', 100, 'I1'),
('E2', 200, 'I2'),
('E3', 150, 'I3');

INSERT INTO Clinical_Activity VALUES
('CA1', '2025-10-12', '10:00:00', 'D1', 'S1', 'E1', 1),
('CA2', '2025-10-13', '11:30:00', 'D2', 'S2', 'E2', 2),
('CA3', '2025-10-14', '09:15:00', 'D3', 'S3', 'E3', 3);

INSERT INTO Appointment VALUES
('CA1', 'Scheduled', 'Routine check-up'),
('CA2', 'Completed', 'MRI follow-up'),
('CA3', 'Scheduled', 'Knee pain consultation');

SELECT p.Name AS Patient_Name
FROM Patient p
JOIN Clinical_Activity ca ON p.IID = ca.IID
JOIN Department d ON ca.DEP_ID = d.DEP_ID
JOIN Hospital h ON d.HID = h.HID
JOIN Appointment a ON ca.CAID = a.CAID
WHERE h.City = 'Benguerir' AND a.Status = 'Scheduled';


DROP VIEW IF EXISTS UpcomingByHospital;

CREATE VIEW UpcomingByHospital AS
SELECT 
    h.Name AS HospitalName,
    ca.Date AS ApptDate,
    COUNT(a.CAID) AS ScheduledCount
FROM 
    Hospital h
    JOIN Department d ON d.HID = h.HID
    JOIN ClinicalActivity ca ON ca.DEP_ID = d.DEP_ID
    JOIN Appointment a ON a.CAID = ca.CAID
WHERE 
    a.Status = 'Scheduled'
    AND ca.Date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 14 DAY)
GROUP BY
    h.Name, ca.Date
ORDER BY 
    h.Name, ca.Date;



-- Index #1: Composite index on Appointment (Status, CAID)
CREATE INDEX idx_appointment_status_caid
ON Appointment(Status, CAID);

-- Index #2: Composite index on ClinicalActivity (Date, DEP_ID, CAID)
CREATE INDEX idx_ca_date_depid_caid
ON ClinicalActivity (Date, DEP_ID, CAID);

-- Index #3: Composite index on Department (HID, DEP_ID)
CREATE INDEX idx_department_hid_depid
ON Department (HID, DEP_ID);
CREATE VIEW PatientNextVisit AS 
SELECT p.IID, CONCAT(p.FirstName," " , p.LastName) AS FullName, ca.Date AS NextApptDate, dep.Name AS DepartmentName, h.Name AS HospitalName, h.City AS City
FROM Patient p
JOIN ClinicalActivity ca ON ca.IID=p.IID
JOIN Appointment apt ON apt.CAID = ca.CAID
JOIN Department dep on dep.DEP_ID = ca.DEP_ID
JOIN Hospital h ON h.HID = dep.HID
WHERE apt.Status = 'Scheduled' 
AND ca.Date > CURDATE()
AND ca.Date = (
    SELECT MIN(ca2.Date)
    FROM ClinicalActivity ca2
    JOIN Appointment apt2 ON apt2.CAID = ca2.CAID
    WHERE 
        ca2.IID = p.IID
        AND apt2.Status = 'Scheduled'
        AND ca2.Date > CURDATE()
    );
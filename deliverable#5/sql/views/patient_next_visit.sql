CREATE VIEW PatientNextVisit AS 
SELECT p.IID, p.LastName,p.FirstName, min(ca.Date) AS NextApptDate, dep.Name AS DepartmentName, h.Name AS HospitalName, h.City AS City
FROM Patient p
JOIN ClinicalActivity ca ON ca.IID=p.IID
JOIN Appointment apt ON apt.CAID = ca.CAID
JOIN Department dep on dep.DEP_ID = ca.DEP_ID
JOIN Hospital h ON h.HID = dep.HID
WHERE apt.Status = 'Scheduled' 
AND ca.Date > CURDATE()
GROUP BY p.IID,p.LastName,p.FirstName,dep.Name, h.Name, h.City;
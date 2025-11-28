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

CREATE OR REPLACE VIEW StaffWorkloadThirty AS
SELECT 
    S.STAFF_ID,
    S.FullName,
    COUNT(A.CAID) AS TotalAppointments,
    COALESCE(SUM(A.Status = 'Scheduled'), 0) AS ScheduledCount,
    COALESCE(SUM(A.Status = 'Cancelled'), 0) AS CancelledCount,
    COALESCE(SUM(A.Status = 'Completed'), 0) AS CompletedCount
FROM Staff S
LEFT JOIN ClinicalActivity CA 
    ON CA.STAFF_ID = S.STAFF_ID
   AND CA.Date >= CURDATE() - INTERVAL 30 DAY   -- 🔥 30-day filter here
LEFT JOIN Appointment A 
    ON A.CAID = CA.CAID
GROUP BY 
    S.STAFF_ID, 
    S.FullName;

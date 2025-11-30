-- 1. UpcomingByHospital View

-- Find hospitals with the most appointments in the next 14 days
SELECT 
    HospitalName,
    SUM(ScheduledCount) AS TotalUpcoming
FROM UpcomingByHospital
GROUP BY HospitalName
ORDER BY TotalUpcoming DESC;

-- Find dates with peak scheduling across all hospitals
SELECT 
    HospitalName,
    ApptDate,
    SUM(ScheduledCount) AS DailyTotal
FROM UpcomingByHospital
GROUP BY 
    HospitalName,
    ApptDate
ORDER BY 
    DailyTotal DESC;



-- 2. DrugPricingSummary View

-- Get all medication pricing summaries
SELECT * FROM DrugPricingSummary
ORDER BY HospitalName, MedicationName;

-- Find medications with highest price variance across hospitals
SELECT 
    MedicationName,
    COUNT(DISTINCT HID) AS HospitalCount,
    MIN(MinUnitPrice) AS GlobalMin,
    MAX(MaxUnitPrice) AS GlobalMax,
    MAX(MaxUnitPrice) - MIN(MinUnitPrice) AS PriceRange
FROM DrugPricingSummary
GROUP BY MedicationName
HAVING PriceRange > 0
ORDER BY PriceRange DESC
LIMIT 10;

-- Find medications above average price at specific hospital
SELECT 
    d1.HospitalName,
    d1.MedicationName,
    d1.AvgUnitPrice,
    (SELECT AVG(d2.AvgUnitPrice) 
     FROM DrugPricingSummary d2 
     WHERE d2.MID = d1.MID) AS GlobalAvgPrice
FROM DrugPricingSummary d1
WHERE d1.AvgUnitPrice > (
    SELECT AVG(d2.AvgUnitPrice)
    FROM DrugPricingSummary d2
    WHERE d2.MID = d1.MID
)
ORDER BY d1.HospitalName, d1.MedicationName;


-- 3. StaffWorkloadThirty View

-- Get all staff workload statistics
SELECT * FROM StaffWorkloadThirty
ORDER BY TotalAppointments DESC;

-- Find overworked staff (more than 20 appointments in 30 days)
SELECT 
    STAFF_ID,
    FullName,
    TotalAppointments,
    ScheduledCount,
    CompletedCount,
    CancelledCount,
    ROUND(CompletedCount * 100.0 / NULLIF(TotalAppointments, 0), 2) AS CompletionRate
FROM StaffWorkloadThirty
WHERE TotalAppointments > 20
ORDER BY TotalAppointments DESC;

-- Staff workload distribution analysis
SELECT 
    CASE 
        WHEN TotalAppointments = 0 THEN 'No Appointments'
        WHEN TotalAppointments BETWEEN 1 AND 10 THEN 'Light (1-10)'
        WHEN TotalAppointments BETWEEN 11 AND 20 THEN 'Moderate (11-20)'
        WHEN TotalAppointments BETWEEN 21 AND 30 THEN 'Heavy (21-30)'
        ELSE 'Very Heavy (30+)'
    END AS WorkloadCategory,
    COUNT(*) AS StaffCount
FROM StaffWorkloadThirty
GROUP BY WorkloadCategory
ORDER BY MIN(TotalAppointments);

-- 4. PatientNextVisit View

-- Get all patient next visits
SELECT * FROM PatientNextVisit
ORDER BY NextApptDate, FullName;

-- Patients with appointments in the next 7 days
SELECT 
    IID,
    FullName,
    NextApptDate,
    DATEDIFF(NextApptDate, CURDATE()) AS DaysUntilVisit,
    DepartmentName,
    HospitalName
FROM PatientNextVisit
WHERE NextApptDate <= DATE_ADD(CURDATE(), INTERVAL 7 DAY)
ORDER BY NextApptDate;


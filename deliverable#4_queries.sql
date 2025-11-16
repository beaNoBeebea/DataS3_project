USE MNHS;

-- QUERY 1
SELECT *
FROM Patient
ORDER BY LastName;

-- QUERY 2
SELECT DISTINCT Type
FROM Insurance;

-- QUERY 3
SELECT DISTINCT S.*
        FROM Staff S
        JOIN Work_in W ON W.STAFF_ID = S.STAFF_ID
        JOIN Department D ON D.DEP_ID = W.DEP_ID
        JOIN Hospital H ON H.HID = D.HID
        WHERE H.city = 'RABAT'

-- QUERY 4
SELECT *
FROM ClinicalActivity CA
JOIN Appointment A
    ON A.CAID = CA.CAID
WHERE A.Status = 'Scheduled'
  AND CA.Date BETWEEN CURRENT_DATE 
                  AND (CURRENT_DATE + INTERVAL 7 DAY);


-- QUERY 5
SELECT D.DEP_ID,
       D.Name,
       COUNT(A.CAID) AS count
From Department D
LEFT JOIN ClinicalActivity C ON D.Dep_ID=C.DEP_ID
LEFT JOIN Appointment A ON C.CAID=A.CAID
GROUP BY D.Dep_ID,D.Name;

-- QUERY 6
SELECT HID, AVG(UnitPrice) AS AvgUnitPrice
FROM Stock
GROUP BY HID;

-- QUERY 7
SELECT 
  h.HID, 
  h.Name AS HospitalName, 
  h.City, 
  h.Region, 
  COUNT(*) AS EmergencyAdmissions
FROM Hospital h 
INNER JOIN (
  SELECT d.DEP_ID, d.HID
  FROM Department d
) AS dept ON h.HID = dept.HID
INNER JOIN (
  SELECT ca.CAID, ca.DEP_ID
  FROM ClinicalActivity ca
) AS cact ON dept.DEP_ID = cact.DEP_ID
INNER JOIN Emergency e ON e.CAID = cact.CAID
WHERE e.Outcome = 'Admitted'
GROUP BY h.HID, h.Name
HAVING COUNT(*) > 20;

-- QUERY 8
SELECT DISTINCT M.Name
FROM Medication M
JOIN STOCK S ON S.MID = M.MID
WHERE S.UnitPrice < 200
and M.TherapeuticClass = 'Antibiotic';

-- QUERY 9
SELECT S1.HID, S1.MID, S1.Unitprice
FROM Stock S1
WHERE
-- we will count how many medication from S2 is more expensive than the medication in S1 per department,
-- and if there are less than two then we keep the medication
(SELECT Count(*)
FROM Stock S2
WHERE S1.HID=S2.HID AND S1.UnitPrice<S2.UnitPrice)<3
ORDER BY S1.HID, S1.UnitPrice DESC; -- ordering them by hospital and within each one by price


-- QUERY 10
SELECT count_table.DEPART_ID,
        count_table.DEPART_Name,
        SUM(Scheduledcount) AS totalScheduled,
        SUM(Cancelledcount) AS totalcancelled,
        SUM(Completedcount) AS totalcompleted
FROM(
    SELECT D.DEP_ID AS DEPART_ID ,D.Name AS DEPART_Name,
        COUNT(A.CAID) AS Scheduledcount,
        0 AS Completedcount,
        0 AS Cancelledcount
    FROM Department D
    JOIN ClinicalActivity C ON D.DEP_ID=C.DEP_ID
    JOIN Appointment A ON C.CAID=A.CAID
    WHERE A.Status='Scheduled'
    GROUP BY D.DEP_ID,D.Name

    UNION ALL 

    SELECT D.DEP_ID AS DEPART_ID ,D.Name AS DEPART_Name,
        0 AS Scheduledcount,
        COUNT(A.CAID) AS Completedcount,
        0 AS Cancelledcount
    FROM Department D
    JOIN ClinicalActivity C ON D.DEP_ID=C.DEP_ID
    JOIN Appointment A ON C.CAID=A.CAID
    WHERE A.Status='Completed'
    GROUP BY D.DEP_ID,D.Name

    UNION ALL

    SELECT D.DEP_ID AS DEPART_ID,
        D.Name AS DEPART_Name,
        0 AS Scheduledcount,
        0 AS Completedcount,
        COUNT(A.CAID) AS Cancelledcount
    FROM Department D
    JOIN ClinicalActivity C ON D.DEP_ID=C.DEP_ID
    JOIN Appointment A ON C.CAID=A.CAID
    WHERE A.Status='Cancelled'
    GROUP BY D.DEP_ID,D.Name
) AS count_table
GROUP BY count_table.DEPART_ID,count_table.DEPART_Name ;


-- QUERY 11
SELECT DISTINCT P.*
FROM Patient P
LEFT JOIN ClinicalActivity CA  -- this keeps the left side table (patient) even if there is no corresponding CA on the right
    ON CA.IID = P.IID
LEFT JOIN Appointment A
    ON CA.CAID = A.CAID
    AND Status = 'Scheduled'
    AND CA.Date BETWEEN CURRENT_DATE AND (CURRENT_DATE + INTERVAL 30 DAY)
WHERE A.CAID IS NULL;

-- QUERY 12
SELECT
    s.STAFF_ID,
    s.FullName,
    h.HID AS HospitalID,
    COUNT(a.CAID) AS AppointmentCount,
    COUNT(a.CAID) * 100.0 /
    NULLIF (
        (
            SELECT COUNT(*)
            FROM Appointment a2
            JOIN ClinicalActivity ca2 ON a2.CAID = ca2.CAID
            JOIN Department d2 ON d2.DEP_ID = ca2.DEP_ID
            JOIN Hospital h2 ON h2.HID = d2.HID
            WHERE h2.HID = h.HID
        ),
        0
    ) AS PercentageShare
FROM Staff s
LEFT JOIN ClinicalActivity ca
    ON s.STAFF_ID = ca.STAFF_ID
LEFT JOIN Appointment a
    ON a.CAID = ca.CAID
LEFT JOIN Department d 
    ON d.DEP_ID = ca.DEP_ID
LEFT JOIN Hospital h 
    ON h.HID = d.HID
GROUP BY 
    s.STAFF_ID,
    s.FullName, 
    h.HID;

-- QUERY 13
SELECT DISTINCT M.Name, H.Name
FROM Medication M
JOIN Stock S ON M.MID = S.MID
JOIN Hospital H ON H.HID = S.HID
WHERE S.Qty < S.ReorderLevel;

-- QUERY 14
-- our approach is to select the hospitals where the count of antibiotics in their stock is equal to the number of total antibiotics in medication
SELECT H.HID
FROM Hospital H
WHERE
(SELECT Count(*)
FROM Stock S JOIN Medication M ON M.MID=S.MID
WHERE M.TherapeuticClass='Antibiotic'
AND H.HID=S.HID )= (SELECT count(*)
FROM Medication WHERE TherapeuticClass='Antibiotic');

-- QUERY 15
SELECT
    LA.HospitalName,
    LA.TherapeuticClass,
    LA.local_average_prc,
    CA.city_averageprc,
    CASE
        WHEN LA.local_average_prc > CA.city_averageprc THEN 'Above City Average'
        WHEN LA.local_average_prc < CA.city_averageprc THEN 'Below City Average'
        ELSE 'At City Average'
    END AS Flag
FROM
    (
        SELECT
            H.HID,
            H.Name AS HospitalName,
            H.City,
            M.TherapeuticClass,
            AVG(S.UnitPrice) AS local_average_prc
        FROM Hospital H
        JOIN Stock S ON H.HID = S.HID
        JOIN Medication M ON S.MID = M.MID
        GROUP BY H.HID, H.Name, H.City, M.TherapeuticClass
    ) AS LA
LEFT JOIN
    (
        SELECT
            LocalAvg.City,
            LocalAvg.TherapeuticClass,
            AVG(LocalAvg.local_average_prc) AS city_averageprc
        FROM
            (
                SELECT
                    H.City,
                    M.TherapeuticClass,
                    AVG(S.UnitPrice) AS local_average_prc
                FROM Hospital H
                JOIN Stock S ON H.HID = S.HID
                JOIN Medication M ON S.MID = M.MID
                GROUP BY H.City, M.TherapeuticClass, H.HID
            ) AS LocalAvg
        GROUP BY LocalAvg.City, LocalAvg.TherapeuticClass
    ) AS CA
    ON LA.City = CA.City
    AND LA.TherapeuticClass = CA.TherapeuticClass;
   
-- QUERY 16
SELECT CA.IID, MIN(CA.Date) AS NextAppointmentDate
FROM ClinicalActivity CA
JOIN Appointment A
    ON CA.CAID = A.CAID
WHERE Status = 'Scheduled'
GROUP BY CA.IID;

-- QUERY 17
SELECT 
    p.IID,
    p.FirstName,
    p.LastName,
    MAX(ca.Date) AS LatestEmergencyDate,
    COUNT(e.CAID) AS EmergencyVisitCount
FROM Patient p
INNER JOIN ClinicalActivity ca 
    ON p.IID = ca.IID
INNER JOIN Emergency e
    ON e.CAID = ca.CAID
GROUP BY 
    p.IID, 
    p.FirstName,
    p.LastName
HAVING 
    COUNT(e.CAID) >= 2
    AND MAX(ca.Date) >= CURRENT_DATE - INTERVAL 14 DAY;
 

-- QUERY 18
SELECT 
    H.City,
    H.Name AS HospitalName,
    COUNT(A.CAID) AS CompletedAppointments
FROM Hospital H
JOIN Department D 
      ON D.HID = H.HID
JOIN ClinicalActivity CA
      ON CA.DEP_ID = D.DEP_ID
JOIN Appointment A
      ON A.CAID = CA.CAID
WHERE A.Status = 'Completed'
  AND CA.Date >= CURRENT_DATE - INTERVAL 90 DAY
GROUP BY H.City, H.HID, H.Name
ORDER BY H.City, CompletedAppointments DESC;

-- QUERY 19
-- our approach is to first compute the maximums and minimums of each city's medications,
-- then we will use them to compare the spread with 30% and only select the cities and their medication which spread is greater than 30%
CREATE VIEW CitiesMax AS
SELECT city,MID, MAX(UnitPrice) AS max
FROM Hospital H JOIN Stock S ON H.HID=S.HID
GROUP BY city,MID;
 
CREATE VIEW CitiesMin AS
SELECT city,MID, MIN(UnitPrice) AS min
FROM Hospital H JOIN Stock S ON H.HID=S.HID
GROUP BY city,MID;
 
SELECT H.city, S.MID
FROM Hospital H JOIN Stock S ON H.HID=S.HID
WHERE (
	(SELECT max
	FROM CitiesMax Ma
	WHERE H.city=Ma.city AND S.MID=Ma.MID)>1.30* (SELECT min
	FROM CitiesMin Mi
	WHERE H.city=Mi.city AND S.MID=Mi.MID)
);

-- QUERY 20
SELECT S.HID,
       S.MID,
       S.Qty,
       S.UnitPrice
FROM   Stock S
WHERE S.Qty<0 OR S.UnitPrice<=0;
CREATE OR REPLACE VIEW DrugPricingSummary AS
SELECT DISTINCT H.HID, H.Name AS HospitalName, M.MID, M.Name AS MedicationName, AvgUnitPrice, MinUnitPrice, MaxUnitPrice, LastStockTimestamp
FROM
(SELECT S.HID, S.MID, AVG(UnitPrice) AS AvgUnitPrice, MIN(UnitPrice) AS MinUnitPrice, MAX(UnitPrice) AS MaxUnitPrice, MAX(StockTimestamp) AS LastStockTimestamp
FROM Stock S
GROUP BY S.HID, S.MID) T 
JOIN
Medication M
ON M.MID=T.MID
JOIN 
Hospital H
ON
H.HID=T.HID ;
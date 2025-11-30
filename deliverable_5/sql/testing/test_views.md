# MNHS Database - View Query Results

This document showcases the results of example queries run against the MNHS database views.

---

## 1. UpcomingByHospital View Results

### Find hospitals with the most appointments in the next 14 days

```sql
SELECT 
    HospitalName,
    SUM(ScheduledCount) AS TotalUpcoming
FROM UpcomingByHospital
GROUP BY HospitalName
ORDER BY TotalUpcoming DESC;
```

**Results:**

| HospitalName | TotalUpcoming |
|--------------|---------------|
| Hôpital Ibn Sina | 5 |
| Centre Hospitalier Universitaire (CHU) Casablanca | 3 |
| Centre Médical Agadir | 2 |
| Clinique Al Amal | 1 |
| Hôpital Privé Atlas | 1 |

---

### Find dates with peak scheduling across all hospitals

```sql
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
```

**Results:**

| HospitalName | ApptDate | DailyTotal |
|--------------|----------|------------|
| Centre Hospitalier Universitaire (CHU) Casablanca | 2025-12-01 | 1 |
| Centre Hospitalier Universitaire (CHU) Casablanca | 2025-12-03 | 1 |
| Centre Hospitalier Universitaire (CHU) Casablanca | 2025-12-12 | 1 |
| Centre Médical Agadir | 2025-12-01 | 1 |
| Centre Médical Agadir | 2025-12-02 | 1 |
| Clinique Al Amal | 2025-12-10 | 1 |
| Hôpital Ibn Sina | 2025-11-30 | 1 |
| Hôpital Ibn Sina | 2025-12-05 | 1 |
| Hôpital Ibn Sina | 2025-12-06 | 1 |
| Hôpital Ibn Sina | 2025-12-07 | 1 |
| Hôpital Ibn Sina | 2025-12-08 | 1 |
| Hôpital Privé Atlas | 2025-12-04 | 1 |


---

## 2. DrugPricingSummary View Results

### Get all medication pricing summaries

```sql
SELECT * FROM DrugPricingSummary
ORDER BY HospitalName, MedicationName;
```

**Results:**

| HID | HospitalName | MID | MedicationName | AvgUnitPrice | MinUnitPrice | MaxUnitPrice | LastStockTimestamp |
|-----|--------------|-----|----------------|--------------|--------------|--------------|-------------------|
| 20 | Centre Hospitalier Universitaire (CHU) Casablanca | 3004 | Amlor | 1.100000 | 1.10 | 1.10 | 2025-11-28 18:19:48 |
| 20 | Centre Hospitalier Universitaire (CHU) Casablanca | 3002 | Amoclan | 4.000000 | 4.00 | 4.00 | 2025-11-28 18:19:48 |
| 20 | Centre Hospitalier Universitaire (CHU) Casablanca | 3009 | Augmentin | 6.800000 | 6.80 | 6.80 | 2025-11-30 09:38:27 |
| 20 | Centre Hospitalier Universitaire (CHU) Casablanca | 3001 | Doliprane | 1.600000 | 1.60 | 1.60 | 2025-11-28 18:19:48 |
| 20 | Centre Hospitalier Universitaire (CHU) Casablanca | 3006 | Doxycycline | 5.500000 | 5.50 | 5.50 | 2025-11-28 18:19:48 |
| 20 | Centre Hospitalier Universitaire (CHU) Casablanca | 3011 | Seretide | 18.000000 | 18.00 | 18.00 | 2025-11-30 09:38:27 |
| 50 | Centre Médical Agadir | 3004 | Amlor | 1.150000 | 1.15 | 1.15 | 2025-11-30 09:38:27 |
| 50 | Centre Médical Agadir | 3003 | Ventoline | 7.200000 | 7.20 | 7.20 | 2025-11-30 09:38:27 |
| 40 | Clinique Al Amal | 3001 | Doliprane | 1.550000 | 1.55 | 1.55 | 2025-11-30 09:38:27 |
| 40 | Clinique Al Amal | 3012 | Zyrtec | 5.200000 | 5.20 | 5.20 | 2025-11-30 09:38:27 |
| 10 | Hôpital Ibn Sina | 3004 | Amlor | 0.900000 | 0.90 | 0.90 | 2025-11-28 18:19:48 |
| 10 | Hôpital Ibn Sina | 3009 | Augmentin | 6.500000 | 6.50 | 6.50 | 2025-11-30 09:38:27 |
| 10 | Hôpital Ibn Sina | 3001 | Doliprane | 1.475000 | 1.45 | 1.50 | 2025-11-28 18:19:48 |
| 10 | Hôpital Ibn Sina | 3005 | Insuline Rapid | 15.000000 | 15.00 | 15.00 | 2025-11-28 18:19:48 |
| 10 | Hôpital Ibn Sina | 3010 | Lantus | 22.000000 | 22.00 | 22.00 | 2025-11-30 09:38:27 |
| 10 | Hôpital Ibn Sina | 3008 | Profenid | 2.500000 | 2.50 | 2.50 | 2025-11-28 18:19:48 |
| 30 | Hôpital Privé Atlas | 3004 | Amlor | 1.050000 | 1.05 | 1.05 | 2025-11-28 18:19:48 |
| 30 | Hôpital Privé Atlas | 3001 | Doliprane | 1.550000 | 1.55 | 1.55 | 2025-11-28 18:19:48 |
| 30 | Hôpital Privé Atlas | 3005 | Insuline Rapid | 15.500000 | 15.50 | 15.50 | 2025-11-30 09:38:27 |
| 30 | Hôpital Privé Atlas | 3003 | Ventoline | 7.000000 | 7.00 | 7.00 | 2025-11-28 18:19:48 |
| 30 | Hôpital Privé Atlas | 3012 | Zyrtec | 5.000000 | 5.00 | 5.00 | 2025-11-30 09:38:27 |


---

### Find medications with highest price variance across hospitals

```sql
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
```

**Results:**

| MedicationName | HospitalCount | GlobalMin | GlobalMax | PriceRange |
|----------------|---------------|-----------|-----------|------------|
| Insuline Rapid | 2 | 15.00 | 15.50 | 0.50 |
| Augmentin | 2 | 6.50 | 6.80 | 0.30 |
| Amlor | 4 | 0.90 | 1.15 | 0.25 |
| Zyrtec | 2 | 5.00 | 5.20 | 0.20 |
| Ventoline | 2 | 7.00 | 7.20 | 0.20 |
| Doliprane | 4 | 1.45 | 1.60 | 0.15 |

---

### Find medications above average price at specific hospital

```sql
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
```

**Results:**

| HospitalName | MedicationName | AvgUnitPrice | GlobalAvgPrice |
|--------------|----------------|--------------|----------------|
| Centre Hospitalier Universitaire (CHU) Casablanca | Amlor | 1.100000 | 1.0500000000 |
| Centre Hospitalier Universitaire (CHU) Casablanca | Augmentin | 6.800000 | 6.6500000000 |
| Centre Hospitalier Universitaire (CHU) Casablanca | Doliprane | 1.600000 | 1.5437500000 |
| Centre Médical Agadir | Amlor | 1.150000 | 1.0500000000 |
| Centre Médical Agadir | Ventoline | 7.200000 | 7.1000000000 |
| Clinique Al Amal | Doliprane | 1.550000 | 1.5437500000 |
| Clinique Al Amal | Zyrtec | 5.200000 | 5.1000000000 |
| Hôpital Privé Atlas | Doliprane | 1.550000 | 1.5437500000 |
| Hôpital Privé Atlas | Insuline Rapid | 15.500000 | 15.2500000000 |

---

## 3. StaffWorkloadThirty View Results

### Get all staff workload statistics

```sql
SELECT * FROM StaffWorkloadThirty
ORDER BY TotalAppointments DESC;
```

**Results:**

| STAFF_ID | FullName | TotalAppointments | ScheduledCount | CancelledCount | CompletedCount |
|----------|----------|-------------------|----------------|----------------|----------------|
| 2001 | Dr. Samir Tazi | 32 | 1 | 0 | 31 |
| 2002 | Dr. Leila Benchekroun | 4 | 3 | 0 | 1 |
| 2003 | Dr. Hicham Alaoui | 3 | 3 | 0 | 0 |
| 2006 | Dr. Imane El Ghali | 2 | 2 | 0 | 0 |
| 2011 | Nurse Fatima Zahra | 1 | 1 | 0 | 0 |
| 2023 | Lab Technician Younes | 1 | 1 | 0 | 0 |
| 2005 | Dr. Younes El Fassi | 1 | 1 | 0 | 0 |
| 2007 | Dr. Rachid El Khou | 1 | 1 | 0 | 0 |
| 2016 | Nurse Yassine El Fadili | 0 | 0 | 0 | 0 |
| 2012 | Nurse Rachid Amrani | 0 | 0 | 0 | 0 |
| 2015 | Nurse Sofia El Moutawakil | 0 | 0 | 0 | 0 |
| 2025 | Radiology Tech Hassan | 0 | 0 | 0 | 0 |
| 2013 | Nurse Malika Sefrioui | 0 | 0 | 0 | 0 |
| 2022 | IT Amina Bennani | 0 | 0 | 0 | 0 |
| 2004 | Dr. Sanaa Mounir | 0 | 0 | 0 | 0 |
| 2014 | Nurse Khalil Idrissi | 0 | 0 | 0 | 0 |
| 2021 | Admin Ali Tazi | 0 | 0 | 0 | 0 |
| 2024 | Admin Zineb Bounou | 0 | 0 | 0 | 0 |

---

### Find overworked staff (more than 20 appointments in 30 days)

```sql
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
```

**Results:**

| STAFF_ID | FullName | TotalAppointments | ScheduledCount | CompletedCount | CancelledCount | CompletionRate |
|----------|----------|-------------------|----------------|----------------|----------------|----------------|
| 2001 | Dr. Samir Tazi | 32 | 1 | 31 | 0 | 96.88 |


---

### Staff workload distribution analysis

```sql
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
```

**Results:**

| WorkloadCategory | StaffCount |
|------------------|------------|
| No Appointments | 10 |
| Light (1-10) | 7 |
| Very Heavy (30+) | 1 |


---

## 4. PatientNextVisit View Results

### Get all patient next visits

```sql
SELECT * FROM PatientNextVisit
ORDER BY NextApptDate, FullName;
```

**Results:**

| IID | FullName | NextApptDate | DepartmentName | HospitalName | City |
|-----|----------|--------------|----------------|--------------|------|
| 1001 | Fouad El Idrissi | 2025-12-01 | Urgences | Centre Hospitalier Universitaire (CHU) Casablanca | Casablanca |
| 1023 | Houda Mannar | 2025-12-01 | Urgences | Centre Médical Agadir | Agadir |
| 1027 | Rania Chafik | 2025-12-02 | Pédiatrie | Centre Médical Agadir | Agadir |
| 1008 | Nadia Tazi | 2025-12-03 | Urgences | Centre Hospitalier Universitaire (CHU) Casablanca | Casablanca |
| 1002 | Layla Bennani | 2025-12-04 | Gastroentérologie | Hôpital Privé Atlas | Marrakesh |
| 1014 | Salma Boutayeb | 2025-12-05 | Cardiologie | Hôpital Ibn Sina | Rabat |
| 1021 | Sara El Alaoui | 2025-12-06 | Pédiatrie | Hôpital Ibn Sina | Rabat |
| 1016 | Hiba El Mansour | 2025-12-07 | Oncologie | Hôpital Ibn Sina | Rabat |
| 1025 | Nora Zerouali | 2025-12-08 | Radiologie | Hôpital Ibn Sina | Rabat |
| 1030 | Adil Bouazza | 2025-12-10 | Radiologie | Clinique Al Amal | Tangier |
| 1028 | Othmane Karroumi | 2025-12-12 | Chirurgie Générale | Centre Hospitalier Universitaire (CHU) Casablanca | Casablanca |


---

### Patients with appointments in the next 7 days

```sql
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
```

**Results:**

| IID | FullName | NextApptDate | DaysUntilVisit | DepartmentName | HospitalName |
|-----|----------|--------------|----------------|----------------|--------------|
| 1001 | Fouad El Idrissi | 2025-12-01 | 1 | Urgences | Centre Hospitalier Universitaire (CHU) Casablanca |
| 1023 | Houda Mannar | 2025-12-01 | 1 | Urgences | Centre Médical Agadir |
| 1027 | Rania Chafik | 2025-12-02 | 2 | Pédiatrie | Centre Médical Agadir |
| 1008 | Nadia Tazi | 2025-12-03 | 3 | Urgences | Centre Hospitalier Universitaire (CHU) Casablanca |
| 1002 | Layla Bennani | 2025-12-04 | 4 | Gastroentérologie | Hôpital Privé Atlas |
| 1014 | Salma Boutayeb | 2025-12-05 | 5 | Cardiologie | Hôpital Ibn Sina |
| 1021 | Sara El Alaoui | 2025-12-06 | 6 | Pédiatrie | Hôpital Ibn Sina |
| 1016 | Hiba El Mansour | 2025-12-07 | 7 | Oncologie | Hôpital Ibn Sina |


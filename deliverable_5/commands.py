from db import get_connection
from collections import defaultdict


def list_patients():
    
    conn = get_connection()
    cursor = conn.cursor()
    
    query = """SELECT 
        IID,
        CIN,
        Birth,
        Sex,
        BloodGroup,
        Phone,
        CONCAT(FirstName, ' ', LastName) AS FullName
    FROM 
        Patient
    ORDER BY 
        LastName ASC
    LIMIT 20;"""
    
    cursor.execute(query) 
    results = cursor.fetchall()

    cursor.close()
    conn.close()
    
    return results

def schedule_appointment(caid, iid, staff_id, dep_id, date_str, time_str, reason):
    check_patient_sql = "SELECT IID FROM Patient WHERE IID = %s"
    check_staff_sql = "SELECT STAFF_ID FROM Staff WHERE STAFF_ID = %s"
    check_department_sql = "SELECT DEP_ID FROM Department WHERE DEP_ID = %s"
    check_caid_sql = "SELECT CAID FROM ClinicalActivity WHERE CAID = %s"

    ins_ca = """
    INSERT INTO ClinicalActivity(CAID, IID, STAFF_ID, DEP_ID, Date, Time)
    VALUES (%s, %s, %s, %s, %s, %s)
    """

    ins_appt = """
    INSERT INTO Appointment(CAID, Reason, Status)
    VALUES (%s, %s, 'Scheduled')
    """

    with get_connection() as cnx:
        try:
            with cnx.cursor() as cur:

                # Check Patient exists
                cur.execute(check_patient_sql, (iid,))
                if not cur.fetchone():
                    print(f"Patient {iid} doesn't exist")
                    return False
                
                # Check Staff exists
                cur.execute(check_staff_sql, (staff_id,))
                if not cur.fetchone():
                    print(f"Staff {staff_id} doesn't exist")
                    return False
                
                # Check Department exists
                cur.execute(check_department_sql, (dep_id,))
                if not cur.fetchone():
                    print(f"Department {dep_id} doesn't exist")
                    return False
                
                # Check CAID does NOT already exist (fix)
                cur.execute(check_caid_sql, (caid,))
                if cur.fetchone():
                    print(f"ClinicalActivity ID {caid} already exists")
                    return False
                
                # Insert
                cur.execute(ins_ca, (caid, iid, staff_id, dep_id, date_str, time_str))
                cur.execute(ins_appt, (caid, reason))

            cnx.commit()
            print("Appointment scheduled")
            return True
        
        except Exception as e:
            cnx.rollback()
            print(f"Failed: {e}")
            return False


def low_stock():
    conn = get_connection()
    cursor = conn.cursor()

    query = """
    SELECT
        H.Name,
        M.Name,
        S.Qty,
        S.ReorderLevel,
        S.StockTimestamp
    FROM Stock S
    JOIN (
        SELECT
            MID, HID,
            MAX(StockTimestamp) AS MaxTime
        FROM Stock
        GROUP BY MID, HID
    ) L ON L.MID = S.MID 
    AND L.HID = S.HID
    AND L.MaxTime = S.StockTimestamp
    JOIN Medication M ON M.MID = S.MID
    JOIN Hospital H ON H.HID = S.HID
    WHERE S.Qty < S.ReorderLevel
    ORDER BY H.Name, M.Name;


    """

    cursor.execute(query)
    results = cursor.fetchall()
    cursor.close()
    conn.close()
    return results


def staff_share():
    sql = """
    SELECT 
        s.STAFF_ID,
        s.FullName AS StaffName,
        h.HID,
        h.Name AS HospitalName,
        COUNT(a.CAID) AS TotalAppointments
    FROM 
        Staff s
        JOIN ClinicalActivity ca ON s.STAFF_ID = ca.STAFF_ID
        JOIN Appointment a ON ca.CAID = a.CAID
        JOIN Department d ON ca.DEP_ID = d.DEP_ID
        JOIN Hospital h ON d.HID = h.HID
    GROUP BY 
        s.STAFF_ID, s.FullName, h.HID, h.Name
    """
    
    with get_connection() as cnx:
        with cnx.cursor(dictionary=True) as cur:
            cur.execute(sql)
            staff_data = cur.fetchall()
    

    hospital_totals = defaultdict(int)
    for staff in staff_data:
        hospital_totals[staff['HID']]+= staff['TotalAppointments']
    
    results = []
    for staff in staff_data:
        hospital_total= hospital_totals[staff['HID']]
        percentage= round((staff['TotalAppointments'] * 100)/hospital_total, 2) if hospital_total != 0 else 0.0
        
        results.append({
            'STAFF_ID': staff['STAFF_ID'],
            'StaffName': staff['StaffName'],
            'HospitalName': staff['HospitalName'],
            'TotalAppointments': staff['TotalAppointments'],
            'HospitalTotal': hospital_total,
            'PercentageShare': percentage
        })
    
    
    results.sort(key=lambda x: (
        x['HospitalName'],
        -x['PercentageShare'],
        x['StaffName']
    ))
    
    return results



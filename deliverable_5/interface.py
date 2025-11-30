import streamlit as st
import pandas as pd
import datetime
import io
from contextlib import redirect_stdout

# IMPORT YOUR BACKEND FUNCTIONS
try:
    from commands import list_patients, schedule_appointment, low_stock, staff_share
except ImportError:
    st.error("⚠️ Critical Error: Could not find 'commands.py'. Please ensure this script is in the same directory.")
    st.stop()

# ==========================================
# 1. PAGE CONFIGURATION
# ==========================================
st.set_page_config(page_title="MNHS Management", page_icon="🏥", layout="wide")
st.title("🏥 MNHS Hospital Management System")
st.markdown("---")

# ==========================================
# 2. SIDEBAR NAVIGATION
# ==========================================
st.sidebar.header("Navigation")
options = ["Patient List", "Schedule Appointment", "Inventory (Low Stock)", "Staff Workload"]
choice = st.sidebar.radio("Go to:", options)

# ==========================================
# 3. HELPER FUNCTIONS
# ==========================================
def display_results_as_table(data_generator, column_names=None):
    """
    Smart helper: Handles both Lists of Tuples (requires column_names)
    and Lists of Dictionaries (automatically uses keys).
    """
    try:
        # Convert generator to list
        data = list(data_generator)
        
        if not data:
            st.info("No records found.")
            return

        # CASE A: List of Dictionaries (like 'staff_share')
        if isinstance(data[0], dict):
            df = pd.DataFrame(data)
            # If column_names are provided, use them to enforce order, otherwise use keys
            if column_names:
                # Only select columns that actually exist in the dictionary
                valid_cols = [c for c in column_names if c in df.columns]
                df = df[valid_cols]
            st.dataframe(df, use_container_width=True)

        # CASE B: List of Tuples (like 'list_patients' or 'low_stock')
        elif isinstance(data[0], (list, tuple)):
            if column_names:
                df = pd.DataFrame(data, columns=column_names)
            else:
                df = pd.DataFrame(data)
            st.dataframe(df, use_container_width=True)
            
        # CASE C: Simple List (Strings)
        else:
            st.write(data)

    except Exception as e:
        st.error(f"Error reading data: {e}")

# ==========================================
# 4. MAIN APPLICATION LOGIC
# ==========================================

# --- OPTION 1: LIST PATIENTS ---
if choice == "Patient List":
    st.header("📂 Registered Patients")
    
    if st.button("Refresh Patient List"):
        results = list_patients()
        
        # MATCHING YOUR SQL QUERY: 
        # IID, CIN, Birth, Sex, BloodGroup, Phone, FullName
        cols = ["ID", "CIN", "DOB", "Sex", "Blood Type", "Phone", "Full Name"]
        
        display_results_as_table(results, column_names=cols)

# --- OPTION 2: SCHEDULE APPOINTMENT ---
elif choice == "Schedule Appointment":
    st.header("📅 Schedule New Appointment")
    
    with st.form("appointment_form"):
        col1, col2 = st.columns(2)
        with col1:
            caid = st.number_input("Clinical Activity ID (CAID)", min_value=1, step=1)
            iid = st.number_input("Patient ID (IID)", min_value=1, step=1)
            staff_id = st.number_input("Staff ID", min_value=1, step=1)
            dept_id = st.number_input("Department ID", min_value=1, step=1)
        with col2:
            appt_date = st.date_input("Date", min_value=datetime.date.today())
            appt_time = st.time_input("Time")
            reason = st.text_area("Reason", placeholder="e.g. Checkup")

        submitted = st.form_submit_button("Confirm Schedule")
        
        if submitted:
            formatted_date = appt_date.strftime("%Y-%m-%d")
            formatted_time = appt_time.strftime("%H:%M:%S")
            
            # Capture the PRINT statements from backend
            output_capture = io.StringIO()
            try:
                with redirect_stdout(output_capture):
                    is_success = schedule_appointment(
                        caid, iid, staff_id, dept_id, 
                        formatted_date, formatted_time, reason
                    )
                
                backend_msg = output_capture.getvalue()

                if is_success:
                    st.success("✅ Appointment scheduled successfully.")
                else:
                    st.error("❌ Failed to schedule.")
                    if backend_msg:
                        st.warning(f"Reason: {backend_msg}")
                        
            except Exception as e:
                st.error(f"Error: {e}")

# --- OPTION 3: LOW STOCK ---
elif choice == "Inventory (Low Stock)":
    st.header("⚠️ Low Stock Alert")
    
    if st.button("Check Inventory"):
        results = low_stock()
        
        # MATCHING YOUR SQL QUERY:
        # H.Name, M.Name, S.Qty, S.ReorderLevel, S.StockTimestamp
        cols = ["Hospital", "Medication", "Qty Available", "Reorder Level", "Last Update"]
        
        display_results_as_table(results, column_names=cols)

# --- OPTION 4: STAFF SHARE ---
elif choice == "Staff Workload":
    st.header("📊 Staff Workload Distribution")
    
    if st.button("Load Report"):
        results = staff_share()
        
        # Your backend returns a DICTIONARY with these keys:
        # STAFF_ID, StaffName, HospitalName, TotalAppointments, HospitalTotal, PercentageShare
        
        # We define this list just to put the columns in a nice order for the user
        cols = ["STAFF_ID", "StaffName", "HospitalName", "TotalAppointments", "HospitalTotal", "PercentageShare"]
        
        display_results_as_table(results, column_names=cols)
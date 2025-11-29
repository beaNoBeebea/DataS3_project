import streamlit as st
import pandas as pd
import datetime
import io
from contextlib import redirect_stdout

# IMPORT YOUR BACKEND FUNCTIONS
# We wrap this in a try/except block to prevent the app from crashing 
# if the commands.py file isn't found during testing.
try:
    from commands import list_patients, schedule_appointment, low_stock, staff_share
except ImportError:
    st.error("⚠️ Critical Error: Could not find 'commands.py'. Please ensure this script is in the same directory as your backend code.")
    st.stop()

# ==========================================
# 1. PAGE CONFIGURATION
# ==========================================
st.set_page_config(
    page_title="MNHS Management System",
    page_icon="🏥",
    layout="wide"
)

# Title and Header
st.title("🏥 MNHS Hospital Management System")
st.markdown("---")

# ==========================================
# 2. SIDEBAR NAVIGATION
# ==========================================
st.sidebar.header("Navigation")
options = [
    "Patient List", 
    "Schedule Appointment", 
    "Inventory (Low Stock)", 
    "Staff Workload"
]
choice = st.sidebar.radio("Go to:", options)

# ==========================================
# 3. HELPER FUNCTIONS
# ==========================================
def display_results_as_table(data_generator, column_names=None):
    """
    Helper to convert the generator/list from your backend into a 
    clean Streamlit dataframe.
    """
    try:
        # Consume the generator/list
        data = list(data_generator)
        
        if not data:
            st.info("No records found.")
            return

        # If data is simple strings, display as list
        if isinstance(data[0], str):
            st.write(data)
        # If data is tuples/lists (rows), display as table
        else:
            if column_names:
                df = pd.DataFrame(data, columns=column_names)
            else:
                df = pd.DataFrame(data)
            st.dataframe(df, use_container_width=True)
            
    except Exception as e:
        st.error(f"Error reading data: {e}")

# ==========================================
# 4. MAIN APPLICATION LOGIC
# ==========================================

# --- OPTION 1: LIST PATIENTS ---
if choice == "Patient List":
    st.header("📂 Registered Patients")
    st.caption("View all patients currently registered in the system.")
    
    if st.button("Refresh Patient List"):
        with st.spinner("Fetching data..."):
            # Calling your backend function
            results = list_patients()
            # Note: Update 'column_names' if you know the exact DB columns, e.g., ['ID', 'Name', 'DOB']
            display_results_as_table(results)

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
            reason = st.text_area("Reason for Visit", placeholder="e.g., Routine Checkup")

        submitted = st.form_submit_button("Confirm Schedule")
        
        if submitted:
            # 1. Format the date/time strings
            formatted_date = appt_date.strftime("%Y-%m-%d")
            formatted_time = appt_time.strftime("%H:%M:%S")
            
            # 2. Setup a trap to catch print() statements
            output_capture = io.StringIO()
            
            try:
                # redirect_stdout captures anything your backend prints
                with redirect_stdout(output_capture):
                    is_success = schedule_appointment(
                        caid, 
                        iid, 
                        staff_id, 
                        dept_id, 
                        formatted_date, 
                        formatted_time, 
                        reason
                    )
                
                # Get the printed text (e.g., "Patient 101 doesn't exist")
                backend_message = output_capture.getvalue()

                # 3. Handle the Result
                if is_success:
                    st.success(f"✅ Appointment scheduled successfully.")
                else:
                    # Show the specific error from the backend print
                    st.error(f"❌ Failed to schedule.")
                    if backend_message:
                        st.warning(f"System Message: {backend_message}")
                    else:
                        st.warning("Reason unknown (No message returned from database).")
                        
            except Exception as e:
                st.error(f"An unexpected error occurred: {e}")
                
# --- OPTION 3: LOW STOCK ---
elif choice == "Inventory (Low Stock)":
    st.header("⚠️ Low Stock Alert")
    st.caption("Items that have fallen below their reorder level.")
    
    if st.button("Check Inventory"):
        results = low_stock()
        display_results_as_table(results)

# --- OPTION 4: STAFF SHARE ---
elif choice == "Staff Workload":
    st.header("📊 Staff Workload Distribution")
    st.caption("Overview of staff assignments and shares.")
    
    if st.button("Load Report"):
        results = staff_share()
        display_results_as_table(results)
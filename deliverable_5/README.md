# Moroccan National Health Services (MNHS) – Database Management System

A comprehensive healthcare management system built for the Moroccan National Health Services, featuring a command-line interface, web interface and database backend with advanced SQL views and triggers.

## 🚀 Features

### CLI Commands
- **`list_patients`** - Display first 20 patients ordered by last name
- **`schedule_appt`** - Schedule new appointments with transaction safety
- **`low_stock`** - Monitor medication inventory below reorder levels
- **`staff_share`** - Analyze staff appointment distribution across hospitals

### Web Interface (Streamlit)
- Patient management dashboard
- Appointment scheduling interface
- Real-time inventory monitoring
- Staff workload analytics

### Database Views
- **`PatientNextVisit`** - Track upcoming patient appointments
- **`UpcomingByHospital`** - 14-day appointment forecast per hospital
- **`DrugPricingSummary`** - Medication pricing analytics
- **`StaffWorkloadThirty`** - 30-day staff workload statistics

### Business Logic Triggers
- Double booking prevention for staff
- Automatic expense recalculation
- Stock level validation
- Patient deletion protection

### Tech Stack:
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Streamlit](https://img.shields.io/badge/Streamlit-FF4B4B?style=for-the-badge&logo=streamlit&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)

## 🛠 Installation & Setup

### Prerequisites
- Python 3.8+
- MySQL 8.0+ (installed locally)
- Git

### Step 1: Install MySQL Server
#### On Windows:
1. Download MySQL Installer from https://dev.mysql.com/downloads/installer/
2. Run the installer and select "Developer Default"
3. Set a root password (remember this!)
4. Complete the installation wizard
#### On MacOs:
```bash
# Using Homebrew
brew install mysql

# Start MySQL service
brew services start mysql

# Secure installation
mysql_secure_installation
```
#### On Linux (Ubuntu/Debian):
```bash
sudo apt update
sudo apt install mysql-server

# Start MySQL service
sudo systemctl start mysql
sudo systemctl enable mysql

# Secure installation
sudo mysql_secure_installation
```

### Step 2: Clone Repository
```bash
git clone https://github.com/beaNoBeebea/DataS3_project.git
cd DataS3_project/deliverable_5
```

### Step 3: Set Up Virtual Environment
```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate

# On macOS/Linux:
source venv/bin/activate
```

### Step 4: Install Dependencies
```bash
pip install -r requirements.txt
```

### Step 5: Create Database and User
Open MySQL command line:
```bash
# On Windows (MySQL Command Line Client)
# Enter your root password when prompted

# On macOS/Linux
mysql -u root -p
```

Run the following SQL commands:
```sql
-- Create the database
CREATE DATABASE IF NOT EXISTS MNHS;

-- Create dedicated user
CREATE USER 'mnhs_user'@'localhost' IDENTIFIED BY 'StrongPassword123!';

-- Grant privileges
GRANT SELECT, INSERT, UPDATE, DELETE ON mnhs_db.* TO 'mnhs_user'@'localhost';
FLUSH PRIVILEGES;

-- Switch to the database
USE MNHS;

-- Exit MySQL
EXIT;
```

### Step 6: Import Database Schema
You need to import the database schema file
```bash
cd sql
mysql -u mnhs_user -p mnhs_db < schema.sql
```
If you need to import sample data:
```bash
mysql -u mnhs_user -p mnhs_db < sample_data.sql
```

### Step 7: Create Views
Import all view definitions:
```bash
cd views
mysql -u mnhs_user -p mnhs_db < patient_next_visit.sql
mysql -u mnhs_user -p mnhs_db < upcoming_by_hospital.sql
mysql -u mnhs_user -p mnhs_db < drug_pricing_summary.sql
mysql -u mnhs_user -p mnhs_db < staff_workload_thirty.sql
```

### Step 8: Create Triggers
Import all trigger definitions:
```bash
cd ../triggers
mysql -u mnhs_user -p mnhs_db < reject_double_booking.sql
mysql -u mnhs_user -p mnhs_db < recompute_expense_total.sql
mysql -u mnhs_user -p mnhs_db < prevent_bad_stock.sql
mysql -u mnhs_user -p mnhs_db < protect_patient_delete.sql
cd ..
```

### Step 9: Configure Environment Variables
Create a .env file in the project root directory:
```bash
# On Windows
type nul > .env

# On macOS/Linux
touch .env
```
Edit .env and add the following:

```env
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=mnhs_db
DB_USERNAME=mnhs_user
DB_PASSWORD=StrongPassword123!
```

### Step 10: Verify Database Connection
Run:
```bash
python test_connection.py
```
Expected output:
```
HOST= localhost
USER= mnhs_user
```

### Step 11: Test CLI Commands
```bash
# List patients
python app.py list_patients

# Check low stock
python app.py low_stock

# View staff share
python app.py staff_share

# Schedule appointment (example)
python app.py schedule_appt \
  --caid 10001 \
  --iid 1 \
  --staff 1 \
  --dep 1 \
  --date "2025-12-15" \
  --time "14:30:00" \
  --reason "Regular checkup"
  ```

### Step 12: Launch Web Interface
```bash
streamlit run interface.py
```
The web interface will open automatically in your browser at:
```
http://localhost:8501
```


## 📊 Testing Views & Triggers
For that, see the sql/example_queries & sql/testing folders



## 🐛 Troubleshooting
## Common Issues
### Database Connection Failed
- Check .env file exists and has correct values
- Verify MySQL service is running
- Confirm database user has required permissions
### Module Not Found Errors
- Ensure virtual environment is activated
- Run pip install -r requirements.txt again
### SQL Syntax Errors
- Verify MySQL version compatibility
- Check SQL file execution order

## 👥 Authors
This project was built by
- Abir Fakhreddine
- Nada El Farissi
- Malak El Assali
- Anass Fertat
- Yasser Hallou
- Amine Chrif

## 📝 License
This project was developed for educational purposes as part of the Data Management course at UM6P College of Computing.

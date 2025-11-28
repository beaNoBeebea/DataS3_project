# Moroccan National Health Services (MNHS) – Database Management System

A comprehensive healthcare management system built for the Moroccan National Health Services, featuring a command-line interface and database backend with advanced SQL views and triggers.

## 🚀 Features

### CLI Commands
- **`list_patients`** - Display first 20 patients ordered by last name
- **`schedule_appt`** - Schedule new appointments with transaction safety
- **`low_stock`** - Monitor medication inventory below reorder levels
- **`staff_share`** - Analyze staff appointment distribution across hospitals

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

## 🛠 Installation & Setup

### Prerequisites
- Python 3.8+
- MySQL 8.0+ or compatible database
- Git

### Step 1: Clone Repository
```bash
git clone https://github.com/beaNoBeebea/DataS3_project/deliverable_5
cd deliverable_5
```

### Step 2: Set Up Virtual Environment
#### Create virtual environment
python -m venv venv

##### Activate virtual environment
###### On Windows:
venv\Scripts\activate
###### On macOS/Linux:
source venv/bin/activate

### Step 3: Install Dependencies
```bash
pip install -r requirements.txt
```

### Step 4: Database Configuration

### Step 5: Environment Configuration

### Step 6: Verify Installation

## 📖 Usage
### Command Line Interface

- List Patients
```bash
python app.py list_patients
Schedule Appointment
```
- Schedule Appointment
```bash
python app.py schedule_appt \
  --caid 1001 \
  --iid 2001 \
  --staff 3001 \
  --dep 4001 \
  --date "2024-01-15" \
  --time "14:30:00" \
  --reason "Regular checkup"
```
- Check Low Stock
```bash
python app.py low_stock
Staff Share Analysis
```
- Staff Share Analysis
```bash
python app.py staff_share
```

### Database Views Usage
- Access Views Directly in MySQL
```sql
-- View upcoming appointments by hospital
SELECT * FROM UpcomingByHospital;

-- Check patient next visits
SELECT * FROM PatientNextVisit;

-- Analyze drug pricing
SELECT * FROM DrugPricingSummary;

-- Monitor staff workload
SELECT * FROM StaffWorkloadThirty;
```

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

## 📝 License
This project was developed for educational purposes as part of the Data Management course at UM6P College of Computing.

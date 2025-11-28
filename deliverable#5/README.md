# Moroccan National Health Services (MNHS) – Mini App

This project is a small command-line application that connects to the **MNHS MySQL database** and runs a few useful commands on top of it (listing patients, scheduling appointments, checking low stock, etc.).

It was built as part of the **Data Management** course (Part VI: Views, Triggers & Application Development).

---

## Features

The CLI currently supports these commands:

1. `list_patients`  
   Print the **first 20 patients** ordered by last name.

2. `schedule_appt`  
   Create a **clinical activity** and a **scheduled appointment** in **one transaction**.

3. `low_stock`  
   List medications **below `ReorderLevel`** per hospital, using a left join so that
   medications **without stock** also appear.

4. `staff_share`  
   For each staff member, compute:
   - total number of appointments
   - percentage share of appointments **within their hospital**

---

## Project Structure

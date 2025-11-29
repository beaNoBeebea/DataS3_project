PatientNextVisit View:
This view displays each patient's next scheduled visit with information about the patient, the department and the hospital.
It does this by joining Patient → ClinicalActivity → Appointment and Department → Hospital 
and only keeping the rows where the appointment is actually scheduled and with a date greater than today's date (fetched with the SQL command CURDATE).
The view contains a nested subquery to find the minimum amongst all dates that verify the previous conditions for a given patient.



patient_delete Trigger:

The patient_delete trigger is a BEFORE DELETE trigger, therefore it is executed each time we try to delete a patient. 
It checks if the patient has any records in Clinical Activities. 
If so, it blocks the deletion and sends an error message that tells the user to make the necessary modifications in the clinical activities table
This trigger protects referential integrity by preventing deletion of patient records that have associated clinical activities.
In other words, it's to make sure that we don't find a clinical activity with a non-existing patient.
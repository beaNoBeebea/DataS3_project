# UpcomingByHospital view:

- The purpose of this view is to provide scheduled appointments for the next 14 days.
- In this view we have used  Appointment joined through ClinicalActivity → Department → Hospital. The view only considers appointments with status ‘Scheduled’ between the current day and the following 14 days. For every hospital and date pair, it returns all hospital details, the clinical activity and the total number of scheduled appointments on that date.


# Reject double booking for a staff member trigger:

- The two triggers reject_double_booking_insert and reject_double_booking_update are implemented to prevent double booking of a staff member for a clinical activity. 
- The INSERT Trigger checks before inserting a new clinical activity if another clinical activity is already assigned to that staff member at the same date and time. If so, an error is raised using a SIGNAL to stop the execution of the statement.
- For the UPDATE Trigger it does a verification before any modification, which means that the only case where the trigger run is when the date, time, or staff member is changed, without this verification the trigger will run even if we try to update unrelated fields.  Not that in the update version we add the condition ‘CAID != OLD.CAID’. This condition tells the trigger to ignore the appointment that is currently updated when checking for problems, for example if I only want to change the time of a clinical activity, without this condition the update would be blocked.
- Together, these two triggers ensure data consistency by ensuring that a staff member cannot perform two different clinical activities at the same time and date.
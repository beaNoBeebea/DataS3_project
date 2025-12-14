-- first index
CREATE INDEX idx1 ON Appointment (Status, CAID);
--how the optimizer could use them?
-- Instead of searching the whole appointment table row by row this index helps 
--us to jump immediately to rows where status ="schedueld is located" and by inlcuding caid 
--it extracts that value for the join operations without the need to retrieve the whole row
--Second index
CREATE INDEX idx2 ON ClinicalActivity (Date, DEP_ID);
--how the optimizer could use them?
--Same as the first index instead of reading every record on Clinicalactivity table it helps us by jumping immediately 
--to the start date until it reaches end date and by including dep_id it provides the values for the join operations

-- i added these two inx to see a bigger difference after running Explain
CREATE INDEX idx3 ON Department(DEP_ID, HID);
CREATE INDEX idx4 ON Hospital(HID, Name);
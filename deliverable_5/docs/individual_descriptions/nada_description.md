# DrugPricingSummary view:

- Without the DrugPricingSummary view, any time we need information about medication pricing, we would need to JOIN twice and group by Hospital and Medication. The view reduces these repeated joins and the grouping logic, making the queries shorter and reusable whenever needed. 



# Expense.Total triggers:

- The triggers automatically recalculate the total expense of a prescription anytime prescription lines are inserted, deleted or updated so that it wouldn’t have to be manually recomputed and risk inconsistencies or mistakes. They also prevent the change when a medication has no current price in Stock ensuring that the total isn’t updated unless all pricing data is valid.
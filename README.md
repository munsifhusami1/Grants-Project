# NJTPAGrantsAnalysis

NJTPA Grants Tracker — SQL Queries

SQL queries written against the NOTIS grants tracking database 
at the North Jersey Transportation Planning Authority (NJTPA), 
supporting federal grant monitoring and reporting across a 
13-county region in northern New Jersey.

## Queries

**Union County Grants — Not Programmed or Obligated**
Identifies awarded federal grants in Union County that have not 
yet been programmed into the Transportation Improvement Program 
(TIP) or obligated for spending — used to flag at-risk grants 
before deadline.

**All Locally Sponsored Projects**
Filters the grants database to isolate locally sponsored projects 
by excluding state agency recipients, supporting subrecipient 
compliance monitoring and outreach tracking.

**FY 2022–2023 Grants with Programmed Status**
Returns all grants awarded in FY 2022 and 2023 with a 
human-readable programmed status flag, used for cycle-specific 
federal reporting periods.

## Context
Outputs from these queries were published via SSRS Report Builder 
for distribution to project managers, county liaisons, and 
executive staff.

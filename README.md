# Grants Project

## Grants Cleanup + ETL Process

This project recreates an ETL process I previously ran manually using Excel and SQL Server at NJTPA. The original grants data has been anonymized — award amounts are scaled by a randomi factor and project titles replaced with placeholder labels to make this data suitable for public sharing.

Purpose: 

First I loaded up pandas, then sqlite3 to store the file, then finalled string to replace labels for all project titles.

Debugging: The initial exploratory data analysis showed me a few things had to change. The title and amount anonymization was needed, but also had to clear up $ signs and commas for all monetary amounts so Pandas could read it. While building this, I ran into a real bug worth documenting: on one pass, I accidentally ran the transform function's multiplication step twice on the same data, which silently doubled the anonymization factor. Separately, I hit a wall where the Award Amount and Total Project Cost columns kept showing up as NaN after conversion — it turned out the dollar signs and commas in the raw values were never stripped out before I called pandas' numeric conversion, so it had nothing valid to convert. I thus has to rewrite the file and double back from the start, where the correction was to first strip $ and , characters first using regular expressions, then convert to numeric, then multiply. I rebuilt the notebook from scratch once to make sure no duplicate or stale function definitions were left over from earlier debugging.

Colab's runtime can carry over old or stale functions which was what caused the issue to persist this long.

Once this was sorted out, I created an extract function to upload the source CSV dataset. Once uploaded, I examined the dataset for what the current Award amounts look like. Then I created a transform function to do a few things.

I picked 3 main columns to work on; for the Award Amounts and Project Costs, I used regular expressions to remove $ signs, commas and any decimals. Then I used pandas to convert all amounts to numeric style. Then I multiplied by 1.3 to anonymize the real figures. Finally for the Project Titles, I created a set of labels to substitute for real project titles using a String function.

Then I used a load function to load up the data into the SQLite storage I created. The load function writes the cleaned, anonymized dataframe into a SQLite database table, so the data is queryable with SQL rather than sitting in a flat file.

Finally, I built a main() function that runs extract, transform, and load in sequence, so the entire pipeline executes with a single function call. This is the structure most real-world ETL pipelines follow.

How to run it

Requires pandas. Place your own CSV in the same format in the working directory, update the filename in the extract() call, and run the script. The pipeline will read the CSV, clean and anonymize it, and write the result to a grants.db SQLite file with a table named grants.


Late May - Early June 2026 

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

# Grants ETL Process


**Timeline - early-mid June 2026 
**

State and regional transportation agencies manage hundreds of active grants across multiple funding programs at the federal level. Tracking each project's award status, expenditure, and compliance with manual data entry across Excel and SQL Server creates reporting delays and data integrity risks. 

This project automates that process, ingesting raw grants data and applying a repeatable cleaning and transformation pipeline. The result is a series of analysis-ready outputs for program reporting and decision-making.

Note: Source data has been anonymized for public sharing, award amounts scaled by a random factor, project titles replaced with placeholders.

## Tools

Considering the sensitivity of government data and PII attached to records, I used Google Colab to keep the process off of internal software, anonymizing all personally identifiable information and real award figures. Colab allows me to share my files externally without any security risks to my employer's own server. I used Python for its data manipulation libraries, such as Pandas, to help me build a repeatable pipeline that avoided any reliance on our proprietary tooling as well. This approach is due to a common constraint of public sector work, as data governance policies prohibit using any external platforms on native data.

Here's the manual process this pipeline replaces: <img width="761" height="906" alt="New ETL flow" src="https://github.com/user-attachments/assets/5f4c1950-3c47-4fc4-ad49-1026333628f9" />

## #FIX STARTING HERE
Purpose: 

First I loaded up pandas, then sqlite3 to store the file, then finalled string to replace labels for all project titles.

Debugging: Initial exploratory data analysis showed me a few things had to change. Each record needed title and amount anonymization, but I also had to clear up $ and , signs for all monetary amounts so Pandas could read it. While building, I ran into a bug: on one pass, I accidentally ran the transform function's multiplication step twice on the same data, which silently doubled the anonymization factor. Separately, I hit a wall where the Award Amount and Total Project Cost columns kept showing up as NaN after conversion. The dollar signs and commas in the raw values were not stripped out before I called pandas' numeric conversion, so it had nothing valid to convert. I thus has to rewrite the file, whrre my correction was to first strip $ and , characters first using regular expressions, then convert to numeric, then multiply by the factor used. I rebuilt this in a new notebook to make sure no duplicate or stale function definitions were left over from earlier debugging.

Colab's runtime can carry over old or stale functions which was what caused the issue to persist this long.

Once this was sorted out, I created an extract function to upload the source CSV dataset. Once uploaded, I examined the dataset for what the current Award amounts look like. 

Then I created a transform function to execute a few tasks. I picked 3 main columns to work on; for the Award Amounts and Project Costs, I used regular expressions to remove $ signs, commas and any decimals. Then I used pandas to convert all amounts to numeric style. Then I multiplied by 1.3 to anonymize the real figures. Finally for the Project Titles, I created a set of labels to substitute for real project titles using a String function.

Finally, I used a load function to load up the data into the SQLite storage I created. The load function writes the cleaned, anonymized dataframe into a SQLite database table, so the data is queryable with SQL rather than sitting in a flat file.

Finally, I built a main() function that runs extract, transform, and load in sequence, so the entire pipeline executes with a single function call. This is the structure most real-world ETL pipelines follow.

## How to run it

Requires pandas. Place your own CSV in the same format in the working directory, update the filename in the extract() call, and run the script. The pipeline will read the CSV, clean and anonymize it, and write the result to a grants.db SQLite file with a table named grants.


## SQL Queries for Reportin
## Timeline - Late-May/Early June 2026

These are some of the SQL queries written against the federal grants tracking database at the North Jersey Transportation Planning Authority (NJTPA), supporting federal grant monitoring and reporting across a 13-county region in northern New Jersey.

I used these queries in SSMS as part of my work at NJTPA, before I began the process of creating an automated pipeline using Python. In that, data has been anonymized (see above)

**Queries**

**Union County Grants — Not Programmed or Obligated**
Identifies awarded federal grants in Union County that have not yet been programmed into the Transportation Improvement Program 
(TIP) or obligated for spending — used to flag at-risk grants before deadline.

**All Locally Sponsored Projects**
Filters the grants database to isolate locally sponsored projects by excluding state agency recipients, supporting subrecipient 
compliance monitoring and outreach tracking.

**FY 2022–2023 Grants with Programmed Status**
Returns all grants awarded in FY 2022 and 2023 with a human-readable programmed status flag, used for cycle-specific federal reporting periods.

## Context
Outputs from the SQL queries were published via SSRS Report Builder for distribution to project managers, county liaisons, and executive staff. The Python automation that follows later cleans up this data for public use.

## How to run it 

Requires the dataset loaded onto any SQL-capable IDE for running each query (I have used SQL Server Management Studio 21 for this before). Query samples have been optimized for readability.

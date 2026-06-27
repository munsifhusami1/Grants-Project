# Grants ETL Process


**Timeline - early-mid June 2026 
**

State and regional transportation agencies manage hundreds of active grants across multiple funding programs at the federal level. Tracking each project's award status, expenditure, and compliance with manual data entry across Excel and SQL Server creates reporting delays and data integrity risks. 

This project automates that process, ingesting raw grants data and applying a repeatable cleaning and transformation pipeline. The result is a series of analysis-ready outputs for program reporting and decision-making.

Note: Source data has been anonymized for public sharing, award amounts scaled by a random factor, project titles replaced with placeholders.

## Tools

Google Colab was selected to keep the pipeline off internal infrastructure, avoiding exposure of proprietary tools and ensuring no security risk to agency systems. All personally identifiable information and real award figures are anonymized prior to any external sharing. Python was chosen for its data manipulation libraries — primarily pandas — enabling a repeatable, portable pipeline without reliance on agency-specific tooling. This reflects a common constraint in public sector work, where data governance policies restrict use of external platforms on native infrastructure.

Here's the manual process this pipeline replaces: <img width="761" height="906" alt="New ETL flow" src="https://github.com/user-attachments/assets/5f4c1950-3c47-4fc4-ad49-1026333628f9" />

## Pipeline Overview

Three libraries support the pipeline: pandas for data processing and transformation, sqlite3 for structured storage, and string for label substitution across project title fields.

Extract: Ingests the source CSV dataset into a pandas dataframe for inspection and transformation.

Transform: Three columns are processed — Award Amount, Total Project Cost, and Project Title. For monetary fields, regular expressions strip currency symbols and formatting characters before pandas converts values to numeric type. A multiplier of 1.3 is then applied to anonymize real financial figures. Project titles are replaced with placeholder labels using a string substitution function to remove identifying metadata.

Load: The cleaned, anonymized dataframe is written to a SQLite database table, making the output queryable via SQL rather than remaining in a flat file.

A main() function runs extract, transform, and load in sequence, executing the full pipeline with a single call — the standard structure for production ETL workflows.

## How to Run

Requires pandas. Place a CSV in the same format in the working directory, update the filename in the extract() call, and run the script. The pipeline outputs a grants.db SQLite file with a table named grants.

## SQL Queries for Reporting

## Timeline — Late May/Early June 2026

The following queries were executed against the federal grants tracking database at the North Jersey Transportation Planning Authority (NJTPA), supporting grant monitoring and reporting across a 13-county region in northern New Jersey. Queries preceded the Python automation pipeline and were run in SSMS for report generation. Data has been anonymized as described above.

## Union County Grants — Not Programmed or Obligated

Identifies awarded federal grants in Union County not yet programmed into the Transportation Improvement Program (TIP) or obligated for spending — used to flag at-risk grants before federal deadlines.

## All Locally Sponsored Projects

Filters the grants database to isolate locally sponsored projects by excluding state agency recipients, supporting subrecipient compliance monitoring and outreach tracking.

## FY 2022–2023 Grants with Programmed Status

Returns all grants awarded in FY 2022 and 2023 with a human-readable programmed status flag, used for cycle-specific federal reporting.

## Context

Query outputs were published via SSRS Report Builder for distribution to project managers, county liaisons, and executive staff. The Python pipeline documented above automates and extends this process for public use.

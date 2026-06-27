# Grants ETL Process


** Timeline - early-mid June 2026 **

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

## Debugging 

Transform functions were run twice during early iterations which resulted in inaccurate multiplication factors. These were rewritten and the code rebuilt in a new notebook to minimize stale function carryover from COlab.

## How to Run

Requires pandas. Place a CSV in the same format in the working directory, update the filename in the extract() call, and run the script. The pipeline outputs a grants.db SQLite file with a table named grants.

## SQL Queries for Reporting

**Timeline — Late May/Early June 2026**

The following queries were executed against the federal grants tracking database at NJTPA, supporting grant monitoring and reporting across a 13-county region in northern New Jersey. Queries preceded the Python automation pipeline and were run in SQL Server Management Studio for report generation. Data has been anonymized as described above.

## Featured query — Union County grant risk flagging

Identifies awarded grants in Union County that remain unprogrammed and unobligated, surfacing at-risk projects before federal spending deadlines. CASE statements convert binary flags into human-readable status fields for distribution to non-technical stakeholders.

```
SELECT 
     [Awarded_FY]
      ,[Agency]
      ,[Funding_Source]
      ,[Project_Title]
      ,[Description_Summary]
      ,[TIP_DBNUM]
      ,[Grant_Type]
      ,[Amount]
      ,CASE
      WHEN Programmed = 1 THEN 'Yes'
      WHEN Programmed = 0 THEN 'No'
      END AS [Programmed]
      ,CASE
      WHEN Obligated = 1 THEN 'Yes'
      WHEN Obligated = 0 THEN 'No'
      END AS [Obligated]
      ,[Municipality]
      ,[Recipient]
FROM dbo.[Grants Tracker]
WHERE County_ies = 'Union'
AND [Programmed] != 1
AND [Obligated] != 1
ORDER BY [Awarded_FY] ASC
```
Additional queries supported FY 2022-2023 cycle reporting and subrecipient compliance monitoring for locally sponsored projects, filtering by obligation status and recipient type respectively.

## Context

Query outputs were published via Power BI Report Builder for distribution to project managers, county liaisons, and executive staff. The Python pipeline documented above automates and extends this process for public use.

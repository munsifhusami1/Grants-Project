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
      END AS [Obligated],
      [Municipality]
      ,[Recipient]
FROM dbo.[Grants Tracker]
WHERE County_ies = 'Union'
AND [Programmed] != 1
AND [Obligated] != 1
ORDER BY [Awarded_FY] ASC
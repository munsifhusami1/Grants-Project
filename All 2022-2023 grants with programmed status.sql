Use NOTIS
SELECT 
     [Awarded_FY]
      ,[Agency]
      ,[Grant_Classification]
      ,[Program]
      ,[Project_Title]
      ,[Description_Summary]
      ,[TIP_DBNUM]
      ,[Grant_Type]
      ,[Amount]
      ,CASE
      WHEN Programmed = 1 THEN 'Yes'
      WHEN Programmed = 0 THEN 'No'
      END AS [Programmed],
      [County_ies]
      ,[Municipality]
      ,[Recipient]
FROM dbo.[Grants Tracker]
WHERE [Awarded_FY] IN ('2022', '2023')
AND [Obligated] != 1
ORDER BY [Awarded_FY] ASC
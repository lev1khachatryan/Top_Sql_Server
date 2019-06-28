-- This comment was added fօr merge
UPDATE dbo.DE_RCSCase
SET CaseNumber = i.CaseNumber
FROM(
SELECT MajorVersion , DE_RCSCase.RCSCaseInstanceID , a.CaseNumber + '-' + CONVERT(NVARCHAR(500), ROW_NUMBER() OVER (PARTITION BY a.CaseNumber ORDER BY DE_RCSCase.RCSCaseInstanceID)) AS CaseNumber, DE_RCSCase.RCSCaseID, a.CaseNumber AS casenum1
FROM dbo.DE_RCSCase JOIN (SELECT CaseNumber , COUNT(*) AS cnt
FROM dbo.DE_RCSCase JOIN dbo.DE_RCSCasePublishedItem ON DE_RCSCasePublishedItem.RCSCaseID = DE_RCSCase.RCSCaseID
--WHERE DE_RCSCase.RCSCaseInstanceID IN 
--(
--SELECT RCSCaseInstanceID  FROM dbo.DE_RCSCase  HAVING COUNT(ROW_NUMBER() OVER (PARTITION BY RCSCaseInstanceID ORDER BY RCSCaseInstanceID )) > 1
--)
GROUP BY CaseNumber
HAVING COUNT(*) > 1
) AS a ON a.CaseNumber = DE_RCSCase.CaseNumber JOIN dbo.DE_RCSCasePublishedItem ON DE_RCSCasePublishedItem.RCSCaseID = DE_RCSCase.RCSCaseID ) AS i JOIN dbo.DE_RCSCase ON DE_RCSCase.RCSCaseInstanceID = i.RCSCaseInstanceID
GO

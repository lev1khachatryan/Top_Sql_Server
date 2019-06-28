
;WITH 
cte1 AS
(
	SELECT ISNULL(MIN(CaseCode), 0) AS MinCode ,  ISNULL(MAX(CaseCode), 0) AS MaxCode , InvestigatingPoliceStationID AS GroupID
	FROM dbo.DE_PoliceCase
	GROUP BY InvestigatingPoliceStationID
),
cte2 AS
(
	SELECT cte1.MinCode , cte1.MaxCode , cte1.GroupID
	FROM cte1
	
	UNION ALL
	
	SELECT cte2.MinCode + 1 AS MinCode , cte2.MaxCode , cte2.GroupID
	FROM cte2    
	WHERE cte2.MaxCode > cte2.MinCode
)
SELECT cte2.MinCode , cte2.GroupID , PC.CaseCode , PC.InvestigatingPoliceStationID
FROM cte2 LEFT JOIN dbo.DE_PoliceCase AS PC
ON cte2.GroupID = PC.InvestigatingPoliceStationID AND cte2.MinCode = PC.CaseCode
WHERE cte2.MinCode <> 0 AND PC.CaseCode IS NULL
ORDER BY cte2.GroupID , cte2.MinCode
OPTION  ( MAXRECURSION 32636 )

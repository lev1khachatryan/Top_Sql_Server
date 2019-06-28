IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name = 'IX_Statistics_Metric' AND object_id = OBJECT_ID('Statistics'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_Statistics_Metric
			ON [Statistics] (Metric, Date)
		include (Value)
    END
go
IF OBJECT_ID('DS_GetStatistics') IS NOT NULL
BEGIN
	DROP PROCEDURE DS_GetStatistics
END
GO
-----------------------------------------
-- Creator	: LKH					   --
-- Date		: 20190412				   --
-- Getting required data for dashboard --
-----------------------------------------
CREATE PROCEDURE DS_GetStatistics
AS
BEGIN
SELECT *
FROM(
	SELECT Metric, Value, Date
	FROM [Statistics]
	WHERE Metric in
	(
	'signups',
	'signups_fb',
	'signups_google',
	'signups_android',
	'signups_android_fb',
	'signups_android_google',
	'signups_ios',
	'signups_ios_fb',
	'signups_ios_google',
	'signups_web',
	'signups_web_fb',
	'signups_web_google'
	)
		) as Pivot_Stat
	PIVOT(
		SUM(Value)
		FOR Metric in (
			[signups],
			[signups_fb],
			[signups_google],
			[signups_android],
			[signups_android_fb],
			[signups_android_google],
			[signups_ios],
			[signups_ios_fb],
			[signups_ios_google],
			[signups_web],
			[signups_web_fb],
			[signups_web_google] )
)AS PivotTable;
END
GO

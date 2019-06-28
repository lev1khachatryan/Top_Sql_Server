IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name = 'IX_UserCheckins_ClientId' AND object_id = OBJECT_ID('UserCheckins'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_UserCheckins_ClientId
			ON UserCheckins (ClientId, Date)
			Include (UserId)
    END
go
IF OBJECT_ID('DS_GetActivityByPlatform') IS NOT NULL
BEGIN
	DROP PROCEDURE DS_GetActivityByPlatform
END
GO
-----------------------------------------
-- Creator	: LKH					   --
-- Date		: 20190423				   --
-- Getting required data for dashboard --
-----------------------------------------
CREATE PROCEDURE DS_GetActivityByPlatform
@StartDate NVARCHAR(50),
@EndDate NVARCHAR(50)
AS
BEGIN
	SET @EndDate = DATEADD(MINUTE, -1, DATEADD(DAY, 1, @EndDate))

	select Case When ClientId = 1114 then 'Android' else 'IOS' end, Count(UC.UserId)
	from UserCheckins as UC
	where UC.Date >= @StartDate and UC.Date <= @EndDate
	and ClientId in (1114, 1122)
	group by ClientId
END
GO

--exec DS_GetActivityByPlatform '20190301', '20190401'

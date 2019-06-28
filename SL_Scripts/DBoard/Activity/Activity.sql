IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name = 'IX_UserCheckins_Date' AND object_id = OBJECT_ID('UserCheckins'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_UserCheckins_Date
			ON [UserCheckins] (Date)
    END
go
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name = 'IX_UserCheckins_UserID' AND object_id = OBJECT_ID('UserCheckins'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_UserCheckins_UserID
			ON [UserCheckins] (UserID)
    END
go
IF OBJECT_ID('DS_GetUserActivities') IS NOT NULL
BEGIN
	DROP PROCEDURE DS_GetUserActivities
END
GO
-----------------------------------------
-- Creator	: LKH					   --
-- Date		: 20190412				   --
-- Getting required data for dashboard --
-----------------------------------------
CREATE PROCEDURE DS_GetUserActivities
@StartDate NVARCHAR(50),
@EndDate NVARCHAR(50),
@TimePeriod int = 1  --  1=per day, 2=per week, 3=per month
--@Platform int = 1 -- 1=Android, 2=IOs
AS
BEGIN
	SET @EndDate = DATEADD(MINUTE, -1, DATEADD(DAY, 1, @EndDate))
	IF @TimePeriod = 1
	BEGIN
		--IF @Platform = 1
		--BEGIN
			select cast(cast(UC.Date as date) as varchar(50)) as Date, Count(DISTINCT UC.UserId) as Checkins
			from UserCheckins as UC
			--JOIN DeviceClients AS DC on UC.UserId = DC.UserId
			where UC.Date >= @StartDate
			and UC.Date <= @EndDate
			--and DC.ClientId = 1114
			group by cast(UC.Date as date)
			order by cast(UC.Date as date)
		--END
		--ELSE IF @Platform = 2
		--BEGIN
		--	select cast(cast(UC.Date as date) as varchar(50)) as Date, Count(DISTINCT UC.UserId) as Checkins
		--	from UserCheckins as UC
		--	JOIN DeviceClients AS DC on UC.UserId = DC.UserId
		--	where UC.Date >= @StartDate
		--	and UC.Date <= @EndDate
		--	and DC.ClientId = 1122
		--	group by cast(UC.Date as date)
		--	order by cast(UC.Date as date)
		--END
	END
	ELSE IF @TimePeriod = 2
	BEGIN
		--IF @Platform = 1
		--BEGIN
			SELECT year(UC.Date) as yr, datepart(wk, Date) as wk,
				cast(year(Date) as varchar(8)) + ' - Week ' + cast(datepart(wk, Date) as varchar(2)) as Date,
				Count(DISTINCT UC.UserID) as Checkins
			FROM UserCheckins as UC
			--join DeviceClients as DC on UC.UserId = DC.UserId
			where UC.Date >= @StartDate
			and UC.Date <= @EndDate
			--and DC.ClientId = 1114
			group by year(UC.Date), datepart(wk, Date)
			order by yr, wk
		--END
		--ELSE IF @Platform = 2
		--BEGIN
		--	SELECT year(UC.Date) as yr, datepart(wk, Date) as wk,
		--		cast(year(Date) as varchar(8)) + ' - Week ' + cast(datepart(wk, Date) as varchar(2)) as Date,
		--		Count(DISTINCT UC.UserID) as Checkins
		--	FROM UserCheckins as UC
		--	join DeviceClients as DC on UC.UserId = DC.UserId
		--	where UC.Date >= @StartDate
		--	and UC.Date <= @EndDate
		--	and DC.ClientId = 1122
		--	group by year(UC.Date), datepart(wk, Date)
		--	order by yr, wk
		--END
	END
	ELSE IF @TimePeriod = 3
	BEGIN
		--IF @Platform = 1
		--BEGIN
			SELECT year(Date) as yr, 
				datename(mm, Date) as mm,   
				cast(year(Date) as varchar(8)) + ' - ' + cast(datename(mm, Date) as varchar(20)) as Date,
				Count(DISTINCT UC.UserID) as Checkins
			FROM UserCheckins as UC
			--JOIN DeviceClients AS DC on DC.UserId = UC.UserId
			where UC.Date >= @StartDate
			and UC.Date <= @EndDate
			--and DC.ClientId = 1114
			group by year(Date), datename(mm, Date)
			order by yr, mm
		--END
		--ELSE IF @Platform = 2
		--BEGIN
		--	SELECT year(Date) as yr, 
		--		datename(mm, Date) as mm,   
		--		cast(year(Date) as varchar(8)) + ' - ' + cast(datename(mm, Date) as varchar(20)) as Date,
		--		Count(DISTINCT UC.UserID) as Checkins
		--	FROM UserCheckins as UC
		--	JOIN DeviceClients AS DC on DC.UserId = UC.UserId
		--	where UC.Date >= @StartDate
		--	and UC.Date <= @EndDate
		--	and DC.ClientId = 1122
		--	group by year(Date), datename(mm, Date)
		--	order by yr, mm
		--END
	END

END
GO

--declare @StartDate NVARCHAR(50) = '20190302'
--declare @EndDate NVARCHAR(50) = '20190401'
--exec DS_GetUserActivities @StartDate, @EndDate, 1

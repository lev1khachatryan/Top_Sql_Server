IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name = 'IX_Users_RegisterDate' AND object_id = OBJECT_ID('Users'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_Users_RegisterDate
			ON [Users] (RegisterDate, CountryCode)
		include (Id)
    END
GO
IF OBJECT_ID('DS_GetCountryCodesForMap') IS NOT NULL
BEGIN
	DROP PROCEDURE DS_GetCountryCodesForMap
END
GO
-----------------------------------------
-- Creator	: LKH					   --
-- Date		: 20190412				   --
-- Getting required data for dashboard --
-----------------------------------------
CREATE PROCEDURE DS_GetCountryCodesForMap
@RegisterStartDate NVARCHAR(50) = NULL,
@RegisterEndDate NVARCHAR(50) = NULL
AS
BEGIN
	SET @RegisterEndDate = DATEADD(MINUTE, -1, DATEADD(DAY, 1, @RegisterEndDate))
	select UPPER(CountryCode) AS CountryCode, Count(U.Id) as CountOfUsers
	from Users as U
	where (U.RegisterDate >= @RegisterStartDate or @RegisterStartDate is null)
	and   (U.RegisterDate <= @RegisterEndDate or @RegisterEndDate is null)
	and CountryCode is not null
	and CountryCode <> ''
	and CountryCode <> '***'
	group by CountryCode
	--order by  CountryCode
END
GO

IF OBJECT_ID('DS_GetTopCountries') IS NOT NULL
BEGIN
	DROP PROCEDURE DS_GetTopCountries
END
GO
-----------------------------------------
-- Creator	: LKH					   --
-- Date		: 20190419				   --
-- Getting required data for dashboard --
-----------------------------------------
-----------------------------------------
CREATE PROCEDURE DS_GetTopCountries
	@StartDate AS VARCHAR(50),
	@EndDate AS VARCHAR(50),
	@By AS INT = 1 -- 1=SignUps, 2=Activities
AS
BEGIN
	SET NOCOUNT ON;
	SET @EndDate = DATEADD(MINUTE, -1, DATEADD(DAY, 1, @EndDate));

	IF @By = 1
	BEGIN
		SELECT TOP(5) CountryCode, COUNT(U.Id) as NumberOf , ROW_NUMBER() OVER(ORDER BY COUNT(U.Id) DESC) AS Place
		FROM Users AS U
		WHERE U.RegisterDate >= @StartDate
		AND U.RegisterDate <= @EndDate
		GROUP BY CountryCode
		ORDER BY COUNT(U.Id) DESC

	END

	ELSE IF @By = 2
	BEGIN
		SELECT 1
		--SELECT TOP(5) CountryCode
		--FROM Users AS U
		--JOIN UserCheckins AS UC ON U.Id = UC.UserId
		--WHERE U.RegisterDate >= @StartDate
		--AND U.RegisterDate <= @EndDate
		--GROUP BY CountryCode
		--ORDER BY COUNT(U.Id) DESC
	END

END
GO

--EXEC DS_GetTopCountries '20190101', '20190401', 1


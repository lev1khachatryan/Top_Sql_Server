IF OBJECT_ID('DS_GetRetentionAndroidData') IS NOT NULL
BEGIN
	DROP PROCEDURE DS_GetRetentionAndroidData
END
GO
-----------------------------------------
-- Creator	: LKH					   --
-- Date		: 20190412				   --
-- Getting required data for dashboard --
-----------------------------------------
CREATE PROCEDURE DS_GetRetentionAndroidData
AS
BEGIN

SELECT  CONCAT(RegistrationYear, '-', RegistrationMonth) as           [Registration Period],
		Cast([1] / NumberOfRegisteredUsers * 100 as DECIMAL(5,2))  as [1st Retention],
		Cast([2] / NumberOfRegisteredUsers * 100 as DECIMAL(5,2))  as [2st Retention],
		Cast([3] / NumberOfRegisteredUsers * 100 as DECIMAL(5,2))  as [3st Retention],
		Cast([4] / NumberOfRegisteredUsers * 100 as DECIMAL(5,2))  as [4st Retention],
		Cast([5] / NumberOfRegisteredUsers * 100 as DECIMAL(5,2))  as [5st Retention],
		Cast([6] / NumberOfRegisteredUsers * 100 as DECIMAL(5,2))  as [6st Retention],
		Cast([7] / NumberOfRegisteredUsers * 100 as DECIMAL(5,2))  as [7st Retention],
		Cast([8] / NumberOfRegisteredUsers * 100 as DECIMAL(5,2))  as [8st Retention],
		Cast([9] / NumberOfRegisteredUsers * 100 as DECIMAL(5,2))  as [9st Retention],
		Cast([10] / NumberOfRegisteredUsers * 100 as DECIMAL(5,2)) as [10st Retention],
		Cast([11] / NumberOfRegisteredUsers * 100 as DECIMAL(5,2)) as [11st Retention],
		Cast([12] / NumberOfRegisteredUsers * 100 as DECIMAL(5,2)) as [12st Retention]
FROM(SELECT RegistrationYear ,
			RegistrationMonth ,
			CohortMonth ,
			CountOfUsers ,
			NumberOfRegisteredUsers
	FROM DSRetentionAndroid
	) as Cohorts
PIVOT(
	SUM(CountOfUsers)
	FOR CohortMonth in (
	[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
	)
)AS PivotTable
order by RegistrationYear,  LEN(cast(RegistrationMonth as nvarchar(10))), RegistrationMonth

end
go
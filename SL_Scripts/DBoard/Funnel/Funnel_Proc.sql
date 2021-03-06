IF OBJECT_ID('DS_GetFunnelDataFunc') IS NOT NULL
BEGIN
	DROP PROCEDURE DS_GetFunnelDataFunc
END
GO
-----------------------------------------
-- Creator	: LKH					   --
-- Date		: 20190412				   --
-- Getting required data for dashboard --
-----------------------------------------
CREATE PROCEDURE [dbo].[DS_GetFunnelDataFunc](
@UserRegistrationStartDate as nvarchar(50), 
@UserRegistrationEndDate as nvarchar(50),
@Platform as int /* 1=Android, 3=IOS */ )
AS
BEGIN
	IF @Platform = 1
	BEGIN
		select COUNT(U.Id) as Signups, 
		COUNT(PI.UserId) as PageImpressions,
		COUNT(S.Id) as Subscriptions, 
		SUM (CASE WHEN DATEDIFF ( DAY , S.StartDate , S.EndDate) > 5 THEN 1 ELSE 0 END ) as Paid
		from Users as U
		join DeviceClients as DC on U.Id = DC.UserId
		left join PageImpressions as PI on U.Id = PI.UserId 
		left join Subscriptions as S on U.Id = S.UserId
		where U.RegisterDate >= @UserRegistrationStartDate
		and U.RegisterDate <= @UserRegistrationEndDate
		and ClientId = 1114
	END
	ELSE IF @Platform = 3
	BEGIN
		select COUNT(U.Id) as Signups, 
		COUNT(PI.UserId) as PageImpressions,
		COUNT(S.Id) as Subscriptions, 
		SUM (CASE WHEN DATEDIFF ( DAY , S.StartDate , S.EndDate) > 5 THEN 1 ELSE 0 END ) as Paid
		from Users as U
		join DeviceClients as DC on U.Id = DC.UserId
		left join PageImpressions as PI on U.Id = PI.UserId 
		left join Subscriptions as S on U.Id = S.UserId
		where U.RegisterDate >= @UserRegistrationStartDate
		and U.RegisterDate <= @UserRegistrationEndDate
		and ClientId = 1122
	END
END;
GO

--EXEC DS_GetFunnelDataFunc '20190301', '20190401', 1

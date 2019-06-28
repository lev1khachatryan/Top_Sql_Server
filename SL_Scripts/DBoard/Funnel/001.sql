IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name = 'IX_Subscriptions_Dates' AND object_id = OBJECT_ID('Subscriptions'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_Subscriptions_Dates
			ON Subscriptions (SubscriptionId, StartDate, EndDate)
		include(UserId)
    END
go

IF OBJECT_ID('DS_GetFunnelDataFunc') IS NOT NULL
BEGIN
	DROP FUNCTION DS_GetFunnelDataFunc
END
GO
-----------------------------------------
-- Creator	: LKH					   --
-- Date		: 20190412				   --
-- Getting required data for dashboard --
-----------------------------------------
CREATE FUNCTION DS_GetFunnelDataFunc(@UserRegistrationStartDate as nvarchar(50), 
								@UserRegistrationEndDate as nvarchar(50),
								@Platform as int /* 1=Android, 3=IOS */ )
    RETURNS @Funnel TABLE (
        UserSignups int,
		ProPageImpressions int,
		Subscriptions int,
		Paid int,
		Annual int
    )
AS
BEGIN
	SET @UserRegistrationEndDate = DATEADD(MINUTE, -1, DATEADD(DAY, 1, @UserRegistrationEndDate))
	IF @Platform = 1
	BEGIN
		INSERT INTO @Funnel (UserSignups, ProPageImpressions, Subscriptions, Paid, Annual  )
		select COUNT(U.Id) as Signups, 
		COUNT(PI.UserId) as PageImpressions,
		COUNT(S.Id) as Subscriptions, 
		SUM (CASE WHEN DATEDIFF ( DAY , S.StartDate , S.EndDate) > 5 THEN 1 ELSE 0 END ) as Paid,
		SUM(CASE WHEN DATEDIFF ( DAY , S.StartDate , S.EndDate) > 5 AND S.SubscriptionId = 'sololearn_pro_annual' then 1 else 0 end) as annual
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
		INSERT INTO @Funnel (UserSignups, ProPageImpressions, Subscriptions, Paid, Annual  )
		select COUNT(U.Id) as Signups, 
		COUNT(PI.UserId) as PageImpressions,
		COUNT(S.Id) as Subscriptions, 
		SUM (CASE WHEN DATEDIFF ( DAY , S.StartDate , S.EndDate) > 5 THEN 1 ELSE 0 END ) as Paid,
		SUM(CASE WHEN DATEDIFF ( DAY , S.StartDate , S.EndDate) > 5 AND S.SubscriptionId = 'sololearn_pro_annual' then 1 else 0 end) as annual
		from Users as U
		join DeviceClients as DC on U.Id = DC.UserId
		left join PageImpressions as PI on U.Id = PI.UserId 
		left join Subscriptions as S on U.Id = S.UserId
		where U.RegisterDate >= @UserRegistrationStartDate
		and U.RegisterDate <= @UserRegistrationEndDate
		and ClientId = 1122
	END

    RETURN;
END;
go

IF OBJECT_ID('DS_GetUserConsumption') is not null
begin
	drop procedure DS_GetUserConsumption
end
go
-----------------------------------------
-- Creator	: LKH					   --
-- Date		: 20190412				   --
-- Getting required data for dashboard --
-----------------------------------------
CREATE PROCEDURE [dbo].[DS_GetUserConsumption]
	@startDate as nvarchar(100),
	@endDate as nvarchar(100)
AS
BEGIN
select *
FROM(select Date, Metric, UserId
	from StatisticsActiveUsers
	where date >= @startDate and date<= @endDate and metric  in (
	'active_users',
	'course_lessons_consumers',
	'user_lessons_consumers',
	'user_codes_consumers',
	'user_posts_consumers',
	'discuss_consumers',
	'contest_players',
	'profiles_consumers',
	'own_profiles_consumers'
	)
	) as ddxk
PIVOT(
	COUNT( UserId)
	FOR Metric in (
	[active_users],
	[course_lessons_consumers],
	[user_lessons_consumers],
	[user_codes_consumers],
	[user_posts_consumers],
	[discuss_consumers],
	[contest_players],
	[profiles_consumers],
	[own_profiles_consumers]
	)
)AS PivotTable
end
go
IF OBJECT_ID('DS_Consumption_DailyTotalActivityConsumers') IS NOT NULL
BEGIN
	DROP PROCEDURE DS_Consumption_DailyTotalActivityConsumers
END
GO
CREATE PROCEDURE [dbo].[DS_Consumption_DailyTotalActivityConsumers]
		@StartDate date,
		@EndDate date
AS BEGIN
select Date, Metric, count(DISTINCT UserId) as NofUsers from [StatisticsActiveUsers]
where date >= @StartDate and date<= @EndDate and metric in ('course_lessons_consumers',
															'user_lessons_consumers',
															'user_codes_consumers',
															'discuss_consumers',
															'user_posts_consumers',
															'profiles_consumers',
															'own_profiles_consumers',
															'contest_players')
group by date, metric
order by date, metric
END;
GO
IF OBJECT_ID('DS_Consumption_DailyTotalActivities') IS NOT NULL
BEGIN
	DROP PROCEDURE DS_Consumption_DailyTotalActivities
END
GO
CREATE PROCEDURE [dbo].[DS_Consumption_DailyTotalActivities]
		@StartDate date,
		@EndDate date
AS BEGIN
select * from [Statistics]
where date >= @StartDate and date<= @EndDate and metric in ('course_lessons_consumed',
															'user_lessons_consumed',
															'user_codes_consumed',
															'discuss_consumed',
															'user_posts_consumed',
															'profiles_consumed',
															'own_profiles_consumed',
															'contests_played')
order by date, metric
END;
GO
IF OBJECT_ID('DS_Consumption_LearnSocial') IS NOT NULL
BEGIN
	DROP PROCEDURE DS_Consumption_LearnSocial
END
GO
CREATE PROCEDURE [dbo].[DS_Consumption_LearnSocial]
		@StartDate date,
		@EndDate date

AS BEGIN
select U.UserId,
		(case when LC.UserId > 0 then 1 else 0 end) as Lesson_Consumers,
		(case when SC.UserId > 0 then 1 else 0 end) as Social_Content_Consumers
			from
	(select DISTINCT UserId from StatisticsActiveUsers
		where date >= @StartDate and date<= @EndDate and metric = 'active_users') as U
LEFT JOIN
	(select DISTINCT UserId from StatisticsActiveUsers
		where date >= @StartDate and date<= @EndDate and metric = 'course_lessons_consumers') as LC
		on U.UserId=LC.UserId
LEFT JOIN
	(select DISTINCT UserId from StatisticsActiveUsers
		where date >= @StartDate and date<= @EndDate and metric in ('user_codes_consumers',
																	'discuss_consumers',
																	'user_posts_consumers',
																	'profiles_consumers',
																	'contest_players')) as SC
		on U.UserId=SC.UserId
END;
GO

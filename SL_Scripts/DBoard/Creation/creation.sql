IF OBJECT_ID('DS_Creation') IS NOT NULL
BEGIN
	DROP PROCEDURE DS_Creation
END
GO
CREATE PROCEDURE [dbo].[DS_Creation]
		@StartDate date,
		@EndDate date

AS BEGIN
	select Cast(CreatedDate as Date) as Date , 'Created Codes' as metric, 
	SUM(cast(IsPublic as int)) as Published,
	SUM(Case when cast(IsPublic as int) = 0 then 1 else 0 end) as NotPublished
	from UserCodes as UC 
	where UC.CreatedDate between @StartDate and @EndDate
	group by Cast(CreatedDate as Date)

	UNION ALL
	select Cast(Date as Date) as Date, 'Created Posts' as metric, 
	SUM(Case when cast(Status as int) = 0 then 1 else 0 end) as Published,
	SUM(Case when cast(Status as int) <> 0 then 1 else 0 end) as NotPublished
	from UserPosts as UP 
	where UP.Date between @StartDate and @EndDate
	group by Cast(Date as Date)

	UNION ALL
	select Cast(Date as Date) as Date, 'Created Discussions' as metric, 
	SUM(Case when cast(Status as int) = 0 then 1 else 0 end) as Published,
	SUM(Case when cast(Status as int) <> 0 then 1 else 0 end) as NotPublished
	from DiscussionPosts as DP 
	where DP.Date between @StartDate and @EndDate
	group by Cast(Date as Date)

	UNION ALL
	select Cast(Date as Date) as Date, 'Created Lessons' as metric, 
	SUM(cast(Published as int)) as Published,
	SUM(Case when cast(Published as int) = 0 then 1 else 0 end) as NotPublished
	from UserLessons as UL 
	where UL.Date between @StartDate and @EndDate
	group by Cast(Date as Date)

	UNION ALL
	select Cast(Date as Date) as Date, 'Created Quizzes' as metric, 
	SUM(cast(Published as int)) as Published,
	SUM(Case when cast(Published as int) = 0 then 1 else 0 end) as NotPublished
	from Challenges as C 
	where C.Date between @StartDate and @EndDate
	group by Cast(Date as Date)
	order by Metric, Date;
END;
GO
--
--

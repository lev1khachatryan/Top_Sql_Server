--select ranked.CourseId, 
--		ranked.UserId,
--		ranked.StartDate,
--		ranked.CompletionDate,
--		ranked.duration,
--		cast(ranked.position as decimal(10,4)) / cast(ranked.all_count as decimal(10,4)) as rnk 
--from(
--	select unique_users_durations.CourseId, 
--				unique_users_durations.UserId,
--				unique_users_durations.StartDate,
--				unique_users_durations.CompletionDate, 
--				unique_users_durations.duration,
--				row_number() over(partition by unique_users_durations.CourseID order by unique_users_durations.duration ASC)as position,
--				count(unique_users_durations.CourseID) over(partition by unique_users_durations.CourseID order by unique_users_durations.CourseID ASC) as all_count
--	from(
--		select durations.CourseId,
--				durations.UserId, 
--				StartDate,
--				CompletionDate,
--				durations.duration,
--				ROW_NUMBER() over(partition by durations.CourseID, durations.UserID order by durations.CourseID, durations.UserID ASC)as rnmb 
--		from (
--			select distinct UC.CourseID, 
--							UC.UserID, 
--							StartDate,
--							CompletionDate,
--							DateDiff(MINUTE, UC.StartDate, UC.CompletionDate) as duration
--			from UserCourses as UC
--			where IsCompleted = 1 
--			and StartDate is not null
--			and CompletionDate is not null
--			and DateDiff(MINUTE, UC.StartDate, UC.CompletionDate) >= 0
--		) as durations
--	) as unique_users_durations
--	where unique_users_durations.rnmb = 1
--) as ranked


CREATE TABLE #rankedusers 
  ( 
     courseid     INT, 
     userid       INT, 
     startdate    DATETIME, 
     completedate DATETIME, 
     duration     INT, 
     rnk          DECIMAL(10, 2) 
  ) 

truncate table #rankedusers
insert into #rankedusers
select ranked.CourseId,
		ranked.UserId,
		ranked.StartDate,
		ranked.CompleteDate, 
		ranked.duration,
		cast(ranked.position as decimal(10,4)) / cast(ranked.all_count as decimal(10,4)) as rnk 
from(
	select unique_users_durations.CourseId, 
				unique_users_durations.UserId,
				unique_users_durations.StartDate,
				unique_users_durations.CompleteDate, 
				unique_users_durations.duration,
				row_number() over(partition by unique_users_durations.CourseID order by unique_users_durations.duration ASC)as position,
				count(unique_users_durations.CourseID) over(partition by unique_users_durations.CourseID order by unique_users_durations.CourseID ASC) as all_count
	from(
		select durations.CourseId,
				durations.UserId, 
				durations.StartDate,
				durations.CompleteDate ,
				durations.duration,
				ROW_NUMBER() over(partition by durations.CourseID, durations.UserID order by durations.CourseID, durations.UserID ASC)as rnmb 
		from (
			select UC.CourseID, 
							UC.UserID,
							UC.StartDate,
							for_complete_date.CompleteDate, 
							DateDiff(MINUTE, UC.StartDate, for_complete_date.CompleteDate) as duration 
			from UserCourses as UC
			join (
				SELECT LI.userid, 
					   LastLessonOfCourse.courseid, 
					   Min(LI.date) AS CompleteDate 
				FROM   lessonimpressions AS LI 
					   JOIN(SELECT M.courseid, 
								   L.id AS LessonID 
							FROM   lessons AS L 
								   JOIN modules AS M 
									 ON L.moduleid = M.id 
								   JOIN (SELECT M.courseid, 
												Max(L.number) AS max_Number 
										 FROM   lessons AS L 
												JOIN modules AS M 
												  ON L.moduleid = M.id 
										 WHERE  M.courseid IN ( 1089, 1080, 1051, 1023, 
																1014, 1068, 1024, 1082, 
																1059, 1073, 1081, 1060, 1075 ) -- courses
										 GROUP  BY M.courseid) AS max_Numbers 
									 ON max_Numbers.max_number = L.number 
										AND max_Numbers.courseid = M.courseid)AS 
						   LastLessonOfCourse 
						 ON LI.lessonid = LastLessonOfCourse.lessonid 
				GROUP  BY LI.userid, 
						  LastLessonOfCourse.courseid
			) as for_complete_date on for_complete_date.CourseId = UC.CourseId
									and for_complete_date.UserId = UC.UserId
			where IsCompleted = 1 
			and StartDate is not null
			and CompletionDate is not null
			and DateDiff(MINUTE, UC.StartDate, for_complete_date.CompleteDate) >= 0
		) as durations
	) as unique_users_durations
	where unique_users_durations.rnmb = 1
) as ranked

--SELECT C.id                   AS COurseId, 
--       C.NAME                 AS CourseName, 
--       Count(ranked.duration) AS NumberOfUsers, 
--       Avg(ranked.duration)   AS AverageDuration, 
--       Concat('avg ', Avg(ranked.duration), ',  # ', Count(ranked.duration)) 
--FROM   rankedusers AS ranked 
--       JOIN courses AS C 
--         ON ranked.courseid = C.id 
--WHERE  ispublished = 1 
--       AND rnk <= 0.1 -- sa 10 % , 1 %-i depqum orinak 0.01 
--GROUP  BY C.id, 
--          C.NAME 
--ORDER  BY C.NAME 



CREATE TABLE #topusers10 
  ( 
     userid       INT, 
     completedate DATETIME 
  ) 

INSERT INTO #topusers10 
SELECT userid, 
       Min(completedate) AS CompleteDate 
FROM   (SELECT ranked.userid, 
               ranked.completedate 
        FROM   rankedusers AS ranked 
               JOIN courses AS C 
                 ON ranked.courseid = C.id 
        WHERE  ispublished = 1 
               AND rnk <= 0.1 -- sa 10 % , 1 %-i depqum orinak 0.01 
       ) AS tp 
GROUP  BY tp.userid 


-- Retention

SELECT count(userid),
		Avg(countof) 
FROM  (SELECT tp.userid, 
              Count(DISTINCT Cast(UC.date AS DATE)) AS CountOf 
       FROM   #topusers10 AS tp 
              JOIN usercheckins AS UC 
                ON UC.userid = tp.userid 
       WHERE  UC.date >= Dateadd(day, 1, tp.completedate) 
              AND UC.date <= Dateadd(month, 1, tp.completedate) 
       GROUP  BY tp.userid) AS ddkx 


-- Learners

select count(UserID),
		avg(CountOfLessonImpression)
from (
	select all_users.UserID, 
			COUNT( distinct ULI.Date) + COUNT( distinct LI.Date) as CountOfLessonImpression
	from #topusers10 as all_users
	left join UserLessonImpressions as ULI on all_users.UserID = ULI.UserId
		and ULI.Date <= DATEADD(MONTH, 1, all_users.CompleteDate)
		and ULI.Date >= DATEADD(DAY, 1, all_users.CompleteDate)
	left join LessonImpressions as LI on all_users.UserID = LI.UserId
		and LI.Date <= DATEADD(MONTH, 1, all_users.CompleteDate)
		and LI.Date >= DATEADD(DAY, 1, all_users.CompleteDate)
	group by all_users.UserID
	having (COUNT( distinct ULI.Date) + COUNT( distinct LI.Date)) >= 3
) as ddxk
option (maxdop 3)

-- OR

SELECT Count(learn.userid), 
       Avg(learn.cnt) 
FROM   (SELECT lesson.userid, 
               lesson.countoflesson 
               + userlesson.countofuserlesson AS cnt 
        FROM   (SELECT all_users.userid, 
                       Count(li.userid) AS countoflesson 
                FROM   #topusers10 AS all_users 
                       LEFT JOIN lessonimpressions AS li 
                              ON all_users.userid = li.userid 
                                 AND li.date <= Dateadd(week, 1, 
                                                all_users.completedate) 
                                 AND li.date >= Dateadd(day, 1, 
                                                all_users.completedate) 
                GROUP  BY all_users.userid) AS lesson 
               LEFT JOIN (SELECT all_users.userid, 
                                 Count(uli.userid) AS countofUserlesson 
                          FROM   #topusers10 AS all_users 
                                 LEFT JOIN userlessonimpressions AS uli 
                                        ON all_users.userid = uli.userid 
                                           AND uli.date <= Dateadd(week, 1, 
											all_users.completedate) 
											AND uli.date >= Dateadd(day, 1, 
											all_users.completedate) 
											GROUP  BY all_users.userid) AS userlesson 
ON lesson.userid = userlesson.userid) AS learn 
WHERE  learn.cnt >= 3 

-- Social

SELECT Count(social.userid), 
       Avg(social.cnt) 
FROM  (SELECT Play.userid, 
              Post.countofpost + Code.countofcode 
              + Discussion.countofdiscussion AS cnt 
       FROM   (SELECT all_users.userid, 
                      Count(CU.userid) AS CountOfPlay 
               FROM   #topusers10 AS all_users 
                      LEFT JOIN ContestUsers AS CU 
                             ON all_users.userid = CU.userid 
                                AND CU.StatusDate <= Dateadd(week, 1, 
                                                    all_users.completedate) 
                                AND CU.StatusDate >= Dateadd(day, 1, 
                                                    all_users.completedate)
			   WHERE CU.Status = 6 or CU.Result in (1,2,8)  
               GROUP  BY all_users.userid) AS Play 
              LEFT JOIN (SELECT all_users.userid, 
                                Count(CU.userid) AS CountOfPost 
                         FROM   #topusers10 AS all_users 
                                LEFT JOIN userpostimpressions AS CU 
                                       ON all_users.userid = CU.userid 
                                          AND CU.date <= Dateadd(week, 1, 
                                                         all_users.completedate) 
                                          AND CU.date >= Dateadd(day, 1, 
                                                         all_users.completedate) 
                         GROUP  BY all_users.userid) AS Post 
                     ON Play.userid = Post.userid 
              LEFT JOIN (SELECT all_users.userid, 
                                Count(CU.userid) AS CountOfCode 
                         FROM   #topusers10 AS all_users 
                                LEFT JOIN usercodeimpressions AS CU 
                                       ON all_users.userid = CU.userid 
                                          AND CU.date <= Dateadd(week, 1, 
                                                         all_users.completedate) 
                                          AND CU.date >= Dateadd(day, 1, 
                                                         all_users.completedate) 
                         GROUP  BY all_users.userid) AS Code 
                     ON Play.userid = Code.userid 
              LEFT JOIN (SELECT all_users.userid, 
                                Count(CU.userid) AS CountOfDiscussion 
                         FROM   #topusers10 AS all_users 
                                LEFT JOIN discussionpostimpressions AS CU 
                                       ON all_users.userid = CU.userid 
                                          AND CU.date <= Dateadd(week, 1, 
                                                         all_users.completedate) 
                                          AND CU.date >= Dateadd(day, 1, 
                                                         all_users.completedate) 
                         GROUP  BY all_users.userid) AS Discussion 
                     ON Play.userid = Discussion.userid) AS social 
WHERE  social.cnt >= 3 



-- Nothing Doers

SELECT Count(*) 
FROM   #topusers10 AS all_users 
WHERE  NOT EXISTS (SELECT 1 
                   FROM   userlessonimpressions AS ULI 
                   WHERE  ULI.userid = all_users.userid 
                          AND ULI.date <= Dateadd(month, 1, 
                                          all_users.completedate) 
                          AND ULI.date >= Dateadd(day, 1, 
                                          all_users.completedate)) 
       AND NOT EXISTS (SELECT 1 
                       FROM   lessonimpressions AS LI 
                       WHERE  LI.userid = all_users.userid 
                              AND LI.date <= Dateadd(month, 1, 
                                             all_users.completedate) 
                              AND LI.date >= Dateadd(day, 1, 
                                             all_users.completedate)) 
       AND NOT EXISTS (SELECT 1 
                       FROM   contestusers AS CU 
                       WHERE  ( CU.status = 6 
                                 OR CU.result IN ( 1, 2, 8 ) ) 
                              AND all_users.userid = CU.userid 
                              AND CU.statusdate <= Dateadd(month, 1, 
                                                   all_users.completedate) 
                              AND CU.statusdate >= Dateadd(day, 1, 
                                                   all_users.completedate)) 
       AND NOT EXISTS (SELECT 1 
                       FROM   userpostimpressions AS UPI 
                       WHERE  UPI.userid = all_users.userid 
                              AND UPI.date <= Dateadd(month, 1, 
                                              all_users.completedate) 
                              AND UPI.date >= Dateadd(day, 1, 
                                              all_users.completedate)) 
       AND NOT EXISTS (SELECT 1 
                       FROM   usercodeimpressions AS UCI 
                       WHERE  UCI.userid = all_users.userid 
                              AND UCI.date <= Dateadd(month, 1, 
                                              all_users.completedate) 
                              AND UCI.date >= Dateadd(day, 1, 
                                              all_users.completedate)) 
       AND NOT EXISTS (SELECT 1 
                       FROM   discussionpostimpressions AS DPI 
                       WHERE  DPI.userid = all_users.userid 
                              AND DPI.date <= Dateadd(month, 1, 
                                              all_users.completedate) 
                              AND DPI.date >= Dateadd(day, 1, 
                                              all_users.completedate)) 

-- random 100 US user from top 5 percent
create table #top5
(
UserID int
)
truncate table #top5
insert into #top5
select userid
from (
SELECT top(100) *
FROM  (SELECT userid, 
              Min(completedate) AS CompleteDate 
       FROM   (SELECT ranked.userid, 
                      ranked.completedate 
               FROM   #rankedusers AS ranked 
                      JOIN courses AS C 
                        ON ranked.courseid = C.id 
               WHERE  ispublished = 1 
                      AND rnk <= 0.05 -- sa 10 % , 1 %-i depqum orinak 0.01  
              ) AS tp 
       GROUP  BY tp.userid) AS top5 
      JOIN users AS U 
        ON U.id = top5.userid 
WHERE  U.countrycode = 'US'
order by newid()
) as sub

select u.id as UserID, 
		U.RegisterDate,
		max(UC.Date) as LastActiveDate
from #top5 as t
join users as u on t.UserID = u.id
join UserCheckins as UC on u.ID = UC.UserId
group by U.Id, U.RegisterDate


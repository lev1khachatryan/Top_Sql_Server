CREATE TABLE #TopUsers 
  ( 
     userid       INT, 
     completedate DATETIME 
  )
insert into #TopUsers
select u.ID as UserID, 
		u.RegisterDate as RegisterDate
from users as u
where --u.RegisterDate between '20180501' and '20180601'
--and 
U.CountryCode = 'US'


create table #Top20Lessons
(
UserID int
)
insert into #Top20Lessons
SELECT learn.userid
FROM   (SELECT lesson.userid, 
               lesson.countoflesson 
               + userlesson.countofuserlesson AS cnt 
        FROM   (SELECT all_users.userid, 
                       Count(li.userid) AS countoflesson 
                FROM   #TopUsers AS all_users 
                       LEFT JOIN lessonimpressions AS li 
                              ON all_users.userid = li.userid 
                                 AND li.date <= Dateadd(week, 1, 
                                                all_users.completedate) 
                                 AND li.date >= Dateadd(day, 1, 
                                                all_users.completedate) 
                GROUP  BY all_users.userid) AS lesson 
               LEFT JOIN (SELECT all_users.userid, 
                                 Count(uli.userid) AS countofUserlesson 
                          FROM   #TopUsers AS all_users 
                                 LEFT JOIN userlessonimpressions AS uli 
                                        ON all_users.userid = uli.userid 
                                           AND uli.date <= Dateadd(week, 1, 
											all_users.completedate) 
											AND uli.date >= Dateadd(day, 1, 
											all_users.completedate) 
											GROUP  BY all_users.userid) AS userlesson 
ON lesson.userid = userlesson.userid) AS learn 
WHERE  learn.cnt >= 20

CREATE TABLE #topusers10 
  ( 
     userid       INT, 
     completedate DATETIME 
  )
insert into #topusers10
select u.ID, u.RegisterDate
from #Top20Lessons as l
join Users as u on l.UserID = U.ID



--create table #toptop
--(
--userid int
--)
--insert into #toptop
--SELECT social.userid 
--FROM  (SELECT Play.userid, 
--              Post.countofpost + Code.countofcode 
--              + Discussion.countofdiscussion AS cnt 
--       FROM   (SELECT all_users.userid, 
--                      Count(CU.userid) AS CountOfPlay 
--               FROM   #topusers10 AS all_users 
--                      LEFT JOIN ContestUsers AS CU 
--                             ON all_users.userid = CU.userid 
--                                AND CU.StatusDate <= Dateadd(week, 1, 
--                                                    all_users.completedate) 
--                                AND CU.StatusDate >= Dateadd(day, 1, 
--                                                    all_users.completedate)
--			   WHERE CU.Status = 6 or CU.Result in (1,2,8)  
--               GROUP  BY all_users.userid) AS Play 
--              LEFT JOIN (SELECT all_users.userid, 
--                                Count(CU.userid) AS CountOfPost 
--                         FROM   #topusers10 AS all_users 
--                                LEFT JOIN userpostimpressions AS CU 
--                                       ON all_users.userid = CU.userid 
--                                          AND CU.date <= Dateadd(week, 1, 
--                                                         all_users.completedate) 
--                                          AND CU.date >= Dateadd(day, 1, 
--                                                         all_users.completedate) 
--                         GROUP  BY all_users.userid) AS Post 
--                     ON Play.userid = Post.userid 
--              LEFT JOIN (SELECT all_users.userid, 
--                                Count(CU.userid) AS CountOfCode 
--                         FROM   #topusers10 AS all_users 
--                                LEFT JOIN usercodeimpressions AS CU 
--                                       ON all_users.userid = CU.userid 
--                                          AND CU.date <= Dateadd(week, 1, 
--                                                         all_users.completedate) 
--                                          AND CU.date >= Dateadd(day, 1, 
--                                                         all_users.completedate) 
--                         GROUP  BY all_users.userid) AS Code 
--                     ON Play.userid = Code.userid 
--              LEFT JOIN (SELECT all_users.userid, 
--                                Count(CU.userid) AS CountOfDiscussion 
--                         FROM   #topusers10 AS all_users 
--                                LEFT JOIN discussionpostimpressions AS CU 
--                                       ON all_users.userid = CU.userid 
--                                          AND CU.date <= Dateadd(week, 1, 
--                                                         all_users.completedate) 
--                                          AND CU.date >= Dateadd(day, 1, 
--                                                         all_users.completedate) 
--                         GROUP  BY all_users.userid) AS Discussion 
--                     ON Play.userid = Discussion.userid) AS social 
--WHERE  social.cnt >= 5

--select u.ID as UserID, u.RegisterDate, max(UC.Date) as LastActiveDate
--from #toptop as t
--join users as u on t.userid = u.Id
--join UserCheckins as UC on u.ID = UC.UserId
--group by U.Id, U.RegisterDate

--
-- Code only
--
create table #toptop
(
userid int
)
insert into #toptop
SELECT social.userid 
FROM  (SELECT Play.userid, 
              Post.countofpost + Code.countofcode 
              + Discussion.countofdiscussion AS cnt 
       FROM   (SELECT all_users.userid, 
                      0 AS CountOfPlay 
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
                                0 AS CountOfPost 
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
                                0 AS CountOfDiscussion 
                         FROM   #topusers10 AS all_users 
                                LEFT JOIN discussionpostimpressions AS CU 
                                       ON all_users.userid = CU.userid 
                                          AND CU.date <= Dateadd(week, 1, 
                                                         all_users.completedate) 
                                          AND CU.date >= Dateadd(day, 1, 
                                                         all_users.completedate) 
                         GROUP  BY all_users.userid) AS Discussion 
                     ON Play.userid = Discussion.userid) AS social 
WHERE  social.cnt >= 5

select u.ID as UserID, u.RegisterDate, max(UC.Date) as LastActiveDate
from #toptop as t
join users as u on t.userid = u.Id
join UserCheckins as UC on u.ID = UC.UserId
group by U.Id, U.RegisterDate





select top(200) u.id as UserID,
		u.RegisterDate,
		max(UC.Date) as LastActiveDate 
from(
select distinct ddxk.userid
from(
select id as userid
from users as u
where CountryCode = 'US'
except
select userID
from ##topusers10
) as ddxk
except
select userid
from #toptop
) as sub
join users as u on u.id = sub.userid
join UserCheckins as UC on UC.UserId = u.ID
group by u.id, u.RegisterDate
order by newid()

select *
from ##topusers10

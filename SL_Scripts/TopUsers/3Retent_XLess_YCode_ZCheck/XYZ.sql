-- All Users registered in specific date range
drop table topusers
CREATE TABLE topusers 
  ( 
     userid       INT constraint pk primary key clustered, 
     completedate DATETIME 
  ) 

INSERT INTO topusers 
SELECT u.id           AS UserID, 
       u.registerdate AS RegisterDate 
FROM   users AS u 
WHERE  u.registerdate BETWEEN '20180501' AND '20180601' -- 376397 
and CountryCode = 'us'


-- All Users have reteined in specific month
CREATE TABLE topusers2
  ( 
     userid       INT , 
     completedate DATETIME ,
	 checkinday int
  )
--truncate table topusers2 

--create nonclustered index IX_UserCheckins_Date on UserCheckins(Date)
--include (userid)

insert into topusers2
SELECT tp.userid, 
       tp.completedate, 
       count(distinct cast(uc.date as date)) as checkinsdays
FROM   topusers AS tp 
       JOIN UserCheckins AS uc 
         ON tp.userid = uc.userid 
WHERE  uc.Date BETWEEN Dateadd(month, 3, tp.completedate) AND 
                                    Dateadd(month, 4, tp.completedate)
group by tp.userid, tp.completedate


-- All Users have Specific number of lesson learned
drop table topusers2
drop table topusers2_tmp

create table topusers2_tmp
(
UserID int
)
insert into topusers2_tmp
SELECT learn.userid
FROM   (SELECT lesson.userid, 
               lesson.countoflesson 
               + userlesson.countofuserlesson AS cnt 
        FROM   (SELECT all_users.userid, 
                       Count(li.userid) AS countoflesson 
                FROM   topusers AS all_users 
                       LEFT JOIN lessonimpressions AS li 
                              ON all_users.userid = li.userid 
                                 AND li.date <= Dateadd(month, 3, 
                                                all_users.completedate) 
                                 --AND li.date >= Dateadd(day, 1, 
                                 --               all_users.completedate) 
                GROUP  BY all_users.userid) AS lesson 
               LEFT JOIN (SELECT all_users.userid, 
                                 Count(uli.userid) AS countofUserlesson 
                          FROM   topusers AS all_users 
                                 LEFT JOIN userlessonimpressions AS uli 
                                        ON all_users.userid = uli.userid 
                                           AND uli.date <= Dateadd(month, 3, 
											all_users.completedate) 
											--AND uli.date >= Dateadd(day, 1, 
											--all_users.completedate) 
											GROUP  BY all_users.userid) AS userlesson 
ON lesson.userid = userlesson.userid) AS learn 
WHERE  learn.cnt >= 20

CREATE TABLE topusers2 
  ( 
     userid       INT, 
     completedate DATETIME 
  )
insert into topusers2
select u.ID, u.RegisterDate
from topusers2_tmp as l
join Users as u on l.UserID = U.ID


-- All Users have specific number of code impressed
--create table #topusers4
--(
--userid int
--)
--insert into #topusers4

SELECT count(social.userid )
FROM  (SELECT Play.userid, 
              Post.countofpost + Code.countofcode 
              + Discussion.countofdiscussion AS cnt 
       FROM   (SELECT all_users.userid, 
                      0 AS CountOfPlay 
               FROM   topusers2 AS all_users 
                      LEFT JOIN ContestUsers AS CU 
                             ON all_users.userid = CU.userid 
                                AND CU.StatusDate <= Dateadd(month, 3, 
                                                    all_users.completedate) 
                                --AND CU.StatusDate >= Dateadd(day, 1, 
                                --                    all_users.completedate)
			   WHERE CU.Status = 6 or CU.Result in (1,2,8)  
               GROUP  BY all_users.userid) AS Play 
              LEFT JOIN (SELECT all_users.userid, 
                                0 AS CountOfPost 
                         FROM   topusers2 AS all_users 
                                LEFT JOIN userpostimpressions AS CU 
                                       ON all_users.userid = CU.userid 
                                          AND CU.date <= Dateadd(month, 3, 
                                                         all_users.completedate) 
                                          --AND CU.date >= Dateadd(day, 1, 
                                          --               all_users.completedate) 
                         GROUP  BY all_users.userid) AS Post 
                     ON Play.userid = Post.userid 
              LEFT JOIN (SELECT all_users.userid, 
                                Count(CU.userid) AS CountOfCode 
                         FROM   topusers2 AS all_users 
                                LEFT JOIN usercodeimpressions AS CU 
                                       ON all_users.userid = CU.userid 
                                          AND CU.date <= Dateadd(month, 3, 
                                                         all_users.completedate) 
                                          --AND CU.date >= Dateadd(day, 1, 
                                          --               all_users.completedate) 
                         GROUP  BY all_users.userid) AS Code 
                     ON Play.userid = Code.userid 
              LEFT JOIN (SELECT all_users.userid, 
                                0 AS CountOfDiscussion 
                         FROM   topusers2 AS all_users 
                                LEFT JOIN discussionpostimpressions AS CU 
                                       ON all_users.userid = CU.userid 
                                          AND CU.date <= Dateadd(month, 3, 
                                                         all_users.completedate) 
                                          --AND CU.date >= Dateadd(day, 1, 
                                          --               all_users.completedate) 
                         GROUP  BY all_users.userid) AS Discussion 
                     ON Play.userid = Discussion.userid) AS social 
WHERE  social.cnt >= 10

 
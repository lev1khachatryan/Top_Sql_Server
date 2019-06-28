
--CREATE TABLE #period 
--  ( 
--     period  INT, 
--	 checkin INT,
--     social  INT, 
--     learn   INT, 
--     nothing INT 
--  ) 

---- checkin
--SELECT 1 AS period, 
--		Count(DISTINCT c.userid) 
--FROM   #cohort AS c 
--WHERE  EXISTS (SELECT 1 
--               FROM   usercheckins AS UC 
--               WHERE  UC.date BETWEEN Dateadd(month, 1, c.registerdate) AND 
--                                              Dateadd(month, 2, c.registerdate) 
--                      AND UC.userid = c.userid) 

---- Learn
--SELECT Count(userid) 
--FROM   (SELECT all_users.userid, 
--               Count( DISTINCT ULI.date) 
--               + Count( DISTINCT LI.date) AS CountOfLessonImpression 
--        FROM   #cohort AS all_users 
--               LEFT JOIN userlessonimpressions AS ULI 
--                      ON all_users.userid = ULI.userid 
--                         AND ULI.date BETWEEN Dateadd(month, 1, 
--                                              all_users.registerdate) 
--                                              AND 
--                                              Dateadd(month, 2, 
--                         all_users.registerdate) 
--               LEFT JOIN lessonimpressions AS LI 
--                      ON all_users.userid = LI.userid 
--                         AND LI.date BETWEEN Dateadd(month, 1, 
--                                             all_users.registerdate) 
--                                             AND 
--                                             Dateadd(month, 2, 
--                         all_users.registerdate) 
--        GROUP  BY all_users.userid 
--        HAVING ( Count( DISTINCT ULI.date) 
--                 + Count( DISTINCT LI.date) ) >= 3) AS ddxk 
--OPTION (maxdop 3) 



---- Social
--SELECT Count(social.userid)
--FROM  (SELECT Play.userid, 
--              CountOfPlay + Post.countofpost + Code.countofcode 
--              + Discussion.countofdiscussion AS cnt 
--       FROM   (SELECT all_users.userid, 
--                      Count(CU.userid) AS CountOfPlay 
--               FROM   #cohort AS all_users 
--                      LEFT JOIN ContestUsers AS CU 
--                             ON all_users.userid = CU.userid 
--                                AND CU.StatusDate between dateadd(month, 10, all_users.registerdate) 
--													and dateadd(month, 11, all_users.registerdate)
--			   WHERE CU.Status = 6 or CU.Result in (1,2,8)  
--               GROUP  BY all_users.userid) AS Play 
--              LEFT JOIN (SELECT all_users.userid, 
--                                Count(CU.userid) AS CountOfPost 
--                         FROM   #cohort AS all_users 
--                                LEFT JOIN userpostimpressions AS CU 
--                                       ON all_users.userid = CU.userid 
--                                          AND CU.date between dateadd(month, 10, all_users.registerdate) 
--														and dateadd(month, 11, all_users.registerdate) 
--                         GROUP  BY all_users.userid) AS Post 
--                     ON Play.userid = Post.userid 
--              LEFT JOIN (SELECT all_users.userid, 
--                                Count(CU.userid) AS CountOfCode 
--                         FROM   #cohort AS all_users 
--                                LEFT JOIN usercodeimpressions AS CU 
--                                       ON all_users.userid = CU.userid 
--                                          AND CU.date between dateadd(month, 10, all_users.registerdate) 
--														and dateadd(month, 11, all_users.registerdate) 
--                         GROUP  BY all_users.userid) AS Code 
--                     ON Play.userid = Code.userid 
--              LEFT JOIN (SELECT all_users.userid, 
--                                Count(CU.userid) AS CountOfDiscussion 
--                         FROM   #cohort AS all_users 
--                                LEFT JOIN discussionpostimpressions AS CU 
--                                       ON all_users.userid = CU.userid 
--                                          AND CU.date between dateadd(month, 10, all_users.registerdate) 
--														and dateadd(month, 11, all_users.registerdate) 
--                         GROUP  BY all_users.userid) AS Discussion 
--                     ON Play.userid = Discussion.userid) AS social 
--WHERE  social.cnt >= 3

---- Nothing Doers

--SELECT Count(*) 
--FROM   #cohort AS all_users 
--WHERE  NOT EXISTS (SELECT 1 
--                   FROM   userlessonimpressions AS ULI 
--                   WHERE  ULI.userid = all_users.userid 
--                          AND ULI.date between dateadd(month, 1, all_users.registerdate) 
--														and dateadd(month, 2, all_users.registerdate)) 
--       AND NOT EXISTS (SELECT 1 
--                       FROM   lessonimpressions AS LI 
--                       WHERE  LI.userid = all_users.userid 
--                              AND LI.date between dateadd(month, 1, all_users.registerdate) 
--														and dateadd(month, 2, all_users.registerdate)) 
--       AND NOT EXISTS (SELECT 1 
--                       FROM   contestusers AS CU 
--                       WHERE  ( CU.status = 6 
--                                 OR CU.result IN ( 1, 2, 8 ) ) 
--                              AND all_users.userid = CU.userid 
--                              AND CU.statusdate between dateadd(month, 1, all_users.registerdate) 
--														and dateadd(month, 2, all_users.registerdate)) 
--       AND NOT EXISTS (SELECT 1 
--                       FROM   userpostimpressions AS UPI 
--                       WHERE  UPI.userid = all_users.userid 
--                              AND UPI.date between dateadd(month, 1, all_users.registerdate) 
--														and dateadd(month, 2, all_users.registerdate)) 
--       AND NOT EXISTS (SELECT 1 
--                       FROM   usercodeimpressions AS UCI 
--                       WHERE  UCI.userid = all_users.userid 
--                              AND UCI.date between dateadd(month, 1, all_users.registerdate) 
--														and dateadd(month, 2, all_users.registerdate)) 
--       AND NOT EXISTS (SELECT 1 
--                       FROM   discussionpostimpressions AS DPI 
--                       WHERE  DPI.userid = all_users.userid 
--                              AND DPI.date between dateadd(month, 1, all_users.registerdate) 
--														and dateadd(month, 2, all_users.registerdate))
--	   --AND EXISTS (SELECT 1
--				--   FROM UserCheckins AS UC
--				--   WHERE UC.UserId = all_users.userid
--				--		 AND UC.)

--

CREATE TABLE #cohort 
  ( 
     userid       INT, 
     registerdate DATETIME 
  ) 

truncate table #cohort
INSERT INTO #cohort 
SELECT DISTINCT A.userid AS UserId, 
                A.activitydate 
FROM   activities AS A 
WHERE  A.activitydate BETWEEN '20180401' AND '20180501' 
       AND A.clientid = 1114 
       AND A.activitytype = 4 

select count(*)
from #cohort


--create table #checkin
--(
--UserID int,
--RegisterDate datetime
--)

--create table cohortPeriods
--(
--userid int,
--period int,
--countofplay int,
--countofpost int,
--countofcode int,
--countofdiscussion int,
--countoflesson int,
--countofuserlesson int
--)

truncate table cohortPeriods

declare @period as int = 1
while @period <= 12
begin
	truncate table #checkin
	insert into #checkin
	SELECT DISTINCT all_users.userid, 
							all_users.registerdate 
			FROM   #cohort AS all_users 
				   JOIN usercheckins AS UC 
					 ON UC.userid = all_users.userid 
			WHERE  UC.date BETWEEN Dateadd(month, @period, all_users.registerdate) AND 
								   Dateadd( 
								   month, @period + 1, 
								   all_users.registerdate)
	insert into cohortPeriods
	SELECT    c.userid,
			  @period,
			  play.countofplay,
			  post.countofpost,
			  code.countofcode,
			  discussion.countofdiscussion,
			  lesson.countoflesson,
			  userlesson.countofuserlesson
	FROM      #checkin AS c 
	LEFT JOIN 
			  ( 
						SELECT    all_users.userid, 
								  Count(cu.userid) AS countofplay 
						FROM      #checkin         AS all_users 
						LEFT JOIN contestusers     AS cu 
						ON        all_users.userid = cu.userid 
						AND       cu.statusdate BETWEEN Dateadd(month, @period, all_users.registerdate) AND Dateadd(month, @period+1, all_users.registerdate)
						WHERE     cu.status = 6 
						OR        cu.result IN (1,2,8) 
						GROUP BY  all_users.userid ) AS play 
	ON        c.userid = play.userid 
	LEFT JOIN 
			  ( 
						SELECT    all_users.userid, 
								  Count(cu.userid)    AS countofpost 
						FROM      #checkin             AS all_users 
						LEFT JOIN userpostimpressions AS cu 
						ON        all_users.userid = cu.userid 
						AND       cu.date BETWEEN Dateadd(month, @period, all_users.registerdate) AND Dateadd(month, @period+1, all_users.registerdate)
						GROUP BY  all_users.userid) AS post 
	ON        c.userid = post.userid 
	LEFT JOIN 
			  ( 
						SELECT    all_users.userid, 
								  Count(cu.userid)    AS countofcode 
						FROM      #checkin             AS all_users 
						LEFT JOIN usercodeimpressions AS cu 
						ON        all_users.userid = cu.userid 
						AND       cu.date BETWEEN Dateadd(month, @period, all_users.registerdate) AND       Dateadd(month, @period+1, all_users.registerdate)
						GROUP BY  all_users.userid) AS code 
	ON        c.userid = code.userid 
	LEFT JOIN 
			  ( 
						SELECT    all_users.userid, 
								  Count(cu.userid)          AS countofdiscussion 
						FROM      #checkin                   AS all_users 
						LEFT JOIN discussionpostimpressions AS cu 
						ON        all_users.userid = cu.userid 
						AND       cu.date BETWEEN Dateadd(month, @period, all_users.registerdate) AND       Dateadd(month, @period+1, all_users.registerdate)
						GROUP BY  all_users.userid) AS discussion 
	ON        c.userid = discussion.userid
	LEFT JOIN 
			  ( 
						SELECT    all_users.userid, 
								  Count(li.userid)          AS countoflesson
						FROM      #checkin                   AS all_users 
						LEFT JOIN LessonImpressions AS li 
						ON        all_users.userid = li.userid 
						AND       li.date BETWEEN Dateadd(month, @period, all_users.registerdate) AND       Dateadd(month, @period+1, all_users.registerdate)
						GROUP BY  all_users.userid) AS lesson 
	ON        c.userid = lesson.userid
	LEFT JOIN 
			  ( 
						SELECT    all_users.userid, 
								  Count(uli.userid)          AS countofuserlesson 
						FROM      #checkin                   AS all_users 
						LEFT JOIN UserLessonImpressions AS uli 
						ON        all_users.userid = uli.userid 
						AND       uli.date BETWEEN Dateadd(month, @period, all_users.registerdate) AND       Dateadd(month, @period+1, all_users.registerdate)
						GROUP BY  all_users.userid) AS userlesson 
	ON        c.userid = userlesson.userid
	SET @period = @period + 1
end
go


select *
from cohortPeriods

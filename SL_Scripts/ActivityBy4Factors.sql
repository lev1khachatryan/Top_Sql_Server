DROP TABLE topusers
CREATE TABLE TopUsers
(
UserID int,
RegisterDate Date
)
INSERT INTO TopUsers
select Distinct U.Id as UserID, 
				U.RegisterDate
from Users as U
join DeviceClients as DC on U.Id = DC.UserId
where U.CountryCode = 'US' and 
		DC.ClientId = 1114 and
		U.RegisterDate between '20180901' and '20191201'
GO


----------------
---- Lesson ----
----------------
SELECT count(distinct userid), 
		avg(cnt)
FROM   (SELECT lesson.userid, 
               lesson.countoflesson 
               + userlesson.countofuserlesson AS cnt 
        FROM   (SELECT all_users.userid, 
                       Count(li.userid) AS countoflesson 
                FROM   topusers AS all_users 
                       LEFT JOIN lessonimpressions AS li 
                              ON all_users.userid = li.userid 
                                 AND li.date <= Dateadd(week, 1, 
                                                all_users.registerdate) 
                GROUP  BY all_users.userid) AS lesson 
               LEFT JOIN (SELECT all_users.userid, 
                                 Count(uli.userid) AS countofUserlesson 
                          FROM   topusers AS all_users 
                                 LEFT JOIN userlessonimpressions AS uli 
                                        ON all_users.userid = uli.userid 
                                           AND uli.date <= Dateadd(week, 1, 
											all_users.registerdate) 
											GROUP  BY all_users.userid) AS userlesson 
ON lesson.userid = userlesson.userid) AS learn 
where cnt > 0


------------------
---- Social_1 ----
------------------
SELECT count(distinct userid), 
		avg(cnt)
FROM   (SELECT code.userid, 
               code.countofcode,
               + post.countofpost
			   + discussion.countofdiscussion AS cnt 
        FROM   (SELECT all_users.userid, 
                       Count(uci.userid) AS countofcode 
                FROM   topusers AS all_users 
                       LEFT JOIN UserCodeImpressions AS uci 
                              ON all_users.userid = uci.userid 
                                 AND uci.date <= Dateadd(month, 1, 
                                                all_users.registerdate) 
                GROUP  BY all_users.userid) AS code
               LEFT JOIN (SELECT all_users.userid, 
								   Count(upi.userid) AS countofpost
							FROM   topusers AS all_users 
								   LEFT JOIN UserPostImpressions AS upi 
										  ON all_users.userid = upi.userid 
											 AND upi.date <= Dateadd(month, 1, 
															all_users.registerdate) 
							GROUP  BY all_users.userid) AS post
				ON code.userid = post.userid
				LEFT JOIN (SELECT all_users.userid, 
								   Count(dpi.userid) AS countofdiscussion
							FROM   topusers AS all_users 
								   LEFT JOIN DiscussionPostImpressions AS dpi
										  ON all_users.userid = dpi.userid 
											 AND dpi.date <= Dateadd(month, 1, 
															all_users.registerdate) 
							GROUP  BY all_users.userid) AS discussion
				ON code.userid = discussion.userid ) as social_1
where cnt >= 3


------------------
---- Social_2 ----
------------------
SELECT count(distinct userid), 
		avg(cnt)
FROM   (SELECT contest.userid, 
               contest.countofcontest,
               + ownprofile.countofownprofile
			   + profile.countofprofile as cnt 
        FROM   (SELECT all_users.userid, 
                       Count(cu.userid) AS countofcontest 
                FROM   topusers AS all_users 
                       LEFT JOIN ContestUsers AS cu 
                              ON all_users.userid = cu.userid 
                                 AND cu.StatusDate <= Dateadd(week, 1, 
                                                all_users.registerdate)
				WHERE (CU.Status = 6 or CU.Result in (1,2,8) )
                GROUP  BY all_users.userid) AS contest
                LEFT JOIN (SELECT all_users.userid, 
								   Count(opi.userid) AS countofownprofile
							FROM   topusers AS all_users 
								   LEFT JOIN ProfileImpressions AS opi 
										  ON all_users.userid = opi.userid 
											 AND opi.date <= Dateadd(week, 1, 
															all_users.registerdate)
											and opi.Date > all_users.RegisterDate
							where opi.ProfileId = opi.UserId
							GROUP  BY all_users.userid) AS ownprofile
				ON contest.userid = ownprofile.userid
				LEFT JOIN (SELECT all_users.userid, 
								   Count(pimpr.userid) AS countofprofile
							FROM   topusers AS all_users 
								   LEFT JOIN ProfileImpressions AS pimpr 
										  ON all_users.userid = pimpr.userid 
											 AND pimpr.date <= Dateadd(week, 1, 
															all_users.registerdate)
											and pimpr.Date > all_users.RegisterDate
							where pimpr.ProfileId <> pimpr.UserId
							GROUP  BY all_users.userid) AS profile
				ON contest.userid = profile.userid ) as social_2
where cnt >= 3


----------------------------------------
-- Overlap between Learn and Social_1 --
----------------------------------------
select count(distinct UserID)
from (
	SELECT distinct userid
	FROM   (SELECT lesson.userid, 
				   lesson.countoflesson 
				   + userlesson.countofuserlesson AS cnt 
			FROM   (SELECT all_users.userid, 
						   Count(li.userid) AS countoflesson 
					FROM   topusers AS all_users 
						   LEFT JOIN lessonimpressions AS li 
								  ON all_users.userid = li.userid 
									 AND li.date <= Dateadd(week, 1, 
													all_users.registerdate) 
					GROUP  BY all_users.userid) AS lesson 
				   LEFT JOIN (SELECT all_users.userid, 
									 Count(uli.userid) AS countofUserlesson 
							  FROM   topusers AS all_users 
									 LEFT JOIN userlessonimpressions AS uli 
											ON all_users.userid = uli.userid 
											   AND uli.date <= Dateadd(week, 1, 
												all_users.registerdate) 
												GROUP  BY all_users.userid) AS userlesson 
	ON lesson.userid = userlesson.userid) AS learn 
	where cnt > 3
	intersect
	SELECT distinct userid
	FROM   (SELECT code.userid, 
				   code.countofcode,
				   + post.countofpost
				   + discussion.countofdiscussion AS cnt 
			FROM   (SELECT all_users.userid, 
						   Count(uci.userid) AS countofcode 
					FROM   topusers AS all_users 
						   LEFT JOIN UserCodeImpressions AS uci 
								  ON all_users.userid = uci.userid 
									 AND uci.date <= Dateadd(week, 1, 
													all_users.registerdate) 
					GROUP  BY all_users.userid) AS code
				   LEFT JOIN (SELECT all_users.userid, 
									   Count(upi.userid) AS countofpost
								FROM   topusers AS all_users 
									   LEFT JOIN UserPostImpressions AS upi 
											  ON all_users.userid = upi.userid 
												 AND upi.date <= Dateadd(week, 1, 
																all_users.registerdate) 
								GROUP  BY all_users.userid) AS post
					ON code.userid = post.userid
					LEFT JOIN (SELECT all_users.userid, 
									   Count(dpi.userid) AS countofdiscussion
								FROM   topusers AS all_users 
									   LEFT JOIN DiscussionPostImpressions AS dpi
											  ON all_users.userid = dpi.userid 
												 AND dpi.date <= Dateadd(WEEK, 1, 
																all_users.registerdate) 
								GROUP  BY all_users.userid) AS discussion
					ON code.userid = discussion.userid ) as social_1
	where cnt >= 3

) as all_users


----------------------------------------
-- Overlap between Learn and Social_2 --
----------------------------------------
select count(distinct UserID)
from (
	SELECT distinct userid
	FROM   (SELECT lesson.userid, 
				   lesson.countoflesson 
				   + userlesson.countofuserlesson AS cnt 
			FROM   (SELECT all_users.userid, 
						   Count(li.userid) AS countoflesson 
					FROM   topusers AS all_users 
						   LEFT JOIN lessonimpressions AS li 
								  ON all_users.userid = li.userid 
									 AND li.date <= Dateadd(month, 1, 
													all_users.registerdate) 
					GROUP  BY all_users.userid) AS lesson 
				   LEFT JOIN (SELECT all_users.userid, 
									 Count(uli.userid) AS countofUserlesson 
							  FROM   topusers AS all_users 
									 LEFT JOIN userlessonimpressions AS uli 
											ON all_users.userid = uli.userid 
											   AND uli.date <= Dateadd(month, 1, 
												all_users.registerdate) 
												GROUP  BY all_users.userid) AS userlesson 
	ON lesson.userid = userlesson.userid) AS learn 
	where cnt > 3
	intersect
	SELECT distinct userid
	FROM   (SELECT contest.userid, 
				   contest.countofcontest,
				   + ownprofile.countofownprofile
				   + profile.countofprofile as cnt 
			FROM   (SELECT all_users.userid, 
						   Count(cu.userid) AS countofcontest 
					FROM   topusers AS all_users 
						   LEFT JOIN ContestUsers AS cu 
								  ON all_users.userid = cu.userid 
									 AND cu.StatusDate <= Dateadd(month, 1, 
													all_users.registerdate)
					WHERE (CU.Status = 6 or CU.Result in (1,2,8) )
					GROUP  BY all_users.userid) AS contest
					LEFT JOIN (SELECT all_users.userid, 
									   Count(opi.userid) AS countofownprofile
								FROM   topusers AS all_users 
									   LEFT JOIN ProfileImpressions AS opi 
											  ON all_users.userid = opi.userid 
												 AND opi.date <= Dateadd(month, 1, 
																all_users.registerdate)
												and opi.Date > all_users.RegisterDate
								where opi.ProfileId = opi.UserId
								GROUP  BY all_users.userid) AS ownprofile
					ON contest.userid = ownprofile.userid
					LEFT JOIN (SELECT all_users.userid, 
									   Count(pimpr.userid) AS countofprofile
								FROM   topusers AS all_users 
									   LEFT JOIN ProfileImpressions AS pimpr 
											  ON all_users.userid = pimpr.userid 
												 AND pimpr.date <= Dateadd(month, 1, 
																all_users.registerdate)
												and pimpr.Date > all_users.RegisterDate
								where pimpr.ProfileId <> pimpr.UserId
								GROUP  BY all_users.userid) AS profile
					ON contest.userid = profile.userid ) as social_2
	where cnt >= 3

) as all_users


----------------------------------------
-- Overlap between Social_1 and Social_2 --
----------------------------------------
select count(distinct UserID)
from (
	SELECT distinct userid
	FROM   (SELECT code.userid, 
				   code.countofcode,
				   + post.countofpost
				   + discussion.countofdiscussion AS cnt 
			FROM   (SELECT all_users.userid, 
						   Count(uci.userid) AS countofcode 
					FROM   topusers AS all_users 
						   LEFT JOIN UserCodeImpressions AS uci 
								  ON all_users.userid = uci.userid 
									 AND uci.date <= Dateadd(month, 1, 
													all_users.registerdate) 
					GROUP  BY all_users.userid) AS code
				   LEFT JOIN (SELECT all_users.userid, 
									   Count(upi.userid) AS countofpost
								FROM   topusers AS all_users 
									   LEFT JOIN UserPostImpressions AS upi 
											  ON all_users.userid = upi.userid 
												 AND upi.date <= Dateadd(month, 1, 
																all_users.registerdate) 
								GROUP  BY all_users.userid) AS post
					ON code.userid = post.userid
					LEFT JOIN (SELECT all_users.userid, 
									   Count(dpi.userid) AS countofdiscussion
								FROM   topusers AS all_users 
									   LEFT JOIN DiscussionPostImpressions AS dpi
											  ON all_users.userid = dpi.userid 
												 AND dpi.date <= Dateadd(month, 1, 
																all_users.registerdate) 
								GROUP  BY all_users.userid) AS discussion
					ON code.userid = discussion.userid ) as social_1
	where cnt >= 3
	intersect
	SELECT distinct userid
	FROM   (SELECT contest.userid, 
				   contest.countofcontest,
				   + ownprofile.countofownprofile
				   + profile.countofprofile as cnt 
			FROM   (SELECT all_users.userid, 
						   Count(cu.userid) AS countofcontest 
					FROM   topusers AS all_users 
						   LEFT JOIN ContestUsers AS cu 
								  ON all_users.userid = cu.userid 
									 AND cu.StatusDate <= Dateadd(month, 1, 
													all_users.registerdate)
					WHERE (CU.Status = 6 or CU.Result in (1,2,8) )
					GROUP  BY all_users.userid) AS contest
					LEFT JOIN (SELECT all_users.userid, 
									   Count(opi.userid) AS countofownprofile
								FROM   topusers AS all_users 
									   LEFT JOIN ProfileImpressions AS opi 
											  ON all_users.userid = opi.userid 
												 AND opi.date <= Dateadd(month, 1, 
																all_users.registerdate)
												and opi.Date > all_users.RegisterDate
								where opi.ProfileId = opi.UserId
								GROUP  BY all_users.userid) AS ownprofile
					ON contest.userid = ownprofile.userid
					LEFT JOIN (SELECT all_users.userid, 
									   Count(pimpr.userid) AS countofprofile
								FROM   topusers AS all_users 
									   LEFT JOIN ProfileImpressions AS pimpr 
											  ON all_users.userid = pimpr.userid 
												 AND pimpr.date <= Dateadd(month, 1, 
																all_users.registerdate)
												and pimpr.Date > all_users.RegisterDate
								where pimpr.ProfileId <> pimpr.UserId
								GROUP  BY all_users.userid) AS profile
					ON contest.userid = profile.userid ) as social_2
	where cnt >= 3

) as all_users

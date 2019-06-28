if OBJECT_ID('DSRetentionIOS') is not null
begin
	drop table DSRetentionIOS
end
go
create table DSRetentionIOS
(
RegistrationYear nvarchar(20),
RegistrationMonth nvarchar(10),
CohortMonth int,
CountOfUsers int,
NumberOfRegisteredUsers int
)
go


DECLARE @year as nvarchar(10) = '2018'
DECLARE @cnt as int = 1


WHILE @cnt <= 2
BEGIN

	DECLARE @RegistrationMonth int = 1
	WHILE @RegistrationMonth <= 12
		BEGIN

		DECLARE @cohort INT = 1;
		DECLARE @date INT = 30;
		WHILE @cohort <= 12 AND @date <= 360
		BEGIN
			insert into DSRetentionIOS (RegistrationYear, RegistrationMonth,CohortMonth , CountOfUsers)
			SELECT YEAR(U.RegisterDate) as RegistrationYear,
					MONTH(U.RegisterDate) as RegistrationMonth, 
						@cohort as CohortMonth, 
						count(Distinct U.ID) as CountOfUsers
			FROM Users as U
			join DeviceClients as DC on U.Id = DC.UserID
			where ClientId = 1122 and
			YEAR(U.RegisterDate) = @year and
			MONTH(U.RegisterDate) = @RegistrationMonth and exists
			(
			select 1
			from UserCheckins as UC
			where UC.UserId = U.Id and
			DATEDIFF(DAY,U.RegisterDate, UC.Date ) between @date and @date + 30
			)
			group by YEAR(U.RegisterDate), MONTH(U.RegisterDate)
		
		   SET @cohort = @cohort + 1;
		   SET @date = @date + 30;
		END;

		SET @RegistrationMonth = @RegistrationMonth + 1;
	END;

	update cohort
	set NumberOfRegisteredUsers = sub.overall_number_of_users
	from DSRetentionIOS as cohort
	join (
	select YEAR(U.RegisterDate) as Year_RegisterDate, MONTH(U.RegisterDate) as Month_RegisterDate,  COUNT(distinct U.Id) AS overall_number_of_users
	from Users as U
	join DeviceClients as DC on U.Id = DC.UserId
	where ClientId = 1122 and
	YEAR(U.RegisterDate) = @year
	group by YEAR(U.RegisterDate), MONTH(U.RegisterDate)
	) as sub on cohort.RegistrationYear = sub.Year_RegisterDate and cohort.RegistrationMonth = sub.Month_RegisterDate
	WHERE cohort.NumberOfRegisteredUsers is null

	SET @cnt = @cnt + 1;
	SET @year = '2019'
END
GO
ALTER TABLE DSRetentionIOS
ALTER COLUMN NumberOfRegisteredUsers DECIMAL(10,2)
go

SELECT *
INTO DSRetentionIOSCopy
FROM DSRetentionIOS

delete
from DSRetentionIOS
where RegistrationMonth + CohortMonth  = 16
or (RegistrationYear = 2019 and (RegistrationMonth + CohortMonth = 4) )

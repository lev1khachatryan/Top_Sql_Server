USE [msdb]
GO

/****** Object:  Job [Disk_space_free_ddxk]    Script Date: 1/18/2018 12:17:42 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 1/18/2018 12:17:42 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Disk_space_free_ddxk', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sis', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [asf]    Script Date: 1/18/2018 12:17:42 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'asf', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'
		create table #DriveSpaceLeft (Drive varchar(10),
                              [MB Free] bigint )

insert #DriveSpaceLeft (Drive, [MB Free])
   EXEC master.dbo.xp_fixeddrives;

create table DrivesWithIssue (Drive varchar(10),
                              [MB Free] bigint )

insert into DrivesWithIssue 
  select Drive, [MB Free] from #DriveSpaceLeft
  where [MB Free] < 100000

drop table #DriveSpaceLeft

declare @cnt int  
select @cnt=COUNT(1) from DrivesWithIssue
if (@cnt > 0)
begin

	declare @strsubject varchar(100)
	select @strsubject=''Check drive space on '' + @@SERVERNAME

	declare @tableHTML  nvarchar(max);
	set @tableHTML =
		N''<H3>Drives with less that 100GB Free  - '' + @@SERVERNAME + ''</H3>'' +
		N''<table border="1">'' +
		N''<tr><th>Drive</th>'' +
		N''<th>MB Free</th></tr>'' +
		CAST ( ( SELECT td = [Drive], '''',
	                    td = [MB Free]
				  FROM DrivesWithIssue
				  FOR XML PATH(''tr''), TYPE 
		) AS NVARCHAR(MAX) ) +
		N''</table>'' ;

	EXEC msdb.dbo.sp_send_dbmail
	
	@recipients=''levon.khachatryan@synisys.com'',
	@subject = @strsubject,
	@body = @tableHTML,
	@body_format = ''HTML'' ,
	@profile_name=''DBA''
end

drop table DrivesWithIssue', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'sis', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=15, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20140619, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'599d84fb-aec8-441a-b84f-10f1fd3989f7'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


--
--
--
--
--

create table #DriveSpaceLeft (Drive varchar(10),
                              [MB Free] bigint )

insert #DriveSpaceLeft (Drive, [MB Free])
   EXEC master.dbo.xp_fixeddrives;

SELECT *
FROM #DriveSpaceLeft

create table DrivesWithIssue (Drive varchar(10),
                              [MB Free] bigint )

insert into DrivesWithIssue 
  select Drive, [MB Free] from #DriveSpaceLeft
  where [MB Free] < 5000

drop table #DriveSpaceLeft

declare @cnt int  
select @cnt=COUNT(1) from DrivesWithIssue
if (@cnt > 0)
begin

	declare @strsubject varchar(100)
	select @strsubject='Check drive space on ' + @@SERVERNAME

	declare @tableHTML  nvarchar(max);
	set @tableHTML =
		N'<H3>Drives with less that 4GB Free  - ' + @@SERVERNAME + '</H3>' +
		N'<table border="1">' +
		N'<tr><th>Drive</th>' +
		N'<th>MB Free</th></tr>' +
		CAST ( ( SELECT td = [Drive], '',
	                    td = [MB Free]
				  FROM DrivesWithIssue
				  FOR XML PATH('tr'), TYPE 
		) AS NVARCHAR(MAX) ) +
		N'</table>' ;

	EXEC msdb.dbo.sp_send_dbmail
	
	@recipients='levon.khachatryan@synisys.com',
	@subject = @strsubject,
	@body = @tableHTML,
	@body_format = 'HTML' ,
	@profile_name='DBA'
end


drop table DrivesWithIssue

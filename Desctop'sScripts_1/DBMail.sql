--sp_configure 'show advanced' , 1;
--go
--reconfigure;
--go
--sp_configure;
--go

sp_configure 'Database mail XPs' ,1
go
reconfigure
go

--sp_configure 'show advanced' ,0
--go
--RECONFIGURE




SELECT *
FROM [msdb].dbo.sysmail_mailitems
--GO
--SELECT *
--FROM [msdb].dbo.sysmail_log

--GO

--SELECT *
--FROM [msdb].dbo.sysmail_account

--SELECT *
--FROM [msdb].dbo.sysmail_profile

--SELECT *
--FROM [msdb].dbo.sysmail_mailitems




---- stugenq unenq send anelu role te voch

--exec msdb.sys.sp_helprolemember 'DatabaseMailUserRole'
--go

--sp_addrolemember @rolename = 'DatabaseMailUserRole'
--   ,@membername = '';

--go
--EXEC msdb.dbo.sysmail_help_principalprofile_sp;

--EXEC msdb.dbo.sysmail_help_status_sp;

--EXEC msdb.dbo.sysmail_help_queue_sp @queue_type = 'mail';

-----------------------

---- Create a Database Mail account
--EXECUTE msdb.dbo.sysmail_add_account_sp
--    @account_name = 'SIS2S082 Administrator LKH',
--    @description = 'Mail account for administrative e-mail.',
--    @email_address = 'LKH@synisys.com',
--    @replyto_address = 'danw@synisys.com',
--    @display_name = ' Automated Mailer',
--    @mailserver_name = 'smtp.synisys.com' ;

---- Create a Database Mail profile
--EXECUTE msdb.dbo.sysmail_add_profile_sp
--    @profile_name = 'SIS2S082 Administrator Profile LKH',
--    @description = 'Profile used for administrative mail.' ;

---- Add the account to the profile
--EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
--    @profile_name = 'SIS2S082 Administrator Profile LKH',
--    @account_name = 'SIS2S082 Administrator LKH',
--    @sequence_number =1 ;

---- Grant access to the profile to the DBMailUsers role
--EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
--    @profile_name = 'SIS2S082 Administrator Profile LKH',
--    @principal_name = 'SIS\levon.khachatryan',
--    @is_default = 1 ;

-----------------------------------------------
-- public account sarqelu hamar 


EXEC [msdb].dbo.sp_send_dbmail @profile_name = 'DBA', -- sysname
    @recipients = 'levon.khachatryan@synisys.com', -- varchar(max)
    --@copy_recipients = '', -- varchar(max)
    --@blind_copy_recipients = '', -- varchar(max)
    @subject = N'valod', -- nvarchar(255)
    @body = N'DDXK' , -- nvarchar(max)
    --@body_format = '', -- varchar(20)
    --@importance = '', -- varchar(6)
    --@sensitivity = '', -- varchar(12)
    --@file_attachments = N'', -- nvarchar(max)
    @query = N'SELECT name
	FROM sys.databases' , -- nvarchar(max)
    --@execute_query_database = NULL, -- sysname
    --@attach_query_result_as_file = NULL, -- bit
    --@query_attachment_filename = N'', -- nvarchar(260)
    --@query_result_header = NULL, -- bit
    --@query_result_width = 0, -- int
    --@query_result_separator = '', -- char(1)
    --@exclude_query_output = NULL, -- bit
    --@append_query_error = NULL, -- bit
    --@query_no_truncate = NULL, -- bit
    --@query_result_no_padding = NULL, -- bit
    --@mailitem_id = 0, -- int
    --@from_address = '', -- varchar(max)
    @reply_to = 'Levon.Khachatryan@synisys.com' -- varchar(max)


EXEC [msdb].dbo.sp_send_dbmail @profile_name = 'DBA', -- sysname
    @recipients = 'levon.khachatryan@synisys.com', -- varchar(max)
    @subject = N'valod', -- nvarchar(255)
    @body = N'DDXK' , -- nvarchar(max)
    @query = N'SELECT name
	FROM sys.databases' , -- nvarchar(max)
    @reply_to = 'Levon.Khachatryan@synisys.com' -- varchar(max)
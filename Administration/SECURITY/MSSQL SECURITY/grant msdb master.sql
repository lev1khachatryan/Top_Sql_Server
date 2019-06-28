USE master

GO

GRANT EXECUTE ON master.dbo.xp_sqlagent_notify TO [SIS\Team DB]

GO

GRANT EXECUTE ON master.dbo.xp_sqlagent_enum_jobs TO [SIS\Team DB]

GO

GRANT EXECUTE ON master.dbo.xp_sqlagent_is_starting TO [SIS\Team DB]

GO


GRANT EXECUTE ON master.dbo.sp_xp_cmdshell_proxy_account TO  [SIS\Team DB]
GO

GRANT EXECUTE ON master.dbo.xp_cmdshell TO  [SIS\Team DB]
GO



USE msdb

GO

-- Permissions for SQL Agent SP's

GRANT EXECUTE ON msdb.dbo.sp_help_category TO [SIS\Team DB]

GO

GRANT EXECUTE ON msdb.dbo.sp_add_category TO [SIS\Team DB]

GO

GRANT EXECUTE ON msdb.dbo.sp_add_job TO [SIS\Team DB]

GO

GRANT EXECUTE ON msdb.dbo.sp_add_jobserver TO [SIS\Team DB]

GO

GRANT EXECUTE ON msdb.dbo.sp_add_jobstep TO [SIS\Team DB]

GO

GRANT EXECUTE ON msdb.dbo.sp_add_jobschedule TO [SIS\Team DB]

GO

GRANT EXECUTE ON msdb.dbo.sp_help_job TO [SIS\Team DB]

GO

GRANT EXECUTE ON msdb.dbo.sp_delete_job TO [SIS\Team DB]

GO

GRANT EXECUTE ON msdb.dbo.sp_help_jobschedule TO [SIS\Team DB]

GO

GRANT EXECUTE ON msdb.dbo.sp_verify_job_identifiers TO [SIS\Team DB]

GO

GRANT EXECUTE ON msdb.dbo.sp_add_proxy TO [SIS\Team DB]

GO

GRANT EXECUTE ON msdb.dbo.sp_grant_login_to_proxy TO [SIS\Team DB]

GO

GRANT EXECUTE ON msdb.dbo.sp_grant_proxy_to_subsystem TO [SIS\Team DB]

GO

GRANT EXECUTE ON msdb.dbo.sp_attach_schedule TO [SIS\Team DB]

GO
GRANT EXECUTE ON msdb.dbo.sp_update_schedule TO [SIS\Team DB]

GO
------------------------------------------------------------



GRANT EXECUTE ON msdb.dbo.sp_start_job TO [SIS\Team DB]

GO

GRANT EXECUTE ON msdb.dbo.sp_stop_job TO [SIS\Team DB]

GO

GRANT EXECUTE ON msdb.dbo.sp_add_jobschedule  TO [SIS\Team DB]

GO

GRANT EXECUTE ON msdb.dbo.sp_update_job TO [SIS\Team DB]

GO
GRANT EXECUTE ON msdb.dbo.sp_add_jobserver  TO [SIS\Team DB]

GO
GRANT EXECUTE ON msdb.dbo.sp_add_job  TO [SIS\Team DB]

GO
GRANT EXECUTE ON msdb.dbo.sp_add_category  TO [SIS\Team DB]

GO

GRANT EXECUTE ON msdb.dbo.sp_add_jobstep  TO [SIS\Team DB]

GO


GRANT SELECT ON msdb.dbo.sysjobs TO [SIS\Team DB]

GO

GRANT SELECT ON msdb.dbo.syscategories TO [SIS\Team DB]

GO
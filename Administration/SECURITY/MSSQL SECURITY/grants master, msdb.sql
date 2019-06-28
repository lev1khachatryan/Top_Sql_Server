use master;
grant execute on xp_cmdshell to [SIS\Team DB]
grant execute on xp_sqlagent_enum_jobs to [SIS\Team DB]
grant execute on xp_sqlagent_is_starting to [SIS\Team DB]




use [msdb];

grant execute on sp_add_category to [SIS\Team DB]
grant execute on sp_add_job to [SIS\Team DB]



grant execute on sp_add_jobstep to [SIS\Team DB]
grant execute on sp_delete_job to [SIS\Team DB]
grant execute on sp_help_category to [SIS\Team DB]
grant execute on sp_help_job to [SIS\Team DB]
grant execute on sp_help_jobschedule to [SIS\Team DB]
grant execute on sp_verify_job_identifiers to [SIS\Team DB]

grant execute on sp_add_jobserver to [SIS\Team DB]
grant execute on sp_add_jobschedule  to [SIS\Team DB]



GRANT SELECT on msdb.dbo.syscategories to [SIS\Team DB]
GRANT SELECT on msdb.dbo.sysjobs to [SIS\Team DB]

USE dbamonitor
GO

IF OBJECT_ID('DeadlockEvents', 'U') IS NOT NULL
BEGIN
    DROP TABLE DeadlockEvents ;
END ;
GO

CREATE TABLE DeadlockEvents
    (AlertTime DATETIME, DeadlockGraph XML) ;
GO
-- Add a job for the alert to run.

EXEC  msdb.dbo.sp_add_job @job_name=N'Deadlock', 
    @enabled=1, 
    @description=N'Job for responding to DEADLOCK_GRAPH events' ;
GO

-- Add a jobstep that inserts the current time and the deadlock graph into
-- the DeadlockEvents table.

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'deadlock',
    @step_name=N'Insert graph into LogEvents',
    @step_id=1, 
    @on_success_action=1, 
    @on_fail_action=2, 
    @subsystem=N'TSQL', 
    @command= N'INSERT INTO DeadlockEvents
                (AlertTime, DeadlockGraph)
                VALUES (getdate(), N''$(ESCAPE_SQUOTE(WMI(TextData)))'')',
    @database_name=N'dbamonitor' ;
GO

-- Set the job server for the job to the current instance of SQL Server.

EXEC msdb.dbo.sp_add_jobserver @job_name = N'Deadlock' ;
GO

-- Add an alert that responds to all DEADLOCK_GRAPH events for
-- the default instance. To monitor deadlocks for a different instance,
-- change MSSQLSERVER to the name of the instance.

EXEC msdb.dbo.sp_add_alert @name=N'deadlock', 
@wmi_namespace=N'\\.\root\Microsoft\SqlServer\ServerEvents\MSSQLSERVER', 
    @wmi_query=N'SELECT * FROM DEADLOCK_GRAPH', 
    @job_name='deadlock' ;
GO
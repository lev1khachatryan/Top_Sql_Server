USE dbamonitor
GO

IF OBJECT_ID('BlockedEvents', 'U') IS NOT NULL
BEGIN
    DROP TABLE BlockedEvents ;
END ;
GO

CREATE TABLE [dbo].[BlockedEvents](
	[Event_id] [int] IDENTITY(1,1) NOT NULL,
	[AlertTime] [datetime] NULL,
	[BlockedReport] [xml] NULL,
	[SPID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Event_id] ASC
)
)

GO
-- Add a job for the alert to run.

EXEC  msdb.dbo.sp_add_job @job_name=N'lock', 
    @enabled=1, 
    @description=N'LOCK events' ;
GO

-- Add a jobstep that inserts the current time and the deadlock graph into
-- the DeadlockEvents table.

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'lock',
    @step_name=N'Insert ',
    @step_id=1, 
    @on_success_action=1, 
    @on_fail_action=2, 
    @subsystem=N'TSQL', 
    @command= N'SET QUOTED_IDENTIFIER ON
DECLARE @blockingxml XML
SELECT  @blockingxml = N''$(ESCAPE_SQUOTE(WMI(TextData)))''

CREATE TABLE #BlockingDetails
(
Nature				VARCHAR(100),
waittime			VARCHAR(100),
transactionname		VARCHAR(100),
lockMode			VARCHAR(100),
status				VARCHAR(100),
clientapp			VARCHAR(100),
hostname			VARCHAR(100),
loginname			VARCHAR(100),
currentdb			VARCHAR(100),
inputbuf			VARCHAR(1000)
)

--Blocked process details
INSERT INTO #BlockingDetails
SELECT 
Nature			= ''Blocked'',
waittime		= isnull(d.c.value(''@waittime'',''varchar(100)''),''''),
transactionname = isnull(d.c.value(''@transactionname'',''varchar(100)''),''''),
lockMode		= isnull(d.c.value(''@lockMode'',''varchar(100)''),''''),
status			= isnull(d.c.value(''@status'',''varchar(100)''),''''),
clientapp		= isnull(d.c.value(''@clientapp'',''varchar(100)''),''''),
hostname		= isnull(d.c.value(''@hostname'',''varchar(100)''),''''),
loginname		= isnull(d.c.value(''@loginname'',''varchar(100)''),''''),
currentdb		= isnull(db_name(d.c.value(''@currentdb'',''varchar(100)'')),''''),
inputbuf		= isnull(d.c.value(''inputbuf[1]'',''varchar(1000)''),'''')
FROM @blockingxml.nodes(''TextData/blocked-process-report/blocked-process/process'') d(c)

--Blocking process details
INSERT INTO #BlockingDetails
SELECT 
Nature			= ''BlockedBy'',
waittime		= '''',
transactionname = '''',
lockMode		= '''',
status			= isnull(d.c.value(''@status'',''varchar(100)''),''''),
clientapp		= isnull(d.c.value(''@clientapp'',''varchar(100)''),''''),
hostname		= isnull(d.c.value(''@hostname'',''varchar(100)''),''''),
loginname		= isnull(d.c.value(''@loginname'',''varchar(100)''),''''),
currentdb		= isnull(db_name(d.c.value(''@currentdb'',''varchar(100)'')),''''),
inputbuf		= isnull(d.c.value(''inputbuf[1]'',''varchar(1000)''),'''')
FROM @blockingxml.nodes(''TextData/blocked-process-report/blocking-process/process'') d(c)

DECLARE @body VARCHAR(max)
SELECT @body =
(
	SELECT td = 
	currentdb + ''</td><td>''  +  Nature + ''</td><td>'' + waittime + ''</td><td>'' + transactionname + ''</td><td>'' + 
	lockMode + ''</td><td>'' + status + ''</td><td>'' + clientapp +  ''</td><td>'' + 
	hostname + ''</td><td>'' + loginname + ''</td><td>'' +  inputbuf
	FROM #BlockingDetails
	FOR XML PATH( ''tr'' )     
)  

SELECT @body = ''<table cellpadding="2" cellspacing="2" border="1">''    
              + ''<tr><th>currentdb</th><th>Nature</th><th>waittime</th><th>transactionname</th></th></th><th>lockMode</th></th>
              </th><th>status</th></th></th><th>clientapp</th></th></th><th>hostname</th></th>
              </th><th>loginname</th><th>inputbuf</th></tr>''    
              + replace( replace( @body, ''&lt;'', ''<'' ), ''&gt;'', ''>'' )     
              + ''</table>''  +  ''<table cellpadding="2" cellspacing="2" border="1"><tr><th>XMLData</th></tr><tr><td>'' + replace( replace( convert(varchar(max),@blockingxml),  ''<'',''&lt;'' ),  ''>'',''&gt;'' )  
              + ''</td></tr></table>''

DROP TABLE #BlockingDetails




--Inserting into a table for further reference
INSERT INTO DBAMonitor.dbo.BlockedEvents
                (AlertTime, BlockedReport)
                VALUES (getdate(), N''$(ESCAPE_SQUOTE(WMI(TextData)))'')

--Updating the SPID column
UPDATE B
	SET B.SPID = B.BlockedReport.value(''(/TextData/blocked-process-report/blocking-process/process/@spid)[1]'',''int'')
	FROM DBAMonitor.dbo.BlockedEvents B 
	where  B.Event_id = SCOPE_IDENTITY()',
    @database_name=N'dbamonitor' ;
GO

-- Set the job server for the job to the current instance of SQL Server.

EXEC msdb.dbo.sp_add_jobserver @job_name = N'lock' ;
GO

-- Add an alert that responds to all DEADLOCK_GRAPH events for
-- the default instance. To monitor deadlocks for a different instance,
-- change MSSQLSERVER to the name of the instance.

EXEC msdb.dbo.sp_add_alert @name=N'lock', 
@wmi_namespace=N'\\.\root\Microsoft\SqlServer\ServerEvents\MSSQLSERVER', 
    @wmi_query=N'SELECT * FROM BLOCKED_PROCESS_REPORT', 
    @job_name='lock' ;
GO
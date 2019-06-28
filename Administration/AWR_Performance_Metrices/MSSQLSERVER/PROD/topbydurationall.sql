USE [DBAMonitor]
GO
/****** Object:  StoredProcedure [dbo].[topquerybydurationalldb]    Script Date: 03/13/2014 08:16:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[topquerybydurationalldb]
	AS
BEGIN
	SET NOCOUNT ON;

     select row_rank, DB_Name(B.dbid) database_name, execution_count, --
--substring (convert(char(23),DATEADD(ms,total_elapsed_time/1000,0),121),12,23) total_elapsed_time_ms,
cast(total_elapsed_time as decimal(18,0))/1000000, 
--substring(convert(char(23),DATEADD(ms,
(cast(total_elapsed_time as decimal))/1000000/execution_count
--total_elapsed_time/execution_count/1000,0),121),12,23)
average_elapsed_time_ms, 
last_execution_time, TSQL from (select
row_rank, total_elapsed_time, last_execution_time,
execution_count, sql_handle, substring(text, case when
statement_start_offset = 0 or statement_start_offset is NULL then 1 else
statement_start_offset/2 + 1 end, case when statement_end_offset =
0 or statement_end_offset = -1 or statement_end_offset is NULL then len(text) else
statement_end_offset/2 end - case when statement_start_offset = 0
or statement_start_offset is NULL then 1 else statement_start_offset/2 end + 1)
TSQL, plan_handle from (select *, row_number() over(order by substring
(convert(char(23),DATEADD(ms,
(total_elapsed_time/execution_count)/1000,0),121),12,23) desc,
last_execution_time desc) as row_rank from sys.dm_exec_query_stats where
max_elapsed_time > 0) rt cross apply sys.dm_exec_sql_text(rt.sql_handle)) A join
(select plan_handle, cast(value as int) dbid FROM sys.dm_exec_cached_plans
cp OUTER APPLY sys.dm_exec_plan_attributes(cp.plan_handle) WHERE
Attribute = 'dbid') B on A.plan_handle = B.plan_handle 
AND db_name(B.dbid)  not in ('master','model', 'msdb', 'tempdb', 'DBAMonitor', 'resource')
END

INSERT INTO [DBAMonitor].[dbo].[TOP_QUERY_BY_TIME]
           ([row_rank]
           ,[DBname]
           ,[exec_count]
           ,[total_elapsed_time]
           ,[avg_elapsed_time]
           ,[last_exec_time]
           ,[TSQL])
   EXECUTE [DBAMonitor].[dbo].[topquerybydurationalldb] 
   
GO

INSERT INTO [DBAMonitor].[dbo].[TOP_QUERY_BY_CPU]
           ([DBNAME]
           ,[TSQL]
           ,[objtype]
           ,[Schema_name]
           ,[Object_name]
           ,[execution_count]
           ,[total_cpu_time_ms]
           ,[avg_cpu_time_ms]
           ,[last_execution_time])
     EXECUTE  [DBAMonitor].[dbo].[topquerybycpualldb] 

GO

INSERT INTO [DBAMonitor].[dbo].[TOP_QUERY_BY_IO]
           ([DBNAME]
           ,[TSQL]
           ,[objtype]
           ,[Schema_name]
           ,[Object_name]
           ,[execution_count]
           ,[total_IOs]
           ,[avg_Ios]
           ,[total_logical_reads]
           ,[avg_logical_reads]
           ,[total_logical_writes]
           ,[avg_logical_writes]
           ,[total_physical_reads]
           ,[avg_physical_reads]
           ,[last_execution_time])
    EXECUTE [DBAMonitor].[dbo].[topquerybyioalldb] 
   GO

INSERT INTO [DBAmonitor].[dbo].[SPstatistics]
           ([DBName]
           ,[Schema_Name]
           ,[object_Name]
           ,[cache_time]
           ,[last_execution_time]
           ,[execution_count]
           ,[avg_cpu]
           ,[avg_elapsed]
           ,[avg_logical_reads]
           ,[avg_logical_writes]
           ,[avg_physical_writes])
     EXECUTE  [DBAmonitor].[dbo].[sp_statistics_alldb] 
GO




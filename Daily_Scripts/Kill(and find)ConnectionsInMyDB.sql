USE [master];

DECLARE @kill varchar(8000) = '';  
SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), session_id) + ';'  
FROM sys.dm_exec_sessions
WHERE database_id  = db_id('DEV-ONEWASH_MIS-DATA')

EXEC(@kill);

SELECT DB_NAME(dbid) AS DBName,
COUNT(dbid) AS NumberOfConnections,
loginame
FROM    sys.sysprocesses
WHERE DB_NAME(dbid) = 'DEV-ONEWASH_MIS-DATA'
GROUP BY dbid, loginame
ORDER BY DB_NAME(dbid)

--ALTER DATABASE [RWA_IECMS-story_RWAIECMS-ModificationInReplication-DATA_1]
--SET MULTI_USER

-- sa kill e anum system user nerin

DECLARE @spid AS NVARCHAR(100);
SET @spid = (
select  convert (smallint, req_spid) As spid -- , d.name 
      from master.dbo.syslockinfo l, 
           master.dbo.spt_values v,
           master.dbo.spt_values x, 
           master.dbo.spt_values u, 
           master.dbo.sysdatabases d
      where   l.rsc_type = v.number 
      and v.type = 'LR' 
      and l.req_status = x.number 
      and x.type = 'LS' 
      and l.req_mode + 1 = u.number
      and u.type = 'L' 
      and l.rsc_dbid = d.dbid 
      and rsc_dbid = (select top 1 dbid from 
                      master..sysdatabases 
                      where name like 'DEV-ONEWASH_MIS-DATA')
					  )

DECLARE @kill_process AS NVARCHAR(MAX) = N'';
SET @kill_process =  'KILL ' + @spid      
            EXEC master.dbo.sp_executesql @kill_process
                   PRINT 'killed spid : '+ @spid


--ALTER DATABASE [DEV-RWA_IECMS-DATA_Bilingualization]
--SET MULTI_USER 

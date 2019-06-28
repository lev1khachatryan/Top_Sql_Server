
-- This comment was added fօr merge
--DECLARE A CURSOR FOR
DECLARE @sql NVARCHAR(MAX) = ''
SELECT --TOP 2--name,
--'git checkout '+SUBSTRING(name, 11, LEN(name)),
@sql = @sql+
 'USE ARTASH
EXEC dbo.BackupAndRestoreDatabase @SourceDatabaseName = N''' + name + ''', @backupDirectory = N''\\sis2s013\MRT SIGIP\Backup\BeforeMergedDBdrop''; 
EXEC dbo.BackupAndRestoreDatabase @SourceDatabaseName = N''' + SUBSTRING(name, 1, LEN(name) - 4) + 'KB' + ''', @backupDirectory = N''\\sis2s013\MRT SIGIP\Backup\BeforeMergedDBdrop'';' +
CASE WHEN  name LIKE 'RWA_IECMS%DATA' THEN 'EXEC dbo.BackupAndRestoreDatabase @SourceDatabaseName = N''' + SUBSTRING(name, 1, LEN(name) - 4) + 'DE' + ''', @backupDirectory = N''\\sis2s013\MRT SIGIP\Backup\BeforeMergedDBdrop'';' 
ELSE '' END +
' ALTER DATABASE '+ QUOTENAME(name) + ' SET  SINGLE_USER WITH ROLLBACK IMMEDIATE ; 
ALTER DATABASE ' + QUOTENAME(SUBSTRING(name, 1, LEN(name) - 4) + 'KB')+' SET  SINGLE_USER WITH ROLLBACK IMMEDIATE ;'+
CASE WHEN name LIKE 'RWA_IECMS%DATA' THEN 'ALTER DATABASE ' + QUOTENAME(SUBSTRING(name, 1, LEN(name) - 4) + 'DE')+' SET  SINGLE_USER WITH ROLLBACK IMMEDIATE ;' 
ELSE '' END +
'drop database '+ QUOTENAME(name) + '; '+
'DROP database ' + QUOTENAME(SUBSTRING(name, 1, LEN(name) - 4) + 'KB')+'; '+
CASE WHEN name LIKE 'RWA_IECMS%DATA' THEN 'drop database ' + QUOTENAME(SUBSTRING(name, 1, LEN(name) - 4) + 'DE')+'; '
ELSE '' END + 
''
FROM sys.databases
WHERE (name LIKE 'MRT_SIGIP%DATA' OR name LIKE 'RWA_IECMS%DATA' ) AND CREATE_date <= '2016-11-16'


set @sql = substring(@sql, 1, len(@sql) - 6)
print @sql





exec (@sql)

GO

CREATE PROCEDURE PPP (@db_name varchar(50))
AS
BEGIN
DECLARE @sql NVARCHAR(MAX) = N''
SET @sql += 
'USE @db_name 
select top 1
    creation_time,
    last_execution_time
FROM sys.dm_exec_query_stats  qs
ORDER BY qs.last_execution_time , qs.creation_time '
PRINT @sql
--EXEC (@sql)
END

EXEC PPP @db_name = 'TSQL2012'

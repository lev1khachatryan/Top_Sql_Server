SET NOCOUNT ON 
set ansi_warnings off


DECLARE @sql1 VARCHAR(8000)
DECLARE @sql2 VARCHAR(256)
SET @sql2 = 'C:\useddatabases.csv'
DECLARE @team VARCHAR(256)
DECLARE @db VARCHAR(256)


CREATE TABLE #useddb
    (
      [Database] VARCHAR(256) ,
      [Team] VARCHAR(256) ,
    ) 

SET @sql1 = '    
BULK INSERT #useddb
FROM ' + '''' + @sql2 + '''' + CHAR(13) + CHAR(10) + 'WITH 
(
 FIELDTERMINATOR = '','',
 ROWTERMINATOR = ''\n'',
 FIRSTROW = 2
)' 
PRINT @sql1 
EXEC(@sql1)

If (select count(*) from #useddb)>1

Begin

CREATE TABLE #unuseddatabase
    (
       [unuseddb] VARCHAR(256) 
    ) 
INSERT INTO #unuseddatabase 

 select name from sys.databases 
 WHERE name NOT IN ('master','model','msdb','tempdb')  -- exclude these databases
 except 
 select [Database] as name from #useddb  
 

 --insert log  deleted database

/*
USE [DBAmonitor]
GO
CREATE TABLE [dbo].[LOGDBDELETED]
(	[TIME] [datetime] NULL,
	[DBname] [nvarchar](50) NULL  ) 
*/

INSERT INTO [DBAmonitor].[dbo].[LOGDBDELETED] 
([TIME],[DBname])
select GETDATE(), unuseddb  from #unuseddatabase

DECLARE @sql3 VARCHAR(1000);
DECLARE @unuseddbname VARCHAR(50) -- database name  
DECLARE @path VARCHAR(256) -- path for backup files  
DECLARE @fileName VARCHAR(256) -- filename for backup  
DECLARE @fileDate VARCHAR(20) -- used for file name

 
-- specify database backup directory

SET @path = 'C:\Backupunused\'  


DECLARE backupanddrop CURSOR FOR  
SELECT unuseddb
FROM  #unuseddatabase


 
OPEN backupanddrop   
FETCH NEXT FROM backupanddrop INTO @unuseddbname   

 
WHILE @@FETCH_STATUS = 0   
BEGIN   
       SET @fileName = @path + '[' + @unuseddbname + ']' + '_db_' + '.BAK'  
       BACKUP DATABASE @unuseddbname TO DISK = @fileName  

	   SET @sql3 = 'DROP DATABASE ' + '[' + @unuseddbname + ']' +';'
	 
       PRINT (@sql3)
       EXEC (@sql3)
 
       FETCH NEXT FROM backupanddrop INTO @unuseddbname   
END   

 
CLOSE backupanddrop   
DEALLOCATE backupanddrop


DROP TABLE #unuseddatabase;

DROP TABLE #useddb

END
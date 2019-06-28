SET NOCOUNT ON 
set ansi_warnings off


DECLARE @sql1 VARCHAR(8000)
DECLARE @sql2 VARCHAR(256)
SET @sql2 = 'C:\useddatabases.csv'

CREATE TABLE #useddb
    (
      [Database] VARCHAR(256) 
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


/*
USE [DBAmonitor]
GO
CREATE TABLE [dbo].[LOGDBDELETED]
(	[TIME] [datetime] NULL,
	[DBname] [nvarchar](50) NULL  ) 
*/

INSERT INTO [DBAmonitor].[dbo].[LOGDBDELETED] 
([TIME],[DBname])
select GETDATE(), [Database]  from #useddb

DECLARE @sql3 VARCHAR(1000);
DECLARE @useddbname VARCHAR(50) -- database name  
DECLARE @path VARCHAR(256) -- path for backup files  
DECLARE @fileName VARCHAR(256) -- filename for backup  
DECLARE @fileDate VARCHAR(20) -- used for file name

-- specify database backup directory

SET @path = 'C:\Backupunused\'  


DECLARE backupanddrop CURSOR FOR  
SELECT [Database]
FROM  #useddb

OPEN backupanddrop   
FETCH NEXT FROM backupanddrop INTO @useddbname   
 
WHILE @@FETCH_STATUS = 0   
BEGIN   
       SET @fileName = @path + '[' + @useddbname + ']' + '_db_' + '.BAK'  
       BACKUP DATABASE @useddbname TO DISK = @fileName  

	   SET @sql3 = 'DROP DATABASE ' + '[' + @useddbname + ']' +';'
	 
       PRINT (@sql3)
       EXEC (@sql3)
 
       FETCH NEXT FROM backupanddrop INTO @useddbname   
END   


CLOSE backupanddrop   
DEALLOCATE backupanddrop


DROP TABLE #useddb

END
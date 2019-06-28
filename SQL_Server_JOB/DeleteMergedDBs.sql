--CREATE TABLE #DBs ( DBName NVARCHAR(500) );
--DECLARE @sql AS NVARCHAR(MAX) = N'';
--SELECT  @sql += '
--SELECT TABLE_CATALOG AS DBName
--FROM [' + name + '].INFORMATION_SCHEMA.COLUMNS
--WHERE TABLE_NAME = ''_DE_BuildNumber''
--AND COLUMN_NAME = ''IsMerged'' UNION
--'
--FROM    sys.databases
--WHERE name LIKE 'USA%' OR name LIKE 'RWA%' OR name LIKE 'MRT%'
--IF ( LEN(@sql) > 7 )
--    BEGIN
--        SET @sql += SUBSTRING(@sql, 1, LEN(@sql) - 7);
--    END;
--INSERT  INTO #DBs
--        ( DBName )
--        EXEC ( @sql
--            );
--------------------------------------
--CREATE TABLE #DeletedDBs ( DBName NVARCHAR(500) );
--DECLARE @ddxk AS NVARCHAR(MAX) = N'';
--SELECT  @ddxk += '
--SELECT ''' + DBName + '''
--FROM [' + DBName
--        + '].dbo._DE_BuildNumber
--WHERE   IsMerged = 1
--        AND DATEDIFF(DAY, DateCreated, GETDATE()) > 1
--		AND (SELECT  
--(SELECT MAX(T) AS last_access FROM (SELECT MAX(last_user_lookup) AS T UNION ALL SELECT MAX(last_user_seek) UNION ALL SELECT MAX(last_user_scan) UNION ALL SELECT MAX(last_user_update)) d) last_access
--FROM sys.databases db 
--LEFT JOIN sys.dm_db_index_usage_stats iu ON db.database_id = iu.database_id
--WHERE db.database_id = DB_ID(''' + DBName + ''') ) <=  ( GETDATE() )
--		UNION
--'
--FROM    #DBs;
--IF ( LEN(@ddxk) > 7 )
--    BEGIN
--        SET @ddxk += SUBSTRING(@ddxk, 1, LEN(@ddxk) - 7);
--    END;
--INSERT  INTO #DeletedDBs
--        ( DBName )
--        EXEC ( @ddxk
--            );
--;
--WITH    CTE
--          AS ( ( SELECT REPLACE(DBName, 'DATA', 'KB') AS name
--                 FROM   #DeletedDBs
--                 WHERE  EXISTS ( SELECT 1
--                                 FROM   sys.databases
--                                 WHERE  REPLACE(DBName, 'DATA', 'KB') = name )
--                 UNION
--                 SELECT REPLACE(DBName, 'DATA', 'DE')
--                 FROM   #DeletedDBs
--                 WHERE  EXISTS ( SELECT 1
--                                 FROM   sys.databases
--                                 WHERE  REPLACE(DBName, 'DATA', 'DE') = name )
--               )
--               EXCEPT
--               ( SELECT DBName
--                 FROM   #DeletedDBs
--               )
--             )
--    INSERT  INTO #DeletedDBs
--            ( DBName )
--            SELECT  CTE.name
--            FROM    CTE;
----------------------------------------------------------
--DECLARE @name NVARCHAR(500);
--DECLARE @path NVARCHAR(500); 
--DECLARE @fileName NVARCHAR(500);
--DECLARE @fileDate NVARCHAR(500);
--set @Path = '\\sis2s082\BACKUP_E\DeletedMergedDBs\' + CONVERT(VARCHAR(20), GETDATE(), 112) + '\'
--EXEC master.dbo.xp_create_subdir @Path
--SELECT  @fileDate = CONVERT(VARCHAR(20), GETDATE(), 112); 
--DECLARE db_cursor CURSOR
--FOR
--    SELECT  DBName
--    FROM    #DeletedDBs;
--OPEN db_cursor;
--FETCH NEXT FROM db_cursor INTO @name;   
--WHILE @@FETCH_STATUS = 0
--    BEGIN  
--        DECLARE @kill NVARCHAR(MAX) = N'';  
--        SELECT  @kill = @kill + 'kill ' + CONVERT(VARCHAR(5), session_id)
--                + ';'
--        FROM    sys.dm_exec_sessions
--        WHERE   database_id = DB_ID(@name);
--        EXEC(@kill);
--        SET @fileName = @path + @name + '_' + @fileDate + '.BAK';  
--        BACKUP DATABASE @name TO DISK = @fileName;
--        EXEC ('DROP DATABASE [' + @name + ']');
--        FETCH NEXT FROM db_cursor INTO @name;
--    END;   
--CLOSE db_cursor;   
--DEALLOCATE db_cursor;

--DROP TABLE #DBs;
--DROP TABLE #DeletedDBs;
--GO


---------------
---------------
---------------

--BEGIN TRAN
--BEGIN TRY

--SELECT REPLACE(CONVERT(VARCHAR(20), GETDATE(), 14) , ':' , '')

CREATE TABLE #DBs ( DBName NVARCHAR(500) );
DECLARE @sql AS NVARCHAR(MAX) = N'';
SELECT  @sql += '
SELECT TABLE_CATALOG AS DBName
FROM [' + name + '].INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = ''_DE_BuildNumber''
AND COLUMN_NAME = ''IsMerged'' UNION
'
FROM    sys.databases
WHERE (name LIKE 'USA%' OR name LIKE 'RWA%' OR name LIKE 'MRT%') AND
	(is_published = 0 AND is_subscribed = 0 AND
  is_merge_published = 0 AND is_distributor = 0 )
IF ( LEN(@sql) > 7 )
    BEGIN
        SET @sql += SUBSTRING(@sql, 1, LEN(@sql) - 7);
    END;
INSERT  INTO #DBs
        ( DBName )
        EXEC ( @sql
            );
------------------------------------
CREATE TABLE #DeletedDBs ( DBName NVARCHAR(500) );
DECLARE @ddxk AS NVARCHAR(MAX) = N'';
SELECT  @ddxk += '
SELECT ''' + DBName + '''
FROM [' + DBName + '].dbo._DE_BuildNumber
WHERE   IsMerged = 1
        AND DATEDIFF(DAY, DateCreated, GETDATE()) >= 1
		AND (SELECT
(SELECT MAX(T) AS last_access FROM (SELECT MAX(last_user_lookup) AS T UNION ALL SELECT MAX(last_user_seek) UNION ALL SELECT MAX(last_user_scan) UNION ALL SELECT MAX(last_user_update)) d) last_access
FROM sys.databases db 
LEFT JOIN sys.dm_db_index_usage_stats iu ON db.database_id = iu.database_id
WHERE db.database_id = DB_ID(''' + DBName + ''') ) <=  ( GETDATE() )
		AND (SELECT MAX(modify_date) as last_modification
	         FROM [' + DBName + '].sys.objects) <=  ( GETDATE() )
		UNION
'
FROM    #DBs;
IF ( LEN(@ddxk) > 7 )
    BEGIN
        SET @ddxk += SUBSTRING(@ddxk, 1, LEN(@ddxk) - 7);
    END;
INSERT  INTO #DeletedDBs
        ( DBName )
        EXEC ( @ddxk
            );

WITH    CTE
          AS ( ( SELECT REPLACE(DBName, 'DATA', 'KB') AS name
                 FROM   #DeletedDBs
                 WHERE  EXISTS ( SELECT 1
                                 FROM   sys.databases
                                 WHERE  REPLACE(DBName, 'DATA', 'KB') = name )
                 UNION
                 SELECT REPLACE(DBName, 'DATA', 'DE')
                 FROM   #DeletedDBs
                 WHERE  EXISTS ( SELECT 1
                                 FROM   sys.databases
                                 WHERE  REPLACE(DBName, 'DATA', 'DE') = name )
               )
               EXCEPT
               ( SELECT DBName
                 FROM   #DeletedDBs
               )
             )
    INSERT  INTO #DeletedDBs
            ( DBName )
            SELECT  CTE.name
            FROM    CTE;
--------------------------------------------------------
DECLARE @name NVARCHAR(500);
DECLARE @path NVARCHAR(500); 
DECLARE @fileName NVARCHAR(500);
DECLARE @fileDate NVARCHAR(500);
set @Path = '\\sis2s082\BACKUP_E\DeletedMergedDBs\' + CONVERT(VARCHAR(20), GETDATE(), 112) + '\'
EXEC master.dbo.xp_create_subdir @Path
--SELECT  @fileDate = REPLACE(CONVERT(VARCHAR(20), GETDATE(), 14) , ':' , ''); 
DECLARE db_cursor CURSOR
FOR
    SELECT  DBName
    FROM    #DeletedDBs;
OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @name;   
WHILE @@FETCH_STATUS = 0
    BEGIN  
		SELECT  @fileDate = REPLACE(CONVERT(VARCHAR(20), GETDATE(), 14) , ':' , ''); 
        DECLARE @kill NVARCHAR(MAX) = N'';  
        SELECT  @kill = @kill + 'kill ' + CONVERT(VARCHAR(5), session_id)
                + ';'
        FROM    sys.dm_exec_sessions
        WHERE   database_id = DB_ID(@name);
        EXEC(@kill);
        SET @fileName = @path + @name + '_' + @fileDate + '.BAK';  
        BACKUP DATABASE @name TO DISK = @fileName;
        EXEC ('DROP DATABASE [' + @name + ']');
        FETCH NEXT FROM db_cursor INTO @name;
    END;
CLOSE db_cursor;   
DEALLOCATE db_cursor;


DROP TABLE #DBs;
DROP TABLE #DeletedDBs;

--COMMIT
--END TRY
--BEGIN CATCH

--	SELECT ERROR_MESSAGE()
--	ROLLBACK
--END CATCH

CREATE TABLE #DBs ( DBName NVARCHAR(500) );
DECLARE @sql AS NVARCHAR(MAX) = N'';
SELECT  @sql += '
SELECT TABLE_CATALOG AS DBName
FROM [' + name + '].INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = ''_DE_BuildNumber''
AND COLUMN_NAME = ''IsMerged'' UNION
'
FROM    sys.databases
WHERE name LIKE 'USA%' OR name LIKE 'RWA%' OR name LIKE 'MRT%'
IF ( LEN(@sql) > 7 )
    BEGIN
        SET @sql += SUBSTRING(@sql, 1, LEN(@sql) - 7);
    END;
INSERT  INTO #DBs
        ( DBName )
        EXEC ( @sql
            );

SELECT *
FROM #DBs



------------------------------------
CREATE TABLE #DeletedDBs ( DBName NVARCHAR(500) );
DECLARE @ddxk AS NVARCHAR(MAX) = N'';
SELECT  @ddxk += '
SELECT ''' + DBName + '''
FROM [' + DBName + '].dbo._DE_BuildNumber
WHERE   IsMerged = 1
        AND DATEDIFF(DAY, DateCreated, GETDATE()) > 1
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
;
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

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


--------------------
--------------------
--------------------

--DECLARE @DBName AS NVARCHAR(300) = N'';
--DECLARE DBName CURSOR READ_ONLY FOR


DECLARE @sql AS NVARCHAR(MAX) = N'';
SELECT  @sql += 'SELECT ''' + name + '''
FROM [' + name + '].sys.objects
HAVING MAX(modify_date) <= (GETDATE() - 5)
AND (SELECT  
(SELECT MAX(T) AS last_access FROM (SELECT MAX(last_user_lookup) AS T UNION ALL SELECT MAX(last_user_seek) UNION ALL SELECT MAX(last_user_scan) UNION ALL SELECT MAX(last_user_update)) d) last_access
FROM sys.databases db 
LEFT JOIN sys.dm_db_index_usage_stats iu ON db.database_id = iu.database_id
WHERE db.database_id = DB_ID(''' + name + ''') ) <=  ( GETDATE() ) UNION
'
FROM    sys.databases
WHERE   name NOT IN ( 'master', 'tempdb', 'model', 'msdb', 'ARTASH', 'HAYK',
                      'distribution', 'IDM-Util-Dev', 'DBAMonitor',
                      '_EncryptionTest' )
        AND name NOT LIKE 'DEV%'
        AND create_date <= ( GETDATE() - 5 );
IF ( LEN(@sql) > 7 )
    BEGIN
        SET @sql += SUBSTRING(@sql, 1, LEN(@sql) - 7);
        PRINT (@sql);
    END;

--OPEN DBName
--FETCH NEXT FROM DBName INTO @DBName

--WHILE @@FETCH_STATUS = 0
--BEGIN
	
--	FETCH NEXT FROM DBName INTO @DBName
--END


---------------------
---------------------
---------------------
;WITH    CTE
          AS ( ( SELECT REPLACE(DBName, 'DATA', 'KB') AS name
                 FROM   #DBs
                 WHERE  EXISTS ( SELECT 1
                                 FROM   sys.databases
                                 WHERE  REPLACE(DBName, 'DATA', 'KB') = name )
                 UNION
                 SELECT REPLACE(DBName, 'DATA', 'DE')
                 FROM   #DBs
                 WHERE  EXISTS ( SELECT 1
                                 FROM   sys.databases
                                 WHERE  REPLACE(DBName, 'DATA', 'DE') = name )
               )
               EXCEPT
               ( SELECT DBName
                 FROM   #DBs
               )
             )
    INSERT  INTO #DBs
            ( DBName )
            SELECT  CTE.name
            FROM    CTE;
----------------------------
CREATE TABLE #UnusedDBs ( DBName NVARCHAR(500) );
DECLARE @ddxk AS NVARCHAR(MAX) = N'';
SELECT  @ddxk += '
IF 
SELECT ''' + DBName + '''
FROM #DBs
WHERE (SELECT  
(SELECT MAX(T) AS last_access FROM (SELECT MAX(last_user_lookup) AS T UNION ALL SELECT MAX(last_user_seek) UNION ALL SELECT MAX(last_user_scan) UNION ALL SELECT MAX(last_user_update)) d) last_access
FROM sys.databases db 
LEFT JOIN sys.dm_db_index_usage_stats iu ON db.database_id = iu.database_id
WHERE db.database_id = DB_ID(''' + DBName + ''') ) <=  ( GETDATE() - 5 )
		AND
			((SELECT MAX(modify_date) AS max_modified_date
			FROM [' + DBName + '].sys.objects
			) <= (GETDATE() - 5))
		UNION
'
FROM    #DBs;
IF ( LEN(@ddxk) > 7 )
    BEGIN
        SET @ddxk += SUBSTRING(@ddxk, 1, LEN(@ddxk) - 7);
    END;

INSERT  INTO #UnusedDBs
        ( DBName )
        EXEC ( @ddxk
            );
GO

IF
(
(SELECT MAX(sub.last_access) AS last_access
FROM 
(
SELECT  ( SELECT    MAX(T) AS last_access
          FROM      ( SELECT    MAX(last_user_lookup) AS T
                      UNION ALL
                      SELECT    MAX(last_user_seek)
                      UNION ALL
                      SELECT    MAX(last_user_scan)
                      UNION ALL
                      SELECT    MAX(last_user_update)
                    ) d
        ) last_access
FROM    sys.databases db
        LEFT JOIN sys.dm_db_index_usage_stats iu ON db.database_id = iu.database_id
WHERE   db.database_id = DB_ID('DEV-USA_COHR-DATA_Staging_20170707')
UNION
( SELECT    MAX(modify_date) AS max_modified_date
  FROM      sys.objects
)
) AS sub
) <= (GETDATE() - 5)
)





DROP TABLE #UnusedDBs

DROP TABLE #DBs



SET NOCOUNT ON 


--Load data from file
DECLARE @sql1 VARCHAR(8000)
DECLARE @sql2 VARCHAR(256)
SET @sql2 = 'C:\SECURITYEXCEL\SIS2S016_Permissions_Mapping.csv'
DECLARE @team VARCHAR(256)
SET @team = NULL
DECLARE @db VARCHAR(256)
SET @db = NULL




CREATE TABLE #Mappings33
    (
      [Server] VARCHAR(256) ,
      [Database] VARCHAR(256) ,
      [Login] VARCHAR(256) ,
      [ServPermList] VARCHAR(256) ,
      [FromWinGroup] BIT ,
      [User] VARCHAR(256) ,
      [Role] VARCHAR(256) ,
      [Team] VARCHAR(256) ,
      [IsActive] BIT
    ) 
SET @sql1 = '    
BULK INSERT #Mappings33 
FROM ' + '''' + @sql2 + '''' + CHAR(13) + CHAR(10) + 'WITH 
(
 FIELDTERMINATOR = '','',
 ROWTERMINATOR = ''\n'',
 FIRSTROW = 2
)' 
PRINT ( @sql1 ) 
EXEC(@sql1)


 CREATE TABLE #Mappings100
    (
      [Server] VARCHAR(256) ,
      [Preface] VARCHAR(256) ,	 
      [Login] VARCHAR(256) ,
      [ServPermList] VARCHAR(256) ,
      [FromWinGroup] BIT ,
      [User] VARCHAR(256) ,
      [Role] VARCHAR(256) ,
      [Team] VARCHAR(256) ,
      [IsActive] BIT
    ) 
	INSERT INTO #Mappings100
    ( [Server],
      [Preface],
	  [Login],
      [ServPermList],
      [FromWinGroup],
      [User],
      [Role],
      [Team],
      [IsActive])
	  select   [Server] ,
      [Database] ,
      [Login] ,
      [ServPermList] ,
      [FromWinGroup] ,
      [User] ,
      [Role] ,
      [Team] ,
      [IsActive] 
	 from #Mappings33 where  [login]= 'idmdaduser' and [Server] = @@SERVERNAME 


DECLARE @sqlDB VARCHAR(256)  
DECLARE @sql VARCHAR(8000) 
DECLARE @User VARCHAR(256) ;
DECLARE @Login VARCHAR(256)
SET @Login = 'idmdaduser'
SET @User = 'idmdaduser'
DECLARE @Role VARCHAR(256)
SET @Role = (select [Role] from #Mappings100  where  [login]= 'idmdaduser' )
SET @DB = NULL
DECLARE users_cursor  CURSOR SCROLL FOR 
SELECT QUOTENAME(name) FROM sys.databases 
WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb') AND  ISNULL (@DB,name) = name 



OPEN  users_cursor 
FETCH NEXT FROM users_cursor INTO  @sql

WHILE @@FETCH_STATUS = 0 
    BEGIN
        SET @sqlDB = 'USE ' + @sql + ' ' + CHAR(13)
        SET @sql = @sqlDB
            + 'IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = '
                    + '''' + @Role + '''' + ' AND type = ''R'')' + CHAR(13)
                    + 'CREATE ROLE ' + @Role + ' AUTHORIZATION [dbo]'
                    + CHAR(13) + CHAR(10) + 'IF ' + '''' + @Role + ''''
                    + ' = ''sis_public'' ' + CHAR(13) + CHAR(10) + 'BEGIN'
                    + CHAR(13) + CHAR(10) + 'GRANT DELETE TO ' + @Role
                    + CHAR(13) + CHAR(10) + 'GRANT EXECUTE TO ' + @Role
                    + CHAR(13) + CHAR(10) + 'GRANT INSERT TO ' + @Role
                    + CHAR(13) + CHAR(10) + 'GRANT SELECT TO ' + @Role
                    + CHAR(13) + CHAR(10) + 'GRANT UPDATE TO ' + @Role
                    + CHAR(13) + CHAR(10) + 'END' + CHAR(13) + CHAR(10)
                    + 'ELSE IF ' + '''' + @Role + '''' + ' = ''sis_dmladmin'''
                    + CHAR(13) + CHAR(10) + 'BEGIN' + CHAR(13) + CHAR(10)
                    + 'GRANT EXECUTE TO ' + @Role + CHAR(13) + CHAR(10)
					+ 'GRANT DELETE TO ' + @Role + CHAR(13) + CHAR(10)
                    + 'GRANT INSERT TO ' + @Role + CHAR(13) + CHAR(10)
                    + 'GRANT SELECT TO ' + @Role + CHAR(13) + CHAR(10)
                    + 'GRANT UPDATE TO ' + @Role + CHAR(13) + CHAR(10)
                    + 'GRANT VIEW DEFINITION TO ' + @Role + CHAR(13)
                    + CHAR(10) + 'END' + CHAR(13) + CHAR(10) + 'ELSE IF '
                    + '''' + @Role + '''' + ' = ''sis_ddladmin''' + ' OR '
                    + '''' + @Role + '''' + ' = ''sis_admin''' + CHAR(13)
                    + CHAR(10) + 'BEGIN' + CHAR(13) + CHAR(10)
                    + 'EXEC sp_addrolemember N''db_owner'', ' + 'N' + ''''
                    + @Role + '''' + CHAR(13) + CHAR(10)
                    + 'EXEC sp_addrolemember N''db_backupoperator'', ' + 'N'
                    + '''' + @Role + '''' + CHAR(13) + CHAR(10) +'END'
            + CHAR(13) + 'ALTER AUTHORIZATION ON DATABASE::' + @sql
            + ' TO [sa]' + CHAR(13)
            + 'IF NOT  EXISTS (SELECT * FROM sys.database_principals WHERE type = ''S'' AND name = '
            + '''' + @User + '''' + ')' + CHAR(13) + 'BEGIN' + CHAR(13)
            + 'CREATE USER ' + @User + +' FOR LOGIN ' +  @Login + 
            + CHAR(13) + 'GRANT CONNECT TO ' + @User + CHAR(13) + 'END'
            + CHAR(13) + 'ELSE' + CHAR(13) + 'BEGIN' + CHAR(13)
            + 'CREATE TABLE #Temp ([UserName] SYSNAME NULL ,[RoleName] SYSNAME NULL ,[LoginName] SYSNAME NULL ,[DefDBName] SYSNAME NULL ,[DefSchemaName] SYSNAME NULL ,[UserID] SMALLINT , '
            + '[SID] SMALLINT)' + CHAR(13)
            + 'INSERT  INTO #Temp( [UserName], [RoleName], [LoginName], [DefDBName], [DefSchemaName], [UserID], [SID] ) '
            + CHAR(13) + 'EXEC sys.sp_helpuser @name_in_db = ' + '''' + @User
            + '''' + CHAR(13) + 'SELECT  * FROM    #Temp' + CHAR(13)           
			+ ' IF ( SELECT DISTINCT LoginName FROM   #Temp ) IS NULL '
            + CHAR(13) + 'OR' + CHAR(13) + '''' + @Login + ''''
            + ' NOT IN ( SELECT DISTINCT LoginName FROM   #Temp )' + CHAR(13)            
			+ 'BEGIN' + CHAR(13) + +'DROP USER ' + @User + +CHAR(13)
            + 'CREATE USER ' + @User + +' FOR LOGIN ' + @Login + 
            + CHAR(13) + 'GRANT CONNECT TO ' + @User + CHAR(13)
            + 'END' + CHAR(13)
            + 'IF ''db_owner'' IN ( SELECT [RoleName] FROM #Temp )' + CHAR(13)
            + 'BEGIN' + CHAR(13) + 'EXEC sp_droprolemember ''db_owner'', '
            + '''' + @User + '''' + CHAR(13) + 'DROP TABLE #Temp' + CHAR(13)
            + 'END' + CHAR(13) + 'END' + CHAR(13)
            + 'EXEC sp_addrolemember ' +  '''' + @Role + '''' + ', ' + '''' + @User + ''''
            
            
        PRINT ( @sql )
        EXEC (@sql)
		INSERT INTO [DBAMonitor].[dbo].[SEC_SECURITYLOG] values (GETDATE(), @sql)
        SET @sqlDB = ''
        SET @sql = ''
      
        FETCH NEXT FROM users_cursor INTO  @sql    
    END
  

--close cursor
CLOSE users_cursor
DEALLOCATE users_cursor

DROP TABLE #Mappings33

DROP TABLE #Mappings100
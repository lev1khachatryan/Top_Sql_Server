SET NOCOUNT ON 
set ansi_warnings off


--Load data from file
DECLARE @sql1 VARCHAR(8000)
DECLARE @sql2 VARCHAR(256)
SET @sql2 = 'C:\SECURITYEXCEL\SIS2S034_Permissions_Mapping.csv'
DECLARE @team VARCHAR(256)
SET @team = NULL
DECLARE @db VARCHAR(256)
SET @db = NULL


--**********   work table  #Mappings1  ************--

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
	  [Pref_type] VARCHAR(256) ,
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
	  [Pref_type],
      [Login],
      [ServPermList],
      [FromWinGroup],
      [User],
      [Role],
      [Team],
      [IsActive])
	  select  [Server],
      left([Database],len([Database])-1),
	  'R',
      [Login],
      [ServPermList],
      [FromWinGroup],
      [User],
      [Role],
      [Team],
      [IsActive] 
	 from #Mappings33 where  [Database]!= '*' AND [Database] like '%*' and [Server] = @@SERVERNAME AND [Database] not  like '%**'
	 	INSERT INTO #Mappings100
    ( [Server],
      [Preface],
	  [Pref_type],
      [Login],
      [ServPermList],
      [FromWinGroup],
      [User],
      [Role],
      [Team],
      [IsActive])
	  select  [Server],
      right([Database],len([Database])-1),
	  'L',
      [Login],
      [ServPermList],
      [FromWinGroup],
      [User],
      [Role],
      [Team],
      [IsActive] 
	 from #Mappings33 where  [Database]!= '*' AND [Database] like '*%' and [Server] = @@SERVERNAME  AND [Database] not  like '%*'
	 INSERT INTO #Mappings100
    ( [Server],
      [Preface],
	  [Pref_type],
      [Login],
      [ServPermList],
      [FromWinGroup],
      [User],
      [Role],
      [Team],
      [IsActive])
	  select  [Server],
      left([Database],len([Database])-2),
	  'M',
      [Login],
      [ServPermList],
      [FromWinGroup],
      [User],
      [Role],
      [Team],
      [IsActive] 
	  from #Mappings33 where  [Database]!= '*' AND [Database] like '%**' and [Server] = @@SERVERNAME  AND [Database] not like '*%'

	  
CREATE TABLE #Mappings105 ([Server_name] VARCHAR(256)
           ,[Database_name] VARCHAR(256)
           , [Preface]  VARCHAR(256)
		   ,[Pref_type] VARCHAR(256))
 DECLARE @Preface VARCHAR(256)
	 SET @Preface= NULL
DECLARE @Pref_type VARCHAR(256)
	 SET @Pref_type= NULL	
	 DECLARE cursor_groupname CURSOR 
    FOR SELECT [Preface], [Pref_type] FROM #Mappings100
 OPEN  cursor_groupname
 FETCH NEXT FROM cursor_groupname INTO   @Preface, @Pref_type
 WHILE @@FETCH_STATUS = 0 
 BEGIN
	
INSERT INTO #Mappings105
           ([Server_name]
           ,[Database_name]
           ,[Preface]
		   ,[Pref_type])

SELECT  (SELECT @@SERVERNAME )as 'server',  name,  @Preface, @Pref_type  FROM sys.databases where name like @Preface + '%'  and  @Pref_type='R'	   
		AND name NOT LIKE 'master%'
		AND name NOT LIKE 'model%'
		AND name NOT LIKE 'tempdb%'
		AND name NOT LIKE 'msdb%'
INSERT INTO #Mappings105
           ([Server_name]
           ,[Database_name]
           ,[Preface]
		   ,[Pref_type])
SELECT  (SELECT @@SERVERNAME )as 'server',  name,  @Preface, @Pref_type  FROM sys.databases where name like  '%' + @Preface   and  @Pref_type='L'	   
		AND name NOT LIKE 'master%'
		AND name NOT LIKE 'model%'
		AND name NOT LIKE 'tempdb%'
		AND name NOT LIKE 'msdb%'
INSERT INTO #Mappings105
           ([Server_name]
           ,[Database_name]
           ,[Preface]
		   ,[Pref_type])
SELECT  (SELECT @@SERVERNAME )as 'server',  name,  @Preface, @Pref_type  FROM sys.databases where name like  '%' + @Preface +'%'  and  @Pref_type='M'	   
		AND name NOT LIKE 'master%'
		AND name NOT LIKE 'model%'
		AND name NOT LIKE 'tempdb%'
		AND name NOT LIKE 'msdb%'
FETCH NEXT FROM cursor_groupname INTO  @Preface, @Pref_type
END  
CLOSE cursor_groupname
DEALLOCATE cursor_groupname 

CREATE TABLE #Mappings15 ([Server_name] VARCHAR(256)
           ,[Database_name] VARCHAR(256)
           , [Preface]  VARCHAR(256)
		   ,[Pref_type] VARCHAR(256))

		   INSERT INTO #Mappings15
           ([Server_name]
           ,[Database_name]
           ,[Preface]
		   ,[Pref_type])
select distinct * from #Mappings105

CREATE TABLE #Mappings1
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
	INSERT INTO #Mappings1
    ( [Server],
      [Database],
      [Login],
      [ServPermList],
      [FromWinGroup],
      [User],
      [Role],
      [Team],
      [IsActive])
select  [Server],
      [Database],
      [Login],
      [ServPermList],
      [FromWinGroup],
      [User],
      [Role],
      [Team],
      [IsActive] 
	 from #Mappings33  where  [Database]= '*' and [Server] = @@SERVERNAME 
union all
select  a.[Server],  
      b.[Database_name],
      a.[Login],
      a.[ServPermList],
      a.[FromWinGroup],
      a.[User],
      a.[Role],
      a.[Team],
      a.[IsActive] from #Mappings100  as a join  #Mappings15 as b
	   on a. [Preface]=b.[Preface]
	  WHERE a.[Pref_type]=b.[Pref_type]
	  	  union all
select [Server] ,
      [Database] ,
      [Login] ,
      [ServPermList] ,
      [FromWinGroup] ,
      [User] ,
      [Role] ,
      [Team] ,
      [IsActive]  from #Mappings33 where  [Database] not  like '%*%' and [Server]=@@SERVERNAME

--**********   work table  #Mappings1 **********--

--Create sis_public, sis_dmladmin and sis_ddladmin roles on databases
DECLARE @rolename NVARCHAR(128) ;
DECLARE @sql VARCHAR(8000) ;
DECLARE @sqlDB VARCHAR(100) ;
--load all databases; ignore system DBs
DECLARE RoleFind_Cursor CURSOR SCROLL
FOR 
SELECT DISTINCT [Role] 
FROM #Mappings1 WHERE [Server] = @@SERVERNAME  AND [Database]  IN ('*')

  -- specify the DBs for which you would like to run this script

			
			
--open cursor
OPEN RoleFind_Cursor 

--loop through all DBs; 
FETCH NEXT FROM RoleFind_Cursor
	INTO @rolename 
	
WHILE @@FETCH_STATUS = 0 
    BEGIN
        DECLARE @dbname NVARCHAR(100)
        DECLARE DB_Cursor CURSOR SCROLL
        FOR SELECT QUOTENAME(name) FROM sys.databases 
        WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb')
        ORDER BY name
        OPEN DB_Cursor
        FETCH NEXT FROM  DB_Cursor INTO @dbname
        WHILE @@FETCH_STATUS = 0 
            BEGIN
                PRINT 'Creating role ' + @rolename + CHAR(13) + CHAR(10)
                SET @sqlDB = 'USE ' + @dbname + ' ' + CHAR(13) ;
                SET @sql = @sqlDB
                    + 'IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = '
                    + '''' + @rolename + '''' + ' AND type = ''R'')' + CHAR(13)
                    + 'CREATE ROLE ' + @rolename + ' AUTHORIZATION [dbo]'
                    + CHAR(13) + CHAR(10) + 'IF ' + '''' + @rolename + ''''
                    + ' = ''sis_public'' ' + CHAR(13) + CHAR(10) + 'BEGIN'
                    + CHAR(13) + CHAR(10) + 'GRANT DELETE TO ' + @rolename
                    + CHAR(13) + CHAR(10) + 'GRANT EXECUTE TO ' + @rolename
                    + CHAR(13) + CHAR(10) + 'GRANT INSERT TO ' + @rolename
                    + CHAR(13) + CHAR(10) + 'GRANT SELECT TO ' + @rolename
                    + CHAR(13) + CHAR(10) + 'GRANT UPDATE TO ' + @rolename
                    + CHAR(13) + CHAR(10) + 'END' + CHAR(13) + CHAR(10)
                    + 'ELSE IF ' + '''' + @rolename + ''''
                    + ' = ''sis_dmladmin''' + CHAR(13) + CHAR(10) + 'BEGIN'
                    + CHAR(13) + CHAR(10) + 'GRANT EXECUTE TO ' + @rolename
					+ CHAR(13) + CHAR(10) + 'GRANT DELETE TO ' + @rolename
                    + CHAR(13) + CHAR(10) + 'GRANT INSERT TO ' + @rolename
                    + CHAR(13) + CHAR(10) + 'GRANT SELECT TO ' + @rolename
                    + CHAR(13) + CHAR(10) + 'GRANT UPDATE TO ' + @rolename
                    + CHAR(13) + CHAR(10) + 'GRANT VIEW DEFINITION TO '
                    + @rolename + CHAR(13) + CHAR(10) + 'END' + CHAR(13)
                    + CHAR(10) + 'ELSE IF ' + '''' + @rolename + ''''
                    + ' = ''sis_ddladmin''' + ' OR ' + '''' + @rolename + ''''
                    + ' = ''sis_admin''' + CHAR(13) + CHAR(10) + 'BEGIN'
                    + CHAR(13) + CHAR(10)
                    + 'EXEC sp_addrolemember N''db_owner'', ' + 'N' + ''''
                    + @rolename + '''' + CHAR(13) + CHAR(10)
                    + 'EXEC sp_addrolemember N''db_backupoperator'', ' + 'N'
                    + '''' + @rolename + '''' + CHAR(13) + CHAR(10) + 'END'
                    + CHAR(13)
                     
                PRINT ( @sql ) 
                EXEC(@sql)
				INSERT INTO [DBAMonitor].[dbo].[SEC_SECURITYLOG] values (GETDATE(), @sql)	
                SET @sql = '' 
                FETCH NEXT FROM  DB_Cursor INTO @dbname
            END
        CLOSE DB_Cursor
        DEALLOCATE DB_Cursor
        
        FETCH NEXT FROM RoleFind_Cursor
		INTO @rolename 
   
    END
   
--close cursor
CLOSE RoleFind_Cursor
DEALLOCATE RoleFind_Cursor

DROP TABLE #Mappings1
DROP TABLE #Mappings15
DROP TABLE #Mappings33
DROP TABLE #Mappings100
DROP TABLE #Mappings105

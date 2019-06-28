
--Load data from file
DECLARE @sql1 VARCHAR(8000)
DECLARE @sql2 VARCHAR(256)
SET @sql2 = 'C:\SECURITYEXCEL\SIS2S034_Permissions_Mapping.csv'
DECLARE @team VARCHAR(256)
SET @team = NULL
DECLARE @db VARCHAR(256)
SET @db = NULL


--**********   work table  #Mappings3  ************--

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

CREATE TABLE #Mappings3
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
	INSERT INTO #Mappings3
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

--**********   work table  #Mappings3 **********--

--Create User,Login and attach to Role

--variables
DECLARE @sqlDB VARCHAR(8000) 
DECLARE @Server VARCHAR(256)
DECLARE @Database VARCHAR(8000)

--SELECT  name AS [Login]
--FROM    sys.syslogins
--WHERE   name NOT IN ( SELECT DISTINCT
--                                [Login]
--                      FROM      #Mappings3
--                      WHERE     [Server] = @@SERVERNAME )
--        AND name NOT IN ( SELECT DISTINCT
--                                    [Login]
--                          FROM      #Mappings3
--                          WHERE     [Server] = @@SERVERNAME )



DECLARE users_cursor  CURSOR SCROLL
FOR SELECT DISTINCT  [Server] ,
[Database]
FROM  #Mappings3
WHERE [Server] = @@SERVERNAME AND  ISNULL(@team,Team) = Team  AND  ISNULL(@db,[Database]) = [Database] 

OPEN  users_cursor 
FETCH NEXT FROM users_cursor INTO  @Server,@Database

    
WHILE @@FETCH_STATUS = 0 
    BEGIN
    
        IF @Database NOT IN ( '*' ) 
            BEGIN
    
                SET @sqlDB = 'USE ' + @Database + ' ' + CHAR(13) + 'SELECT '
                    + '''' + @Database + '''' + 'AS DatabaseName' + CHAR(13)
                    + 'SELECT name as [User] FROM sys.database_principals WHERE (type = ''G'' OR type = ''S'''
                    + ')' + ' AND name NOT IN  ('
                    + 'SELECT  [User]  FROM #Mappings3 WHERE [Server] = '
                    + '''' + @@SERVERNAME + '''' + ' AND  [Database] = '
                    + '''' + @Database + '''' + ')'
                    + ' AND name NOT IN (''dbo'', ''guest'', ''INFORMATION_SCHEMA'', ''sys'', ''TestUser'')'
                    + ' AND name NOT IN (SELECT  [User]  FROM #Mappings3 WHERE [Server] = '
                    + '''' + @@SERVERNAME + '''' + ' AND  [Database] IN '
                    + '(''*'')' + ')' + CHAR(13)
            
            
                SET @sqlDB = @sqlDB
                    + ' SELECT name as [Role] FROM sys.database_principals WHERE  type = ''R'' AND name NOT IN (''public'') AND is_fixed_role = 0 AND name NOT IN ('
                    + ' SELECT  [Role]  FROM #Mappings3 WHERE [Server] = '
                    + '''' + @@SERVERNAME + '''' + ' AND  [Database] = '
                    + '''' + @Database + '''' + ')'
                    + ' AND name NOT IN (SELECT  [Role]  FROM #Mappings3 WHERE [Server] = '
                    + '''' + @@SERVERNAME + '''' + ' AND  [Database] IN '
                    + '(''*'')' + ')' + CHAR(13)         
                  
            
                PRINT @sqlDB   
                EXEC(@sqlDB)
				INSERT INTO [DBAMonitor].[dbo].[SEC_SECURITYLOG] values (GETDATE(), @sqlDB)
                SET @sqlDB = '' 
                FETCH NEXT FROM users_cursor INTO  @Server,@Database
   
       
            END
    
    END
    

--close cursor
CLOSE users_cursor
DEALLOCATE users_cursor

DROP TABLE #Mappings3  
DROP TABLE #Mappings100
DROP TABLE #Mappings33
DROP TABLE #Mappings105
DROP TABLE #Mappings15

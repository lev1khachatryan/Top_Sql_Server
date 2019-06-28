DECLARE @sql VARCHAR(8000)
DECLARE @sql1 VARCHAR(8000)
DECLARE @sql2 VARCHAR(256)
DECLARE @sqlDB VARCHAR(256)
SET @sql2 = 'C:\SECURITYEXCEL\SIS2S093_Permissions_Mapping.csv'



--**********   work table  #Mappings13  ************--

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

CREATE TABLE #Mappings13
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
	INSERT INTO #Mappings13
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

--**********   work table  #Mappings13 **********--

DECLARE @DBName VARCHAR(256)

DECLARE dbc CURSOR 
FOR 
SELECT  QUOTENAME(name)
FROM    sys.databases
WHERE   name NOT IN (SELECT    [Database]
FROM      #Mappings13 WHERE [Server] = @@SERVERNAME  ) AND name NOT IN ('master','model','msdb','tempdb' ) 
ORDER BY 1                      
CREATE TABLE #DBs (dbname VARCHAR(256))                    
OPEN dbc

FETCH NEXT FROM dbc INTO @DBname

WHILE @@FETCH_STATUS = 0 
    BEGIN

        SET @sqlDB = 'USE ' + @DBName + CHAR(13)
        SET @sql = @sqlDB + 'DECLARE @rolename VARCHAR(256)' + CHAR(13)
            + 'DECLARE rc CURSOR' + CHAR(13)
            + 'FOR  SELECT name FROM sys.database_principals' + CHAR(13)
            + 'WHERE  type = ''R''' + CHAR(13) + 'OPEN rc' + CHAR(13)
            + 'FETCH NEXT FROM rc INTO ' + '@rolename' + CHAR(13)
            + 'WHILE @@FETCH_STATUS = 0' + CHAR(13) + 'BEGIN' + CHAR(13)
            + 'IF  @rolename '
            + 'IN (SELECT DISTINCT [Role] FROM #Mappings13 )' + CHAR(13)+
            + 'INSERT INTO #DBs(dbname) VALUES (' + ''''+ @DBName + '''' + ')' + CHAR(13)+
            + '-- EXEC(''DROP ROLE '' + @rolename) ' + CHAR(13)
            + 'FETCH NEXT FROM rc INTO   ' + '@rolename' + CHAR(13) + 'END'
            + CHAR(13) + 'CLOSE rc' + CHAR(13) + 'DEALLOCATE rc' + CHAR(13)
            + 'DECLARE @username VARCHAR(256)' + CHAR(13)
            + 'DECLARE uc CURSOR FOR' + CHAR(13)
            + 'SELECT name FROM sys.database_principals' + CHAR(13)
            + 'WHERE type = ''S''  OR type = ''G''' + CHAR(13) + 'OPEN uc'
            + CHAR(13) + 'FETCH NEXT FROM uc INTO @username' + CHAR(13)
            + 'WHILE @@FETCH_STATUS = 0' + CHAR(13) + 'BEGIN' + CHAR(13)
            + 'IF @username' + ' IN (SELECT [User] FROM #Mappings13 WHERE LOWER([USER]) NOT IN (''idmdaduser'') )'
            + CHAR(13) + 'INSERT INTO #DBs(dbname) VALUES (' + '''' + @DBName +  '''' + ')' + CHAR(13)+ 
            '-- EXEC ( ''DROP USER ''' + '+' + ' @username)'
            + CHAR(13) + 'FETCH NEXT FROM uc INTO @username' + CHAR(13)
            + 'END' + CHAR(13) + 'CLOSE uc' + CHAR(13) + 'DEALLOCATE uc'
            + CHAR(13)

        PRINT ( @sql )
        EXEC (@sql)
		INSERT INTO [DBAMonitor].[dbo].[SEC_SECURITYLOG] values (GETDATE(), @sql)
        SET @sql = ''
        FETCH NEXT FROM dbc INTO @DBname

    END


CLOSE dbc
DEALLOCATE dbc 
SELECT DISTINCT dbname FROM #DBs  
DROP TABLE #DBs

DROP TABLE #Mappings13    	  
DROP TABLE #Mappings100
DROP TABLE #Mappings33
DROP TABLE #Mappings105
DROP TABLE #Mappings15

                      
                      
                      
                      
                      
                      
                      
                      

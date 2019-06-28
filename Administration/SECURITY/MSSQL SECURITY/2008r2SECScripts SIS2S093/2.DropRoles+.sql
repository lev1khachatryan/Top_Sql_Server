SET NOCOUNT ON 



--Load data from file
DECLARE @sql1 VARCHAR(8000)
DECLARE @sql2 VARCHAR(256)
SET @sql2 = 'C:\SECURITYEXCEL\SIS2S093_Permissions_Mapping.csv'
DECLARE @team VARCHAR(256)
SET @team = NULL
DECLARE @db VARCHAR(256)
SET @db = NULL


--**********   work table  #Mappings2  ************--

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

--create cursor for '*' databases
CREATE TABLE #MappingsALL
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
 DECLARE @alldbname VARCHAR(256)
	 SET @alldbname= NULL

	
	 DECLARE cursor_all CURSOR 
    FOR SELECT [name]FROM  sys.databases
	where [name] NOT IN ('master','model', 'tempdb', 'msdb')
 OPEN  cursor_all
 FETCH NEXT FROM cursor_all INTO   @alldbname
 WHILE @@FETCH_STATUS = 0 
 BEGIN
	
INSERT INTO #MappingsALL
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
      @alldbname,
      [Login],
      [ServPermList],
      [FromWinGroup],
      [User],
      [Role],
      [Team],
      [IsActive] 
	 FROM #Mappings33  where  [Database]= '*' and [Server] = @@SERVERNAME  and [Login]!='idmdaduser' 


FETCH NEXT FROM cursor_all INTO  @alldbname
END  
CLOSE cursor_all
DEALLOCATE cursor_all 


--end cursor for '*' databases

CREATE TABLE #Mappings2
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
	INSERT INTO #Mappings2
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
	 from #Mappings33  where  [login]= 'idmdaduser' and [Server] = @@SERVERNAME 
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
select b.[Server],
      b.[Database],
      b.[Login],
      b.[ServPermList],
      b.[FromWinGroup],
      b.[User],
      b.[Role],
      b.[Team],
      b.[IsActive] from #MappingsALL as b
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

--**********   work table  #Mappings2 **********--


--Drop sis_public, sis_dmladmin, sis_ddladmin and sis_admin roles on databases
DECLARE @dbname NVARCHAR(128) ;
DECLARE @sql VARCHAR(8000) ;
DECLARE @sqlDB VARCHAR(100) ;
--load all databases; ignore system DBs
DECLARE DbFind_Cursor CURSOR SCROLL
FOR 
SELECT QUOTENAME(name) FROM sys.databases 
WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb')
AND name IN (SELECT [Database] FROM #Mappings2 WHERE [Server] = @@SERVERNAME AND ISNULL(@team,Team) = Team AND ISNULL(@db,[Database]) = [Database] AND [Database] NOT IN ('*')) -- specify the DBs for which you would like to run this script
ORDER BY name ;
			
			
--open cursor
OPEN DbFind_Cursor ;

--loop through all DBs; 
FETCH NEXT FROM DbFind_Cursor
	INTO @dbname ;
	
WHILE @@FETCH_STATUS = 0 
    BEGIN
        DECLARE @Role NVARCHAR(100)
        DECLARE Role_Cursor CURSOR SCROLL
        FOR SELECT DISTINCT [Role] FROM #Mappings2 WHERE [Server] = @@SERVERNAME AND ISNULL(@team,Team) = Team 
        OPEN Role_Cursor
        FETCH NEXT FROM  Role_Cursor INTO @Role
        WHILE @@FETCH_STATUS = 0 
            BEGIN
                PRINT 'Dropping role ' + @Role + CHAR(13) + CHAR(10)
                SET @sqlDB = 'USE ' + @dbname + ' ' + CHAR(13) ;
                SET @sql = @sqlDB + 'DECLARE @RoleName SYSNAME ' + CHAR(13)
                    + CHAR(10) + 'SET @RoleName =' + '''' + @Role + ''''
                    + CHAR(13) + CHAR(10)
                    + 'IF  EXISTS (SELECT * FROM dbo.sysusers WHERE name = @RoleName AND issqlrole = 1) '
                    + CHAR(13) + CHAR(10) + 'BEGIN ' + CHAR(13) + CHAR(10)
                    + 'DECLARE @RoleMemberName SYSNAME ' + CHAR(13) + CHAR(10)
                    + 'DECLARE Member_Cursor CURSOR FOR ' + CHAR(13) + CHAR(10)
                    + 'SELECT [name] ' + CHAR(13) + CHAR(10)
                    + 'FROM dbo.sysusers ' + CHAR(13) + CHAR(10)
                    + 'WHERE uid in ( ' + CHAR(13) + CHAR(10)
                    + 'SELECT memberuid ' + CHAR(13) + CHAR(10)
                    + 'FROM dbo.sysmembers' + CHAR(13) + CHAR(10)
                    + 'WHERE groupuid in ( ' + CHAR(13) + CHAR(10)
                    + 'SELECT uid ' + CHAR(13) + CHAR(10)
                    + 'FROM dbo.sysusers WHERE [name] = @RoleName AND issqlrole = 1)) '
                    + CHAR(13) + CHAR(10) + 'OPEN Member_Cursor; ' + CHAR(13)
                    + CHAR(10) + 'FETCH NEXT FROM Member_Cursor ' + CHAR(13)
                    + CHAR(10) + 'INTO @RoleMemberName ' + CHAR(13) + CHAR(10)
                    + 'WHILE @@FETCH_STATUS = 0 ' + CHAR(13) + CHAR(10)
                    + 'BEGIN ' + CHAR(13) + CHAR(10)
                    + 'EXEC sp_droprolemember @rolename=@RoleName, @membername= @RoleMemberName '
                    + CHAR(13) + CHAR(10) + 'FETCH NEXT FROM Member_Cursor '
                    + CHAR(13) + CHAR(10) + 'INTO @RoleMemberName ' + CHAR(13)
                    + CHAR(10) + 'END ' + CHAR(13) + CHAR(10)
                    + 'CLOSE Member_Cursor ' + CHAR(13) + CHAR(10)
                    + 'DEALLOCATE Member_Cursor ' + CHAR(13) + CHAR(10)
                    + 'END ' + CHAR(13) + CHAR(10)
                    + 'IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = '
                    + '''' + @Role + '''' + ' AND type = ''R'') ' + CHAR(13)
                    + CHAR(10) + 'DROP ROLE ' + @Role + CHAR(13)
         
                PRINT ( @sql ) 
                EXEC(@sql)
				INSERT INTO [DBAMonitor].[dbo].[SEC_SECURITYLOG] values (GETDATE(), @sql)	
                FETCH NEXT FROM  Role_Cursor INTO @Role
            END
        CLOSE Role_Cursor
        DEALLOCATE Role_Cursor
        
        FETCH NEXT FROM DbFind_Cursor
		INTO @dbname 
   
    END
   
--close cursor
CLOSE DbFind_Cursor
DEALLOCATE DbFind_Cursor


DROP TABLE #Mappings2
DROP TABLE #Mappings100
DROP TABLE #Mappings33
DROP TABLE #Mappings105
DROP TABLE #Mappings15
DROP TABLE #MappingsALL



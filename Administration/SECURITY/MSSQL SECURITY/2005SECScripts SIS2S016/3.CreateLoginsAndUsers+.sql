SET NOCOUNT ON 


--Load data from file
DECLARE @sql1 VARCHAR(8000)
DECLARE @sql2 VARCHAR(256)
SET @sql2 = 'C:\SECURITYEXCEL\SIS2S016_Permissions_Mapping.csv'
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


--**********   work table  #Mappings3 **********--

--Create User,Login and attach to Role

--variables
DECLARE @sql VARCHAR(8000) 
DECLARE @sqlDB VARCHAR(100) 
DECLARE @Server VARCHAR(256)
DECLARE @Database VARCHAR(8000)
DECLARE @Login VARCHAR(256)
DECLARE @User VARCHAR(256)
DECLARE @Role VARCHAR(256)
DECLARE @ServPermList VARCHAR(256)
DECLARE @FromWinGroup BIT
DECLARE users_cursor  CURSOR SCROLL
FOR SELECT [Server] ,
[Database] ,
[Login] ,
[ServPermList],
[FromWinGroup],
[User] ,
[Role]  FROM  #Mappings3
WHERE [Server] = @@SERVERNAME AND ISNULL(@team,Team) = Team  AND IsActive = 0 AND  ISNULL(@db,[Database]) = [Database] AND [Database] NOT IN ('*')

OPEN  users_cursor 
FETCH NEXT FROM users_cursor INTO  @Server,@Database,@Login,@ServPermList,@FromWinGroup,@User,@Role

WHILE @@FETCH_STATUS = 0 
    BEGIN
        SET @sqlDB = 'USE ' + '[' + @Database + ']' + ' ' + CHAR(13) 
        IF @FromWinGroup = 1 
            BEGIN 
                SET @sql = @sqlDB
                    + 'IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname =  '
                    + '''' +  @Login + '''' + ')' + CHAR(13)
                    + CHAR(10) + 'BEGIN ' + CHAR(13) + 'CREATE LOGIN ' + '['
                    + @Login
                    + '] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]'
                    + CHAR(13) + CHAR(10)
                IF @ServPermList IS NOT NULL 
                    BEGIN 
                        CREATE TABLE #Mappings5
                            (
                              Id INT ,
                              Data NVARCHAR(100)
                            ) 
 
                        BEGIN 
                            DECLARE @Cnt1 INT
                            SET @Cnt1 = 1

                            WHILE ( CHARINDEX(':', @ServPermList) > 0 ) 
                                BEGIN
		
			
                                    INSERT  INTO #Mappings5
                                            ( Id ,
                                              Data 
                                            )
                                            SELECT  @Cnt1 ,
                                                    Data = LTRIM(RTRIM(SUBSTRING(@ServPermList,
                                                              1,
                                                              CHARINDEX(':',
                                                              @ServPermList)
                                                              - 1)))
		
                                    SET @ServPermList = SUBSTRING(@ServPermList,
                                                              CHARINDEX(':',
                                                              @ServPermList)
                                                              + 1,
                                                              LEN(@ServPermList))
                                    SET @Cnt1 = @Cnt1 + 1
                                END
	
                            INSERT  INTO #Mappings5
                                    ( ID ,
                                      data
                                    )
                                    SELECT  @Cnt1 ,
                                            Data = LTRIM(RTRIM(@ServPermList))
	
                        
                            DECLARE @perm1 VARCHAR(256)
                            DECLARE pc1 CURSOR FOR SELECT Data FROM #Mappings5
                            OPEN pc1 
                            FETCH NEXT FROM pc1 INTO @perm1
                            WHILE @@FETCH_STATUS = 0 
                                BEGIN
                        
                                    SET @sql = @sql
                                        + 'EXEC sp_addsrvrolemember ' + ''''
                                        + @Login + ''''
                                        + +', ' + '''' + @perm1 + +''''
                                        + CHAR(13) + CHAR(10) 
                                    FETCH NEXT FROM pc1 INTO @perm1
                            
                                END
                            CLOSE pc1
                            DEALLOCATE pc1
                        
                            DROP TABLE #Mappings5           
          
                        END
                    END
                SET @sql = @sql + 'END'
            END
                         
        ELSE 
            BEGIN

			 SET @sql = ''

                SET @sql = @sqlDB
                    + 'IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname =  '
                    + '''' + @Login + '''' + ')' + CHAR(13) + CHAR(10)
                    + 'BEGIN ' + CHAR(13) /*+ 'CREATE LOGIN ' + '[' + @Login
                    + ']' + CHAR(13) + CHAR(10)*/
                IF @ServPermList IS NOT NULL 
                    BEGIN 
                        CREATE TABLE #Mappings6
                            (
                              Id INT ,
                              Data NVARCHAR(100)
                            ) 
 
                        BEGIN 
                            DECLARE @Cnt2 INT
                            SET @Cnt2 = 1

                            WHILE ( CHARINDEX(':', @ServPermList) > 0 ) 
                                BEGIN
		
			
                                    INSERT  INTO #Mappings6
                                            ( Id ,
                                              Data 
                                            )
                                            SELECT  @Cnt2 ,
                                                    Data = LTRIM(RTRIM(SUBSTRING(@ServPermList,
                                                              1,
                                                              CHARINDEX(':',
                                                              @ServPermList)
                                                              - 1)))
		
                                    SET @ServPermList = SUBSTRING(@ServPermList,
                                                              CHARINDEX(':',
                                                              @ServPermList)
                                                              + 1,
                                                              LEN(@ServPermList))
                                    SET @Cnt2 = @Cnt2 + 1
                                END
	
                            INSERT  INTO #Mappings6
                                    ( ID ,
                                      data
                                    )
                                    SELECT  @Cnt2 ,
                                            Data = LTRIM(RTRIM(@ServPermList))
	
                        END  
                        DECLARE @perm2 VARCHAR(256)
                        DECLARE pc2 CURSOR FOR SELECT Data FROM #Mappings6
                        OPEN pc2 
                        FETCH NEXT FROM pc2 INTO @perm2
                        WHILE @@FETCH_STATUS = 0 
                            BEGIN
                        
                                SET @sql = @sql + 'EXEC sp_addsrvrolemember '
                                    + '''' + @Login + '''' + ', ' + ''''
                                    + @perm2 + '''' + CHAR(13) + CHAR(10) 
                                FETCH NEXT FROM pc2 INTO @perm2
                            
                            END
                        CLOSE pc2
                        DEALLOCATE pc2
                        
                        DROP TABLE #Mappings6
                    END 
                SET @sql = @sql + 'END'        
            END
            
        EXEC(@sql) ;
        PRINT @sql 
		INSERT INTO [DBAMonitor].[dbo].[SEC_SECURITYLOG] values (GETDATE(), @sql)
        SET @sql = '' 
        FETCH NEXT FROM users_cursor INTO  @Server,@Database,@Login,@ServPermList,@FromWinGroup,@User,@Role
   
       
    END
    
FETCH FIRST FROM users_cursor  INTO  @Server,@Database,@Login,@ServPermList,@FromWinGroup,@User,@Role
    
WHILE @@FETCH_STATUS = 0 
    BEGIN
        SET @sqlDB = 'USE ' + '[' + @Database + ']' + ' ' + CHAR(13) 
        IF @FromWinGroup = 1 
            SET @sql = @sqlDB
                + 'IF  NOT EXISTS (SELECT * FROM sys.database_principals WHERE (type = ''G'' OR type = ''U'')AND name = '
                + '''' ++  @User + + '''' + ')' + CHAR(13) + CHAR(10) + 'BEGIN'
                + CHAR(13) + 'CREATE USER '+'[' + @User +']' + ' FOR LOGIN ' + '['
                + @Login + ']' + CHAR(13) + CHAR(10)
                + 'GRANT CONNECT TO ' + '['+ @User +']' + CHAR(13) + CHAR(10)
                + 'EXEC sp_addrolemember ' + '''' + @Role + '''' + ',' + ''''
                + @User + '''' + CHAR(13) + 'END'
            
        ELSE 
            SET @sql = @sqlDB
                + 'IF  NOT EXISTS (SELECT * FROM sys.database_principals WHERE type = ''S'' AND name = '
                + '''' + @User + '''' + ')' + CHAR(13) + CHAR(10) + 'BEGIN'
                + CHAR(13) + 'CREATE USER ' + @User + ' FOR LOGIN ' + '['
                + @Login + ']' + CHAR(13) + CHAR(10) + 'GRANT CONNECT TO '
                + @User + CHAR(13) + CHAR(10) + 'EXEC sp_addrolemember '
                + '''' + @Role + '''' + ',' + '''' + @User + '''' + CHAR(13)
                + 'END'
            
        EXEC(@sql) ;
        PRINT @sql 	
		INSERT INTO [DBAMonitor].[dbo].[SEC_SECURITYLOG] values (GETDATE(), @sql)	
        SET @sql = '' 		
		
        FETCH NEXT FROM users_cursor INTO  @Server,@Database,@Login,@ServPermList,@FromWinGroup,@User,@Role
   
       
    END
    

--close cursor
CLOSE users_cursor
DEALLOCATE users_cursor



DROP TABLE #Mappings3
DROP TABLE #Mappings100
DROP TABLE #Mappings33
DROP TABLE #Mappings105
DROP TABLE #Mappings15
DROP TABLE #MappingsALL

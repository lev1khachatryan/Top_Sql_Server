--Load data from file
DECLARE @sql1 VARCHAR(8000)
DECLARE @sql2 VARCHAR(256)
SET @sql2 = 'C:\SECURITYEXCEL\SIS2S016_Permissions_Mapping.csv'
DECLARE @db VARCHAR(256)
SET @db = NULL


--**********   work table  #Mappings10  ************--

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

CREATE TABLE #Mappings108 ([Server_name] VARCHAR(256)
           ,[Database_name] VARCHAR(256)
           , [Preface]  VARCHAR(256)
		   ,[Pref_type] VARCHAR(256))

		   INSERT INTO #Mappings108
           ([Server_name]
           ,[Database_name]
           ,[Preface]
		   ,[Pref_type])
select distinct * from #Mappings105

CREATE TABLE #Mappings10
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
	INSERT INTO #Mappings10
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
      a.[IsActive] from #Mappings100  as a join  #Mappings108 as b
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
	  
--**********   work table  #Mappings10 **********--

ALTER TABLE #Mappings10 ADD [IsOK] BIT


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
DECLARE @Team VARCHAR(256)
DECLARE @IsActive BIT
DECLARE @IsOK BIT
DECLARE users_cursor  CURSOR SCROLL
FOR SELECT [Server] ,
[Database] ,
[Login] ,
[ServPermList],
[FromWinGroup],
[User] ,
[Role],
[Team],
[IsActive]
FROM  #Mappings10
WHERE [Server] = @@SERVERNAME AND  ISNULL(@db,[Database]) = [Database] AND [Database] NOT IN ('*')

OPEN  users_cursor 
FETCH NEXT FROM users_cursor INTO  @Server,@Database,@Login,@ServPermList,@FromWinGroup,@User,@Role,@Team,@IsActive

WHILE @@FETCH_STATUS = 0 
    BEGIN
   
        SET @sqlDB = 'USE ' + '[' +@Database + ']' +' ' + CHAR(13) + CHAR(10) 
        IF @FromWinGroup = 1 
            BEGIN 
                SET @sql = @sqlDB
                    + 'IF  EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname =  '
                    + '''' + @Login + '''' + ')' + +CHAR(13)
                    + CHAR(10)
                IF @ServPermList IS NOT NULL 
                    BEGIN 
                        CREATE TABLE #Mappings11
                            (
                              Id INT ,
                              Data NVARCHAR(100)
                            ) 
 
                        BEGIN 
                            DECLARE @Cnt1 INT
                            SET @Cnt1 = 1

                            WHILE ( CHARINDEX(':', @ServPermList) > 0 ) 
                                BEGIN
		
			
                                    INSERT  INTO #Mappings11
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
	
                            INSERT  INTO #Mappings11
                                    ( ID ,
                                      data
                                    )
                                    SELECT  @Cnt1 ,
                                            Data = LTRIM(RTRIM(@ServPermList))
	
                        
                            DECLARE @perm1 VARCHAR(256)
                            DECLARE pc1 CURSOR FOR SELECT Data FROM #Mappings11
                            OPEN pc1 
                            FETCH NEXT FROM pc1 INTO @perm1
                            WHILE @@FETCH_STATUS = 0 
                                BEGIN
                        
                                    SET @sql = @sql
                                        + ' AND  IS_SRVROLEMEMBER( ' + ''''
                                        + @perm1 + '''' + ',' + '''' 
                                        +  @Login + '''' + ')' + '= 1'
                                        
                                    FETCH NEXT FROM pc1 INTO @perm1
                            
                                END
                            CLOSE pc1
                            DEALLOCATE pc1
                        
                            DROP TABLE #Mappings11          
          
                        END
                      
                    END
                    
                SET @sql = @sql
                    + ' AND   EXISTS (SELECT * FROM sys.database_principals WHERE type = ''G'' AND name = '
                    + '''' + @User + '''' + ')' + CHAR(13) + CHAR(10)
                    + ' AND  IS_ROLEMEMBER(' + '''' + @Role + '''' + ','
                    + '''' + @User + '''' + ')' + '= 1' + CHAR(13) + CHAR(10)
                    
            END
                         
        ELSE 
            BEGIN
                SET @sql = @sqlDB
                    + 'IF  EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname =  '
                    + '''' + @Login + '''' + ')' + CHAR(13) + CHAR(10)
                    
                IF @ServPermList IS NOT NULL 
                    BEGIN 
                        CREATE TABLE #Mappings12
                            (
                              Id INT ,
                              Data NVARCHAR(100)
                            ) 
 
                        BEGIN 
                            DECLARE @Cnt2 INT
                            SET @Cnt2 = 1

                            WHILE ( CHARINDEX(':', @ServPermList) > 0 ) 
                                BEGIN
		
			
                                    INSERT  INTO #Mappings12
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
	
                            INSERT  INTO #Mappings12
                                    ( ID ,
                                      data
                                    )
                                    SELECT  @Cnt2 ,
                                            Data = LTRIM(RTRIM(@ServPermList))
	
                        END  
                        DECLARE @perm2 VARCHAR(256)
                        DECLARE pc2 CURSOR FOR SELECT Data FROM #Mappings12
                        OPEN pc2 
                        FETCH NEXT FROM pc INTO @perm2
                        WHILE @@FETCH_STATUS = 0 
                            BEGIN
                        
                                SET @sql = @sql + ' AND  IS_SRVROLEMEMBER( '
                                    + '''' + @perm2 + '''' + ',' + ''''
                                    + +@Login + '''' + ')' + '= 1'
                                FETCH NEXT FROM pc2 INTO @perm2
                            
                            END
                        CLOSE pc2
                        DEALLOCATE pc2
                         
                        DROP TABLE #Mappings12
                    END    
                    
            
            
                SET @sql = @sql
                    + ' AND   EXISTS (SELECT * FROM sys.database_principals WHERE type = ''S'' AND name = '
                    + '''' + @User + '''' + ')' + CHAR(13) + CHAR(10)
                    + 'AND IS_ROLEMEMBER(' + '''' + @Role + '''' + ',' + ''''
                    + @User + '''' + ')' + '= 1' + CHAR(13) + CHAR(10)
            
            END
        
                    
        SET @sql = @sql + 'UPDATE #Mappings10 SET IsOK = 1'
            + ' WHERE Server = ' + '''' + @Server + '''' + ' AND '
            + '[Database] = ' + '''' + @Database + '''' + ' AND '
            + '[Login] = ' + '''' + @Login + '''' + ' AND '
            + 'FromWinGroup = ' + CAST(@FromWinGroup AS VARCHAR) + ' AND '
            + '[User] = ' + '''' + @User + '''' + ' AND ' + 'Role = ' + ''''
            + @Role + ''''
        PRINT @sql  
        EXEC(@sql) 
		INSERT INTO [DBAMonitor].[dbo].[SECURITYLOG] values (GETDATE(), @sql)
        SET @sqlDB = ''
        SET @sql = '' 
        FETCH NEXT FROM users_cursor INTO  @Server,@Database,@Login,@ServPermList,@FromWinGroup,@User,@Role,@Team,@IsActive
               
    END
    
--close cursor
CLOSE users_cursor
DEALLOCATE users_cursor



DECLARE @rls VARCHAR(256)
DECLARE @dbs VARCHAR(256)
DECLARE @sqlDB1 VARCHAR(256)
DECLARE @sql3 VARCHAR(8000)

DECLARE addroles CURSOR 

FOR SELECT [Database],[Role] FROM #Mappings10 WHERE[Server] = @@SERVERNAME AND IsOK IS NULL AND FromWinGroup = 1   AND  IsActive = 1 AND [Database] NOT IN ('*')

OPEN addroles

FETCH NEXT FROM addroles INTO @dbs,@rls

WHILE @@FETCH_STATUS = 0 
    BEGIN

        SET @sqlDB1 = 'USE ' + '[' + @dbs +']'+ CHAR(13)

        SET @sql3 = @sqlDB1
            + +'IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = '
            + '''' + @rls + '''' + ' AND type = ''R'')' + CHAR(13)
            + 'CREATE ROLE ' + @rls + ' AUTHORIZATION [dbo]' + CHAR(13)
            + CHAR(10) + 'IF ' + '''' + @Role + '''' + ' = ''sis_public'' '
            + CHAR(13) + CHAR(10) + 'BEGIN' + CHAR(13) + CHAR(10)
            + 'GRANT DELETE TO ' + @Role + CHAR(13) + CHAR(10)
            + 'GRANT EXECUTE TO ' + @Role + CHAR(13) + CHAR(10)
            + 'GRANT INSERT TO ' + @Role + CHAR(13) + CHAR(10)
            + 'GRANT SELECT TO ' + @Role + CHAR(13) + CHAR(10)
            + 'GRANT UPDATE TO ' + @Role + CHAR(13) + CHAR(10) + 'END'
            + CHAR(13) + CHAR(10) + 'ELSE IF ' + '''' + @rls + ''''
            + ' = ''sis_dmladmin''' + CHAR(13) + CHAR(10) + 'BEGIN' + CHAR(13)
            + CHAR(10) + 'GRANT EXECUTE TO ' + @rls + CHAR(13) + CHAR(10)
            + 'GRANT INSERT TO ' + @rls + CHAR(13) + CHAR(10)
            + 'GRANT SELECT TO ' + @rls + CHAR(13) + CHAR(10)
            + 'GRANT UPDATE TO ' + @rls + CHAR(13) + CHAR(10)
            + 'GRANT VIEW DEFINITION TO ' + @Role + CHAR(13) + CHAR(10)
            + 'END' + CHAR(13) + CHAR(10) + 'ELSE IF ' + '''' + @Role + ''''
            + ' = ''sis_ddladmin''' + ' OR ' + '''' + @Role + ''''
            + ' = ''sis_admin''' + CHAR(13) + CHAR(10) + 'BEGIN' + CHAR(13)
            + CHAR(10) + 'EXEC sp_addrolemember N''db_owner'', ' + 'N' + ''''
            + @rls + '''' + CHAR(13) + CHAR(10)
            + 'EXEC sp_addrolemember N''db_backupoperator'', ' + 'N' + ''''
            + @rls + '''' + CHAR(13) + CHAR(10) + 'END' + CHAR(13)
                    
        PRINT ( @sql3 )
        EXEC(@sql3)
        INSERT INTO [DBAMonitor].[dbo].[SECURITYLOG] values (GETDATE(), @sql3)            
        SET @sqlDB1 = ''
        SET @sql3 = '' 


        FETCH NEXT FROM addroles INTO @dbs,@rls

    END


CLOSE addroles
DEALLOCATE addroles 



DECLARE @sql4 VARCHAR(8000) 
DECLARE @sqlDB2 VARCHAR(100) 
DECLARE @Server1 VARCHAR(256)
DECLARE @Database1 VARCHAR(8000)
DECLARE @Login1 VARCHAR(256)
DECLARE @User1 VARCHAR(256)
DECLARE @Role1 VARCHAR(256)
DECLARE @ServPermList1 VARCHAR(256)
DECLARE @FromWinGroup1 BIT
DECLARE users_cursor1  CURSOR SCROLL
FOR SELECT [Server] ,
[Database] ,
[Login] ,
[ServPermList],
[FromWinGroup],
[User] ,
[Role]  FROM  #Mappings10
WHERE [Server] = @@SERVERNAME AND  IsOK IS NULL AND FromWinGroup = 1   AND  IsActive = 1 AND [Database] NOT IN ('*')


OPEN  users_cursor1 
FETCH NEXT FROM users_cursor1 INTO  @Server1,@Database1,@Login1,@ServPermList1,@FromWinGroup1,@User1,@Role1

WHILE @@FETCH_STATUS = 0 
    BEGIN
        SET @sqlDB2 = 'USE ' + '[' + @Database1 + ']' + ' ' + CHAR(13) 
        IF @FromWinGroup1 = 1 
            BEGIN 
                SET @sql4 = @sqlDB2
                    + 'IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname =  '
                    + ''''  + @Login1 + '''' + ')' + CHAR(13)
                    + CHAR(10) + 'BEGIN ' + CHAR(13) + 'CREATE LOGIN ' + '['
                    + @Login1
                    + '] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]'
                    + CHAR(13) + CHAR(10)
                IF @ServPermList1 IS NOT NULL 
                    BEGIN 
                        CREATE TABLE #Mappings13
                            (
                              Id INT ,
                              Data NVARCHAR(100)
                            ) 
 
                        BEGIN 
                            DECLARE @Cnt3 INT
                            SET @Cnt3 = 1

                            WHILE ( CHARINDEX(':', @ServPermList1) > 0 ) 
                                BEGIN
		
			
                                    INSERT  INTO #Mappings13
                                            ( Id ,
                                              Data 
                                            )
                                            SELECT  @Cnt3 ,
                                                    Data = LTRIM(RTRIM(SUBSTRING(@ServPermList1,
                                                              1,
                                                              CHARINDEX(':',
                                                              @ServPermList1)
                                                              - 1)))
		
                                    SET @ServPermList = SUBSTRING(@ServPermList1,
                                                              CHARINDEX(':',
                                                              @ServPermList1)
                                                              + 1,
                                                              LEN(@ServPermList1))
                                    SET @Cnt3 = @Cnt3 + 1
                                END
	
                            INSERT  INTO #Mappings13
                                    ( ID ,
                                      data
                                    )
                                    SELECT  @Cnt3 ,
                                            Data = LTRIM(RTRIM(@ServPermList1))
	
                        
                            DECLARE @perm3 VARCHAR(256)
                            DECLARE pc3 CURSOR FOR SELECT Data FROM #Mappings13
                            OPEN pc3 
                            FETCH NEXT FROM pc3 INTO @perm3
                            WHILE @@FETCH_STATUS = 0 
                                BEGIN
                        
                                    SET @sql4 = @sql4
                                        + 'EXEC sp_addsrvrolemember ' + ''''
                                        +'['+ @Login1 +']'+ ''''
                                        + +', ' + '''' + @perm3 + +''''
                                        + CHAR(13) + CHAR(10) 
                                    FETCH NEXT FROM pc3 INTO @perm3
                            
                                END
                            CLOSE pc3
                            DEALLOCATE pc3
                        
                            DROP TABLE #Mappings13           
          
                        END
                    END
                SET @sql4 = @sql4 + 'END'
            END
                         
        ELSE 
            BEGIN
                SET @sql4 = @sqlDB2
                    + 'IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname =  '
                    + '''' + @Login1 + '''' + ')' + CHAR(13) + CHAR(10)
                    + 'BEGIN ' + CHAR(13) + 'CREATE LOGIN ' + '[' + @Login1
                    + ']' + CHAR(13) + CHAR(10)
                IF @ServPermList1 IS NOT NULL 
                    BEGIN 
                        CREATE TABLE #Mappings15
                            (
                              Id INT ,
                              Data NVARCHAR(100)
                            ) 
 
                        BEGIN 
                            DECLARE @Cnt4 INT
                            SET @Cnt4 = 1

                            WHILE ( CHARINDEX(':', @ServPermList1) > 0 ) 
                                BEGIN
		
			
                                    INSERT  INTO #Mappings15
                                            ( Id ,
                                              Data 
                                            )
                                            SELECT  @Cnt4 ,
                                                    Data = LTRIM(RTRIM(SUBSTRING(@ServPermList1,
                                                              1,
                                                              CHARINDEX(':',
                                                              @ServPermList1)
                                                              - 1)))
		
                                    SET @ServPermList1 = SUBSTRING(@ServPermList1,
                                                              CHARINDEX(':',
                                                              @ServPermList1)
                                                              + 1,
                                                              LEN(@ServPermList1))
                                    SET @Cnt4 = @Cnt4 + 1
                                END
	
                            INSERT  INTO #Mappings15
                                    ( ID ,
                                      data
                                    )
                                    SELECT  @Cnt4 ,
                                            Data = LTRIM(RTRIM(@ServPermList1))
	
                        END  
                        DECLARE @perm4 VARCHAR(256)
                        DECLARE pc4 CURSOR FOR SELECT Data FROM #Mappings6
                        OPEN pc4
                        FETCH NEXT FROM pc4 INTO @perm4
                        WHILE @@FETCH_STATUS = 0 
                            BEGIN
                        
                                SET @sql4 = @sql4
                                    + 'EXEC sp_addsrvrolemember ' + ''''
                                    +'['+ @Login1 +']'+ '''' + ', ' + '''' + @perm4
                                    + '''' + CHAR(13) + CHAR(10) 
                                FETCH NEXT FROM pc4 INTO @perm4
                            
                            END
                        CLOSE pc4
                        DEALLOCATE pc4
                        
                        DROP TABLE #Mappings15
                    END 
                SET @sql = @sql + 'END'        
            END
        PRINT @sql4  
        EXEC(@sql4)
		INSERT INTO [DBAMonitor].[dbo].[SECURITYLOG] values (GETDATE(), @sql4)
         
        SET @sql4 = '' 
        FETCH NEXT FROM users_cursor1 INTO  @Server1,@Database1,@Login1,@ServPermList1,@FromWinGroup1,@User1,@Role1
   
       
    END
    
FETCH FIRST FROM users_cursor1  INTO  @Server1,@Database1,@Login1,@ServPermList1,@FromWinGroup1,@User1,@Role1
    
WHILE @@FETCH_STATUS = 0 
    BEGIN
        SET @sqlDB2 = 'USE ' + '[' + @Database1 + ']' + ' ' + CHAR(13) 
        IF @FromWinGroup1 = 1 
            SET @sql4 = @sqlDB2
                + 'IF  NOT EXISTS (SELECT * FROM sys.database_principals WHERE type = ''G'' AND name = '
                + '''' + @User1 + '''' + ')' + CHAR(13) + CHAR(10) + 'BEGIN'
                + CHAR(13) + 'CREATE USER ' + @User1 + ' FOR LOGIN ' + '['
                +  @Login1 + ']' + CHAR(13) + CHAR(10)
                + 'GRANT CONNECT TO ' + @User1 + CHAR(13) + CHAR(10)
                + 'EXEC sp_addrolemember ' + '''' + @Role1 + '''' + ',' + ''''
                + @User1 + '''' + CHAR(13) + 'END'
            
        ELSE 
            SET @sql4 = @sqlDB2
                + 'IF  NOT EXISTS (SELECT * FROM sys.database_principals WHERE type = ''S'' AND name = '
                + '''' + @User1 + '''' + ')' + CHAR(13) + CHAR(10) + 'BEGIN'
                + CHAR(13) + 'CREATE USER ' + @User1 + ' FOR LOGIN ' + '['
                + @Login1 + ']' + CHAR(13) + CHAR(10) + 'GRANT CONNECT TO '
                + @User1 + CHAR(13) + CHAR(10) + 'EXEC sp_addrolemember '
                + '''' + @Role1 + '''' + ',' + '''' + @User1 + '''' + CHAR(13)
                + 'END'
        PRINT @sql4   
        EXEC(@sql4)
		INSERT INTO [DBAMonitor].[dbo].[SEC_SECURITYLOG] values (GETDATE(), @sql4)
         
        SET @sql = '' 
        FETCH NEXT FROM users_cursor1 INTO  @Server1,@Database1,@Login1,@ServPermList1,@FromWinGroup1,@User1,@Role1
   
       
    END
    

--close cursor
CLOSE users_cursor1
DEALLOCATE users_cursor1


SELECT  *
FROM    #Mappings10
WHERE   [Server] = @@SERVERNAME
        AND IsOK IS NULL
        AND FromWinGroup = 1
        AND IsActive = 1


DROP TABLE #Mappings10
DROP TABLE #Mappings33
DROP TABLE #Mappings100
DROP TABLE #Mappings105
DROP TABLE #Mappings108



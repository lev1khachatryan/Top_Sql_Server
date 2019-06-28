SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE SecurityProblems
AS
BEGIN
SET NOCOUNT ON 
set ansi_warnings off

--Load data from file
DECLARE @sql1 VARCHAR(8000)
DECLARE @sql2 VARCHAR(256)
SET @sql2 = 'C:\SECURITYEXCEL\SIS2S093_Permissions_Mapping.csv'
DECLARE @team VARCHAR(256)
SET @team = NULL
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
	 FROM #Mappings33  where  [Database]= '*' and [Server] = @@SERVERNAME  


FETCH NEXT FROM cursor_all INTO  @alldbname
END  
CLOSE cursor_all
DEALLOCATE cursor_all 


--end cursor for '*' databases
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


--**********   work table  #Mappings10 **********--


DECLARE @collation VARCHAR(256)
SET @collation = 'SQL_Latin1_General_CP1_CI_AS'
DECLARE @servername VARCHAR(256)
SET @servername = ''
DECLARE @loginname VARCHAR(256)
SET @loginname = ''
DECLARE @servpermlist VARCHAR(512)
SET @servpermlist = ''
DECLARE @fromwingroup BIT

DECLARE @sqlDB VARCHAR(256)
SET @sqlDB = ''
DECLARE @sql VARCHAR(8000)
SET @sql = ''
DECLARE @dbname VARCHAR(256)
SET @dbname = ''

DECLARE @username1 VARCHAR(256)
SET @username1 = ''
DECLARE @rolename1 VARCHAR(256)
SET @rolename1 = ''

--Result table

CREATE TABLE #Result(ID INT IDENTITY(1,1),[Database] VARCHAR(256) NULL , [Login] VARCHAR(256) NULL ,[ServPerm] VARCHAR(256) NULL, [FromWinGroup] BIT NULL  ,[User] VARCHAR(256) NULL ,[Role] VARCHAR(256) NULL, [Description] VARCHAR(MAX) NULL)




 --1. There is a Database on Server 
 
-- Select missing databases on server

INSERT INTO #Result
        ( 
          [Database] ,
          [Description]
        )

SELECT  d2.[Database], 'Database does  not exists on server' 
FROM    ( SELECT    *
          FROM      sys.databases
        ) d1
        RIGHT 
  OUTER JOIN ( SELECT DISTINCT
                        [Server] ,
                        [Database]
               FROM     #Mappings10
               WHERE    [Server] = @@SERVERNAME
                        AND [Database] NOT IN ( '*' )
             ) d2 ON d1.name = d2.[Database]
                     OR d1.name LIKE LEFT(d2.[Database],
                                          LEN(d2.[Database]) - 1) + '%'
WHERE   d1.name IS  NULL
ORDER BY 1



--2.There is a Login on Server

-- Select missing logins on server

INSERT INTO #Result
        ( [Login] ,
          [Description]
        )

SELECT  l2.[Login], 'Login does  not exists on server'
FROM    ( SELECT    name
          FROM      master.dbo.syslogins  
        ) l1
        RIGHT OUTER JOIN ( SELECT DISTINCT
                                    [Server] ,
                                    [Login] ,
                                    [FromWinGroup]
                           FROM     #Mappings10
                           WHERE    [Server] = @@SERVERNAME 

                         ) l2 ON l1.name = CASE [FromWinGroup]
                                             WHEN 0 THEN l2.[Login]
                                             WHEN 1
                                             THEN l2.[Login]
                                           END
WHERE   l1.name IS NULL
ORDER BY 1


--3. The Login has server role permissions


-- #Temp1 -  All logins and it's permissions in Permissions_Mapping.csv

CREATE TABLE #Temp1
    (
      [Login] VARCHAR(256) NULL ,
      [Permission] VARCHAR(256) NULL ,
      [FromWinGroup] BIT NULL
    )
    

DECLARE perm_cursor CURSOR FOR
SELECT DISTINCT
[Server] ,
[Login] ,
[ServPermList] ,
[FromWinGroup]
FROM    #Mappings10
WHERE   [Server] = @@SERVERNAME
ORDER BY 1

OPEN perm_cursor

FETCH NEXT FROM perm_cursor INTO @servername,@loginname,@servpermlist,@fromwingroup

WHILE @@FETCH_STATUS = 0 
    BEGIN


        CREATE TABLE #Mappings11
            (
              Id INT ,
              Data NVARCHAR(100)
            ) 
 
                       
               
                         
        DECLARE @Cnt1 INT
        SET @Cnt1 = 1

        WHILE ( CHARINDEX(':', @servpermlist) > 0 ) 
            BEGIN
		
			
                INSERT  INTO #Mappings11
                        ( Id ,
                          Data 
                                                    
                                            
                                        
                                
                        )
                        SELECT  @Cnt1 ,
                                Data = LTRIM(RTRIM(SUBSTRING(@servpermlist, 1,
                                                             CHARINDEX(':',
                                                              @servpermlist)
                                                             - 1)))
		
                SET @servpermlist = SUBSTRING(@servpermlist,
                                              CHARINDEX(':', @servpermlist)
                                              + 1, LEN(@servpermlist))
                SET @Cnt1 = @Cnt1 + 1
            END
	
        INSERT  INTO #Mappings11
                ( ID ,
                  data
                                            
                                    
                                
                        
                )
                SELECT  @Cnt1 ,
                        Data = LTRIM(RTRIM(@servpermlist))
                                            
	
                           
        DECLARE @perm1 VARCHAR(256)
        DECLARE pc1 CURSOR FOR SELECT Data FROM #Mappings11
        OPEN pc1 
        FETCH NEXT FROM pc1 INTO @perm1
        WHILE @@FETCH_STATUS = 0 
            BEGIN
                                
                INSERT  INTO #Temp1
                        ( [Login], Permission, FromWinGroup )
                VALUES  ( @loginname, @perm1, @fromwingroup )
                                
                                                 
                                        
                FETCH NEXT FROM pc1 INTO @perm1
                            
            END
                    
        CLOSE pc1
        DEALLOCATE pc1
                
        DROP TABLE #Mappings11     
                         
           
                     
                    
        FETCH NEXT FROM perm_cursor INTO @servername,@loginname,@servpermlist,@fromwingroup
        
        
    END
    
CLOSE perm_cursor
DEALLOCATE perm_cursor
    

-- #Temp2 -  All logins and it's permissions on server


CREATE TABLE #Temp2
    (
      [Login] VARCHAR(256) NULL ,
      [Permission] VARCHAR(256) NULL ,
      [FromWinGroup] BIT NULL
    )



INSERT  INTO #Temp2
        SELECT  l3.[Login] ,
                p1.name ,
                l3.FromWinGroup
        FROM    ( SELECT    [Login] ,
                            [FromWinGroup]
                  FROM      #Temp1
                ) l3
                CROSS JOIN ( SELECT name
                             FROM   sys.server_principals
                             WHERE  type = 'R' 
                           ) p1
        WHERE   IS_SRVROLEMEMBER(p1.name,
                                 CASE l3.FromWinGroup
                                   WHEN 0 THEN l3.[Login]
                                   WHEN 1 THEN l3.[Login]
                                 END) = 1 
        ORDER BY 1
        

--SELECT  *
--FROM    #Temp1


--SELECT *
--FROM #Temp2

--SELECT  #Temp1.[Login] ,
--        #Temp1.Permission ,
--        #Temp2.[Login] ,
--        #Temp2.Permission
--FROM    #Temp1
--        FULL   OUTER JOIN #Temp2 ON #Temp1.[Login] = #Temp2.[Login]
--                                    AND #Temp1.Permission = #Temp2.Permission
--WHERE   #Temp1.[Login] IS NULL
--        OR #Temp2.[Login] IS NULL 
-- ORDER BY 1

 
 INSERT INTO #Result([Login],[ServPerm],[Description])
 SELECT  
        #Temp2.[Login] ,
        #Temp2.Permission,
        'Login has extra fixed server role on server'
FROM    #Temp1
        RIGHT   OUTER JOIN #Temp2 ON #Temp1.[Login] = #Temp2.[Login]
                                    AND #Temp1.Permission = #Temp2.Permission
WHERE   #Temp1.[Login] IS NULL
          
 ORDER BY 1
 
 
INSERT INTO #Result([Login],[ServPerm],[Description])

SELECT  #Temp1.[Login] ,
        #Temp1.[Permission],
        'Login has missing fixed server role on server'
        
FROM    #Temp1
        LEFT OUTER JOIN #Temp2 ON #Temp1.[Login] = #Temp2.[Login]
                                    AND #Temp1.Permission = #Temp2.Permission
WHERE   
      #Temp2.[Login] IS NULL AND #Temp1.[Permission] IS NOT NULL 
 ORDER BY 1
 

        
     


--3.If there is a User in Database 


 --#Temp3 -  All databases  and its' users in Permissions_Mapping.csv




CREATE TABLE #Temp3
    (
      [Database] VARCHAR(256) ,
      [User] VARCHAR(256)
    )


INSERT  INTO #Temp3
        ( [Database] ,
          [User] 
        )
        SELECT  [Database] ,
                [User]
        FROM    #Mappings10
        WHERE   [Server] = @@SERVERNAME 
                AND [Database] NOT IN ( '*' )
        ORDER BY 1
        
        
                        

--#Temp4 -  All databases  and its' users  on server


CREATE TABLE #Temp4
    (
      [Database] VARCHAR(256) ,
      [User] VARCHAR(256)
    )
    

DECLARE user_cur CURSOR
FOR SELECT  name FROM sys.databases WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb')
OPEN user_cur 
FETCH NEXT FROM user_cur INTO @dbname

WHILE @@FETCH_STATUS = 0 
    BEGIN

        SET @sqlDB = 'USE ' + QUOTENAME(@dbname) + CHAR(13)

        SET @sql = @sqlDB + 'DECLARE @username1 VARCHAR(256)' + CHAR(13)
            + 'DECLARE  user_cur_1 CURSOR' + CHAR(13)
            + 'FOR SELECT name FROM sys.database_principals WHERE (type = ''S'' OR type = ''G'' OR type = ''U'') AND name NOT IN (''dbo'', ''guest'', ''INFORMATION_SCHEMA'', ''sys'', ''TestUser'') /* AND name IN (SELECT [User] COLLATE '
            + @collation + ' FROM #Temp3) */ ORDER BY 1 ' + CHAR(13)
            + 'OPEN user_cur_1' + CHAR(13)
            + 'FETCH NEXT FROM user_cur_1 INTO @username1' + CHAR(13)
            + 'WHILE @@FETCH_STATUS = 0' + CHAR(13) + 'BEGIN' + CHAR(13)
            + 'INSERT INTO #Temp4 ( [Database], [User] )' + CHAR(13)
            + 'VALUES (' + '''' + @dbname + '''' + ', ' + '@username1' + ')'
            + CHAR(13) + 'FETCH NEXT FROM user_cur_1 INTO @username1'
            + CHAR(13) + 'END' + CHAR(13) + 'CLOSE user_cur_1' + CHAR(13)
            + 'DEALLOCATE user_cur_1' + CHAR(13)
        --PRINT ( @sql )
        EXEC (@sql)
        SET @sqlDB = ''
        SET @sql = ''
                

        FETCH NEXT FROM user_cur INTO @dbname

    END

CLOSE user_cur
DEALLOCATE user_cur

--SELECT  *
--FROM    #Temp3

--SELECT  *
--FROM    #Temp4
--ORDER BY 1

INSERT  INTO #Result
        ( [Database] ,
          [User] ,
          [Description]
        )
        SELECT  #Temp4.[Database] ,
                #Temp4.[User] ,
                'Database has extra user on server'
        FROM    #Temp3
                RIGHT  OUTER JOIN #Temp4 ON ( #Temp3.[Database] = #Temp4.[Database]
                                              OR ( #Temp4.[Database] LIKE LEFT(#Temp3.[Database],
                                                              LEN(#Temp3.[Database])
                                                              - 1) + '%'
                                                   AND RIGHT(#Temp3.[Database],
                                                             1) IN ( '*' )
                                                 )
                                            )
                                            AND #Temp3.[User] = #Temp4.[User]
        WHERE   #Temp3.[Database] IS NULL
        ORDER BY #Temp4.[Database] ,
                #Temp4.[User]


INSERT  INTO #Result
        ( [Database] ,
          [User] ,
          [Description]
        )
        SELECT  #Temp3.[Database] ,
                #Temp3.[User] ,
                'Database has missing user on server'
        FROM    #Temp3
                LEFT   OUTER JOIN #Temp4 ON ( #Temp3.[Database] = #Temp4.[Database]
                                              OR ( #Temp4.[Database] LIKE LEFT(#Temp3.[Database],
                                                              LEN(#Temp3.[Database])
                                                              - 1) + '%'
                                                   AND RIGHT(#Temp3.[Database],
                                                             1) IN ( '*' )
                                                 )
                                            )
                                            AND #Temp3.[User] = #Temp4.[User]
        WHERE   #Temp4.[Database] IS NULL
                AND #Temp3.[User] IS NOT NULL
        ORDER BY #Temp3.[Database] ,
                #Temp3.[User]
                
                
  INSERT  INTO #Result
        ( [Database] ,
          [User] ,
          [Description]
        )

  SELECT  t2.[Database] ,
                t2.[User] ,
                'Database has missing role on server'
        FROM    ( SELECT DISTINCT
                            t6.[Database] ,
                            #Temp3.[User]
                  FROM      ( SELECT DISTINCT
                                        #Temp4.[Database]
                              FROM      #Temp3
                                        INNER JOIN #Temp4 ON RIGHT(#Temp3.[Database],
                                                              1) IN ( '*' )
                                                             AND #Temp4.[Database] LIKE LEFT(#Temp3.[Database],
                                                              LEN(#Temp3.[Database])
                                                              - 1) + '_%'
                            ) t6
                            CROSS JOIN #Temp3
                  WHERE     RIGHT(#Temp3.[Database], 1) IN ( '*' )
                ) t2
                LEFT OUTER JOIN #Temp4 ON t2.[Database] = #Temp4.[Database]
                                          AND t2.[User] = #Temp4.[User]
        WHERE   #Temp4.[Database] IS NULL
        ORDER BY 1






--5.If there is a Role in Database

-- #Temp5 -  All databases  and it's roles in Permissions_Mapping.csv


CREATE TABLE #Temp5
    (
      [Database] VARCHAR(256) ,
      [Role] VARCHAR(256)
    )


INSERT  INTO #Temp5
        ( [Database] ,
          [Role] 
        )
        SELECT  [Database] ,
                [Role]
        FROM    #Mappings10
        WHERE   [Server] = @@SERVERNAME 
                AND [Database] NOT IN ( '*' )
        ORDER BY 1
                
   
    
    
-- #Temp6 -  All databases  and it's roles in on server
       

CREATE TABLE #Temp6
    (
      [Database] VARCHAR(256) ,
      [Role] VARCHAR(256)
    )
    
 

DECLARE role_cur CURSOR
FOR SELECT  name FROM sys.databases WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb') ORDER BY 1
OPEN role_cur 
FETCH NEXT FROM role_cur INTO @dbname

WHILE @@FETCH_STATUS = 0 
    BEGIN

        SET @sqlDB = 'USE ' + QUOTENAME(@dbname) + CHAR(13)

        SET @sql = @sqlDB + 'DECLARE @rolename1 VARCHAR(256)' + CHAR(13)
            + 'DECLARE  role_cur_1 CURSOR' + CHAR(13)
            + 'FOR SELECT name FROM sys.database_principals WHERE type = ''R'' AND name NOT IN (''public'') /* AND name  IN (SELECT [Role] COLLATE '
            + @collation
            + ' FROM #Temp5) */  ORDER BY 1  '
            + CHAR(13) + 'OPEN role_cur_1' + CHAR(13)
            + 'FETCH NEXT FROM role_cur_1 INTO @rolename1' + CHAR(13)
            + 'WHILE @@FETCH_STATUS = 0' + CHAR(13) + 'BEGIN' + CHAR(13)
            + 'INSERT INTO #Temp6 ( [Database], [Role] )' + CHAR(13)
            + 'VALUES (' + '''' + @dbname + '''' + ', ' + '@rolename1' + ')'
            + CHAR(13) + 'FETCH NEXT FROM role_cur_1 INTO @rolename1'
            + CHAR(13) + 'END' + CHAR(13) + 'CLOSE role_cur_1' + CHAR(13)
            + 'DEALLOCATE role_cur_1' + CHAR(13)
        --PRINT ( @sql )
        EXEC (@sql)
        SET @sqlDB = ''
        SET @sql = ''
                

        FETCH NEXT FROM role_cur INTO @dbname

    END

CLOSE role_cur
DEALLOCATE role_cur
 
--SELECT  *
--FROM    #Temp5

--SELECT  *
--FROM    #Temp6


INSERT  INTO #Result
        ( [Database] ,
          [Role] ,
          [Description]
        )
        SELECT  #Temp6.[Database] ,
               #Temp6.[Role] ,
                'Database has extra role on server'
        FROM     #Temp5
                RIGHT  OUTER JOIN #Temp6 ON ( #Temp5.[Database] = #Temp6.[Database]
                                              OR ( #Temp6.[Database] LIKE LEFT(#Temp5.[Database],
                                                              LEN(#Temp5.[Database])
                                                              - 1) + '_%'
                                                   AND RIGHT(#Temp5.[Database],
                                                             1) IN ( '*' )
                                                 )
                                            )
                                            AND #Temp5.[Role] = #Temp6.[Role]
        WHERE   #Temp5.[Database] IS NULL and #Temp5.[Role]!='sis_public'
        ORDER BY #Temp6.[Database] ,
                #Temp6.[Role]


INSERT  INTO #Result
        ( [Database] ,
          [Role] ,
          [Description]
        )
        SELECT  #Temp5.[Database] ,
                #Temp5.[Role] ,
                'Database has missing role on server'
        FROM    #Temp5
                LEFT OUTER JOIN #Temp6 ON ( #Temp5.[Database] = #Temp6.[Database]
                                            OR ( #Temp6.[Database] LIKE LEFT(#Temp5.[Database],
                                                              LEN(#Temp5.[Database])
                                                              - 1) + '_%'
                                                 AND RIGHT(#Temp5.[Database],
                                                           1) IN ( '*' )
                                               )
                                          )
                                          AND #Temp5.[Role] = #Temp6.[Role]
        WHERE   #Temp6.[Database] IS NULL
                AND #Temp5.[Role] IS NOT NULL
        ORDER BY #Temp5.[Database] ,
                #Temp5.[Role]


INSERT  INTO #Result
        ( [Database] ,
          [Role] ,
          [Description]
        )
        SELECT  t2.[Database] ,
                t2.[Role] ,
                'Database has missing role on server'
        FROM    ( SELECT DISTINCT
                            t6.[Database] ,
                            #Temp5.[Role]
                  FROM      ( SELECT DISTINCT
                                        #Temp6.[Database]
                              FROM      #Temp5
                                        INNER JOIN #Temp6 ON RIGHT(#Temp5.[Database],
                                                              1) IN ( '*' )
                                                             AND #Temp6.[Database] LIKE LEFT(#Temp5.[Database],
                                                              LEN(#Temp5.[Database])
                                                              - 1) + '_%'
                            ) t6
                            CROSS JOIN #Temp5
                  WHERE     RIGHT(#Temp5.[Database], 1) IN ( '*' )
                ) t2
                LEFT OUTER JOIN #Temp6 ON t2.[Database] = #Temp6.[Database]
                                          AND t2.[Role] = #Temp6.[Role]
        WHERE   #Temp6.[Database] IS NULL
        ORDER BY 1
                                                            
   
--6.User is a member of Role

-- #Temp7 - All databases,users and it's  roles in Permissions_Mapping.csv

CREATE TABLE #Temp7
    (
      [Database] VARCHAR(256) ,
      [User] VARCHAR(256) ,
      [Role] VARCHAR(256)
    )
      
      
INSERT  INTO #Temp7
        ( [Database] ,
          [User] ,
          [Role] 
        )
        SELECT  [Database] ,
                [User] ,
                [Role]
        FROM    #Mappings10
        WHERE   [Server] = @@SERVERNAME
                AND [Database] NOT IN ( '*' ) 
        ORDER BY 1
     



-- #Temp8 - Databases, users  and it's  roles on server 

CREATE TABLE #Temp8
    (
      [Database] VARCHAR(256) ,
      [User] VARCHAR(256) ,
      [Role] VARCHAR(256)
    )
  
  

   
DECLARE  db_user_role_cur CURSOR FOR  
    
SELECT #Temp4.[Database],#Temp4.[User],#Temp6.[Role]
FROM #Temp4 INNER JOIN #Temp6 ON #Temp4.[Database] = #Temp6.[Database]
   
OPEN db_user_role_cur
FETCH NEXT FROM db_user_role_cur INTO   @dbname,@username1,@rolename1

WHILE @@FETCH_STATUS = 0 
    BEGIN

        SET @sqlDB = 'USE ' + QUOTENAME(@dbname) + CHAR(13)
        SET @sql = @sqlDB
            + 'CREATE TABLE #TempUser1 ([UserName] SYSNAME NULL ,[RoleName] SYSNAME NULL ,[LoginName] SYSNAME NULL ,[DefDBName] SYSNAME NULL ,[DefSchemaName] SYSNAME NULL ,[UserID] SMALLINT , [SID] SMALLINT)'
            + CHAR(13)
            + 'IF EXISTS (SELECT * FROM sys.database_principals WHERE (type = ''S'' OR type = ''G'' OR type = ''U'') AND name IN ('
            + '''' + @username1 + '''' + ')' + ')' + CHAR(13) + 'BEGIN'
            + CHAR(13)
            + 'INSERT  INTO #TempUser1( [UserName], [RoleName], [LoginName], [DefDBName], [DefSchemaName], [UserID], [SID] ) '
            + CHAR(13) + 'EXEC sys.sp_helpuser @name_in_db = ' + ''''
            + @username1 + '''' + CHAR(13) + 'IF ' + '''' + @rolename1 + ''''
            + ' IN (SELECT [RoleName] FROM #TempUser1) ' + CHAR(13)
            + 'INSERT INTO #Temp8 ( [Database], [User], [Role] )' + CHAR(13)
            + ' VALUES (' + '''' + @dbname + '''' + ', ' + '''' + @username1
            + '''' + ', ' + '''' + @rolename1 + '''' + ')' + CHAR(13) + 'END'
            + CHAR(13) + 'DROP TABLE #TempUser1 '

        PRINT ( @sql )
        EXEC  ( @sql )
        SET @sqlDB = ''
        SET @sql = ''

        FETCH NEXT FROM db_user_role_cur INTO   @dbname,@username1,@rolename1

    END

CLOSE db_user_role_cur
DEALLOCATE db_user_role_cur

--SELECT  *
--FROM    #Temp7


--SELECT  *
--FROM    #Temp8


INSERT  INTO #Result
        ( [Database] ,
          [User] ,
          [Role] ,
          [Description]
        )
        SELECT  #Temp8.[Database] ,
                #Temp8.[User] ,
                #Temp8.[Role] ,
                'User has    extra  membership  of  role on server'
        FROM    #Temp7
                RIGHT  OUTER JOIN #Temp8
				 ON 
				 ( #Temp7.[Database] = #Temp8.[Database]
                                              OR ( #Temp8.[Database] LIKE LEFT(#Temp7.[Database],
                                                              LEN(#Temp7.[Database])
                                                              - 1) + '_%'
                                                   AND RIGHT(#Temp7.[Database],
                                                             1) IN ( '*' )
                                                 )
                                            )
                                            AND #Temp7.[User] = #Temp8.[User]
        WHERE   #Temp7.[Role]!=  #Temp8.[Role] OR	#Temp7.[Database] IS NULL

INSERT  INTO #Result
        ( [Database] ,
          [User] ,
          [Role] ,
          [Description]
        )
        SELECT  #Temp7.[Database] ,
                #Temp7.[User] ,
                #Temp7.[Role] ,
                'User has missing membership  of  role on server'
        FROM    #Temp7
                LEFT   OUTER JOIN #Temp8 ON ( #Temp7.[Database] = #Temp8.[Database]
                                              OR ( #Temp8.[Database] LIKE LEFT(#Temp7.[Database],
                                                              LEN(#Temp7.[Database])
                                                              - 1) + '_%'
                                                   AND RIGHT(#Temp7.[Database],
                                                             1) IN ( '*' )
                                                 )
                                            )
                                            AND #Temp7.[User] = #Temp8.[User]
        WHERE   #Temp8.[Database] IS NULL
                AND #Temp7.[User] IS NOT NULL  
				          

INSERT  INTO #Result
        ( [Database] ,
          [User] ,
          [Role] ,
          [Description]
        )
        SELECT  t2.[Database] ,
                t2.[User] ,
                t2.[Role] ,
                'User has missing membership of  role on server'
        FROM    ( SELECT DISTINCT
                            t6.[Database] ,
                            #Temp7.[User] ,
                            #Temp7.[Role]
                  FROM      ( SELECT DISTINCT
                                        #Temp8.[Database]
                              FROM      #Temp7
                                        INNER JOIN #Temp8 ON RIGHT(#Temp7.[Database],
                                                              1) IN ( '*' )
                                                             AND #Temp8.[Database] LIKE LEFT(#Temp7.[Database],
                                                              LEN(#Temp7.[Database])
                                                              - 1) + '_%'
                            ) t6
                            CROSS JOIN #Temp7
                  WHERE     RIGHT(#Temp7.[Database], 1) IN ( '*' )
                ) t2
                LEFT OUTER JOIN #Temp8 ON t2.[Database] = #Temp8.[Database]
                                          AND t2.[User] = #Temp8.[User]
                                          AND t2.[Role] = #Temp8.[Role]
        WHERE   #Temp8.[Database] IS NULL 
                            


--9. User based on Login

--  #Temp9 - Databases,Logins and related Users in Permissions_Mapping.csv
 
CREATE TABLE #Temp9
    (
      [Database] VARCHAR(256) ,
      [Login] VARCHAR(256) ,
      [FromWinGroup] BIT ,
      [User] VARCHAR(256)
    )
      
INSERT  INTO #Temp9
        ( [Database] ,
          [Login] ,
          FromWinGroup ,
          [User]
         
        )
        SELECT  [Database] ,
                [Login] ,
                [FromWinGroup] ,
                [User]
        FROM    #Mappings10
        WHERE   [Server] = @@SERVERNAME 
                AND [Database] NOT IN ( '*' )
        ORDER BY 1
                



--  #Temp10 - Databases,Logins and related Users on server for databases  in  Permissions_Mapping.csv


CREATE TABLE #Temp10
    (
      [Database] VARCHAR(256) ,
      [Login] VARCHAR(256) ,
      [User] VARCHAR(256)
    )
    
    
DECLARE  db_user_login_cur CURSOR FOR  
    
SELECT sd.name ,
t9.[Login] ,
t9.[FromWinGroup],
t9.[User] 
FROM #Temp9 t9 INNER JOIN (SELECT name FROM sys.databases ) sd  ON t9.[Database] = sd.name   OR sd.name LIKE LEFT(t9.[Database],
LEN(t9.[Database]) - 1) + '%' AND RIGHT(t9.[Database],1) IN ('*')
ORDER BY 1
   
OPEN db_user_login_cur
FETCH NEXT FROM db_user_login_cur INTO   @dbname,@loginname,@fromwingroup,@username1

WHILE @@FETCH_STATUS = 0 
    BEGIN
        
        SET @sqlDB = 'USE ' + QUOTENAME(@dbname) + CHAR(13)
        SET @sql = @sqlDB + 'DECLARE @db_user_login_cur_3_var VARCHAR(256)  '
            + CHAR(13)
            + 'DECLARE db_user_login_cur_3 CURSOR FOR  SELECT name FROM sys.database_principals WHERE (type = ''S'' OR type = ''G'' OR type = ''U'') AND name NOT IN (''dbo'', ''guest'', ''INFORMATION_SCHEMA'', ''sys'', ''TestUser'')'
            + CHAR(13) + 'OPEN db_user_login_cur_3 ' + CHAR(13)
            + 'FETCH NEXT FROM db_user_login_cur_3 INTO @db_user_login_cur_3_var '
            + CHAR(13) + 'WHILE @@FETCH_STATUS = 0' + CHAR(13) + 'BEGIN'
            + CHAR(13) + 'DECLARE @var VARCHAR(256)' + CHAR(13)
            + 'CREATE TABLE #TempUser1 ([UserName] SYSNAME NULL ,[RoleName] SYSNAME NULL ,[LoginName] SYSNAME NULL ,[DefDBName] SYSNAME NULL ,[DefSchemaName] SYSNAME NULL ,[UserID] SMALLINT , [SID] SMALLINT)'
            + 'INSERT  INTO #TempUser1( [UserName], [RoleName], [LoginName], [DefDBName], [DefSchemaName], [UserID], [SID] ) '
            + CHAR(13)
            + 'EXEC sys.sp_helpuser @name_in_db = @db_user_login_cur_3_var '
            + CHAR(13)
            + ' SET @var = ( SELECT  MAX([LoginName]) FROM    #TempUser1 )'
            + CHAR(13) + 'INSERT INTO #Temp10 ( [Database], [Login], [User] )'
            + CHAR(13) + ' VALUES (' + '''' + @dbname + '''' + ', ' + '@var'
            + ',' + '@db_user_login_cur_3_var' + ')' + CHAR(13)
            + 'DROP TABLE #TempUser1 ' + CHAR(13)
            + 'FETCH NEXT FROM db_user_login_cur_3 INTO @db_user_login_cur_3_var'
            + CHAR(13) + 'END' + CHAR(13) + 'CLOSE db_user_login_cur_3  '
            + CHAR(13) + 'DEALLOCATE db_user_login_cur_3 ' + CHAR(13)

        --PRINT ( @sql )
        EXEC  ( @sql )
        SET @sqlDB = ''
        SET @sql = ''

        FETCH NEXT FROM db_user_login_cur INTO @dbname,@loginname,@fromwingroup,@username1

    END

CLOSE db_user_login_cur
DEALLOCATE db_user_login_cur  
    



    
--  #Temp11 - Databases,Logins and related Users on server for databases not  in  Permissions_Mapping.csv


CREATE TABLE #Temp11
    (
      [Database] VARCHAR(256) ,
      [Login] VARCHAR(256) ,
      [User] VARCHAR(256)
    )


DECLARE  db_user_login_cur_1 CURSOR FOR  
SELECT  name
FROM    sys.databases
WHERE name NOT IN ('master','model','msdb','tempdb')   
AND
name NOT IN (
SELECT  sd.name
FROM    #Temp9 t9
INNER JOIN ( SELECT name
FROM   sys.databases
) sd ON t9.[Database] = sd.name
OR sd.name LIKE LEFT(t9.[Database],
LEN(t9.[Database]) - 1)
+ '%'
AND RIGHT(t9.[Database], 1) IN ( '*' )
)
ORDER BY 1

   
OPEN db_user_login_cur_1
FETCH NEXT FROM db_user_login_cur_1 INTO   @dbname

WHILE @@FETCH_STATUS = 0 
    BEGIN
        
        SET @sqlDB = 'USE ' + QUOTENAME(@dbname) + CHAR(13)
        SET @sql = @sqlDB + 'DECLARE @db_user_login_cur_2_var VARCHAR(256)  '
            + CHAR(13)
            + 'DECLARE db_user_login_cur_2 CURSOR FOR  SELECT name FROM sys.database_principals WHERE (type = ''S'' OR type = ''G'' OR type = ''U'') AND name NOT IN (''dbo'', ''guest'', ''INFORMATION_SCHEMA'', ''sys'', ''TestUser'')'
            + CHAR(13) + 'OPEN db_user_login_cur_2 ' + CHAR(13)
            + 'FETCH NEXT FROM db_user_login_cur_2 INTO @db_user_login_cur_2_var '
            + CHAR(13) + 'WHILE @@FETCH_STATUS = 0' + CHAR(13) + 'BEGIN'
            + CHAR(13) + 'DECLARE @var VARCHAR(256)' + CHAR(13)
            + 'CREATE TABLE #TempUser1 ([UserName] SYSNAME NULL ,[RoleName] SYSNAME NULL ,[LoginName] SYSNAME NULL ,[DefDBName] SYSNAME NULL ,[DefSchemaName] SYSNAME NULL ,[UserID] SMALLINT , [SID] SMALLINT)'
            + 'INSERT  INTO #TempUser1( [UserName], [RoleName], [LoginName], [DefDBName], [DefSchemaName], [UserID], [SID] ) '
            + CHAR(13)
            + 'EXEC sys.sp_helpuser @name_in_db = @db_user_login_cur_2_var '
            + CHAR(13)
            + ' SET @var = ( SELECT  MAX([LoginName]) FROM    #TempUser1)'
            + CHAR(13) + 'INSERT INTO #Temp11 ( [Database], [Login], [User] )'
            + CHAR(13) + ' VALUES (' + '''' + @dbname + '''' + ', ' + '@var'
            + ',' + '@db_user_login_cur_2_var' + ')' + CHAR(13)
            + 'DROP TABLE #TempUser1 ' + CHAR(13)
            + 'FETCH NEXT FROM db_user_login_cur_2 INTO @db_user_login_cur_2_var'
            + CHAR(13) + 'END' + CHAR(13) + 'CLOSE db_user_login_cur_2  '
            + CHAR(13) + 'DEALLOCATE db_user_login_cur_2 ' + CHAR(13)
            

        --PRINT ( @sql )
        EXEC  ( @sql )
        SET @sqlDB = ''
        SET @sql = ''

        FETCH NEXT FROM db_user_login_cur_1 INTO @dbname

    END

CLOSE db_user_login_cur_1
DEALLOCATE db_user_login_cur_1 



--SELECT  *
--FROM    #Temp9

--SELECT  *
--FROM    #Temp10


--SELECT  *
--FROM    #Temp11


INSERT  INTO #Result
        ( [Database] ,
          [Login] ,
          [User],
          [Description]
        )
        SELECT DISTINCT
                #Temp10.[Database] ,
                #Temp10.[Login] ,
                #Temp10.[User] ,
                'User based on extra login on server  '
        FROM    #Temp9
                RIGHT  OUTER JOIN #Temp10 ON ( #Temp9.[Database] = #Temp10.[Database]
                                               OR ( #Temp10.[Database] LIKE LEFT(#Temp9.[Database],
                                                              LEN(#Temp9.[Database])
                                                              - 1) + '_%'
                                                    AND RIGHT(#Temp9.[Database],
                                                              1) IN ( '*' )
                                                  )
                                             )
                                             AND #Temp9.[User] = #Temp10.[User]
                                             AND #Temp10.[Login] = CASE #Temp9.[FromWinGroup]
                                                              WHEN 0
                                                              THEN #Temp9.[Login]
                                                              WHEN 1
                                                              THEN #Temp9.[Login]
                                                              END
        WHERE   #Temp9.[Database] IS NULL


INSERT  INTO #Result
        ( [Database] ,
          [Login] ,
          [FromWinGroup] ,
          [User],
          [Description]
        )
        SELECT DISTINCT
                #Temp9.[Database] ,
                #Temp9.[Login] ,
                #Temp9.[FromWinGroup] ,
                #Temp9.[User] ,
                'User based on missing login on server  '
        FROM    #Temp9
                LEFT   OUTER JOIN #Temp10 ON ( #Temp9.[Database] = #Temp10.[Database]
                                               OR ( #Temp10.[Database] LIKE LEFT(#Temp9.[Database],
                                                              LEN(#Temp9.[Database])
                                                              - 1) + '_%'
                                                    AND RIGHT(#Temp9.[Database],
                                                              1) IN ( '*' )
                                                  )
                                             )
                                             AND #Temp9.[User] = #Temp10.[User]
                                             AND #Temp10.[Login] = CASE #Temp9.[FromWinGroup]
                                                              WHEN 0
                                                              THEN #Temp9.[Login]
                                                              WHEN 1
                                                              THEN  #Temp9.[Login]
                                                              END
        WHERE   #Temp10.[Database] IS NULL




 
INSERT  INTO #Result
        ( [Database] ,
          [Login] ,
          [FromWinGroup] ,
          [User] ,
          [Description]
        )
        SELECT  t2.[Database] ,
                t2.[Login] ,
                t2.[FromWinGroup] ,
                t2.[User] ,
                'User based on missing login on server  '
        FROM    ( SELECT DISTINCT
                            t6.[Database] ,
                            #Temp9.[Login] ,
                            #Temp9.[FromWinGroup] ,
                            #Temp9.[User]
                  FROM      ( SELECT DISTINCT
                                        #Temp10.[Database]
                              FROM      #Temp9
                                        INNER JOIN #Temp10 ON RIGHT(#Temp9.[Database],
                                                              1) IN ( '*' )
                                                              AND #Temp10.[Database] LIKE LEFT(#Temp9.[Database],
                                                              LEN(#Temp9.[Database])
                                                              - 1) + '_%'
                            ) t6
                            CROSS JOIN #Temp9
                  WHERE     RIGHT(#Temp9.[Database], 1) IN ( '*' )
                ) t2
                FULL OUTER JOIN #Temp10 ON t2.[Database] = #Temp10.[Database]
                                           AND t2.[User] = #Temp10.[User]
                                           AND #Temp10.[Login] = CASE t2.[FromWinGroup]
                                                              WHEN 0
                                                              THEN t2.[Login]
                                                              WHEN 1
                                                              THEN  t2.[Login]
                                                              END
        WHERE   #Temp10.[Database] IS NULL      
        


   INSERT   INTO #Result
            ( [Database] ,
              [Login] ,
              [User] ,
              [Description]
            )
            SELECT DISTINCT   * ,
                    'Login is based on user in database outside of mapping '
            FROM    #Temp11
            WHERE   [Login]  IN ( SELECT DISTINCT
                                        [Login]
                                 FROM   #Mappings10
                                 WHERE  [Server] = @@SERVERNAME 
                                        AND [Database] NOT IN ( '*' ) )  AND  [Login] NOT IN ( SELECT DISTINCT
                                        [Login]
                                 FROM   #Mappings10
                                 WHERE  [Server] = @@SERVERNAME 
                                        AND [Database] NOT IN ( '*' ) )                    


SELECT *
FROM #Result

DROP TABLE #Temp1
DROP TABLE #Temp2 
DROP TABLE #Temp3 
DROP TABLE #Temp4 
DROP TABLE #Temp5
DROP TABLE #Temp6  
DROP TABLE #Temp7
DROP TABLE #Temp8
DROP TABLE #Temp9
DROP TABLE #Temp10
DROP TABLE #Temp11
DROP TABLE #Result
     
DROP TABLE #Mappings100
DROP TABLE #Mappings33
DROP TABLE #Mappings105
DROP TABLE #Mappings15
DROP TABLE #Mappings10
 

 
END
GO

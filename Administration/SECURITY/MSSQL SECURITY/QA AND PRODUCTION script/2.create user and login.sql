
-- OBJECT NAME: create user

-- INPUTS: @newdatabase  - source database
--         @userlogin - created user name
--		   @jobperm - job permission (Y / N)

/*
 DESCRIPTION: This script create user  with minimum privileges SELECT, INSERT, UPDATE, EXECUTE 
 for  login with  same name as username (and create if it dose not exists) . 
 	Additionally 
	- give job execute permission if @jobperm is 'Y' (editing)
	- give ALTER TABLE [IndicatorProgressValue] permission if  database start with Philippines%
	- give permission on database [ReportCache] by sis_ddladmin role( db_owner  and db_backupoperator)
*/


DECLARE @newdatabase VARCHAR(256);
SET @newdatabase =''
DECLARE @userlogin VARCHAR(256);
SET @userlogin=''
DECLARE @jobperm VARCHAR(256);
SET @jobperm='N'--(Y\N)


DECLARE @sql VARCHAR(5000);

DECLARE @sql1 VARCHAR(5000);

-- create login, user and role

BEGIN

SET @sql =    'USE [master];' + CHAR(13) + 'IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname =  '
            + '''' + @userlogin + '''' + ')' + CHAR(13)                    
		    +  CHAR(10) + 'BEGIN ' + CHAR(13) + 'BEGIN TRY'+ CHAR(13) +'USE [master];' + CHAR(13) 
			+ 'CREATE LOGIN ' + '[' + @userlogin + '] WITH PASSWORD=N''' + @userlogin 
			+ ''', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF' +  CHAR(13) 
			+ 'PRINT ''The login ['+ @userlogin + '] has been created  on database ['+ @newdatabase +'] ''' + CHAR(13) 
			+ 'END TRY'+ CHAR(13)+ 'BEGIN CATCH' + CHAR(13)+ 'SELECT ERROR_MESSAGE() AS ErrorMessage;'
			+  CHAR(13) +'END CATCH'+ CHAR(13)+ 'END' + CHAR(13)
			+ 'ELSE PRINT ''The login ['+ @userlogin + '] already exists on database ['+ @newdatabase +'] '''+ CHAR(13)
			+ 'USE ' + '[' + @newdatabase + ']' + CHAR(13) 
			+ 'IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = ''sis_public'' AND type = ''R'')' + CHAR(13)
			+ 'BEGIN' + CHAR(13) + 'BEGIN TRY'+  CHAR(13) + CHAR(10)+ 'USE ' + '[' + @newdatabase + ']' + CHAR(13)  
			+ 'CREATE ROLE [sis_public] AUTHORIZATION  [dbo]'+ CHAR(13) + 'BEGIN'
            + CHAR(13) + CHAR(10) + 'GRANT DELETE TO  [sis_public]'
            + CHAR(13) + CHAR(10) + 'GRANT EXECUTE TO [sis_public]'
            + CHAR(13) + CHAR(10) + 'GRANT INSERT TO [sis_public]'
            + CHAR(13) + CHAR(10) + 'GRANT SELECT TO [sis_public]'
            + CHAR(13) + CHAR(10) + 'GRANT UPDATE TO [sis_public]'
			+ CHAR(13) + CHAR(10) + 'END' + CHAR(13) 
			+ CHAR(13) + 'PRINT ''The rlole [sis_public] has been created on database ['+ @newdatabase +'] '''+ CHAR(13)+'END TRY'
			+ CHAR(13)+ 'BEGIN CATCH' + CHAR(13)+ 'SELECT ERROR_MESSAGE() AS ErrorMessage;'
			+ CHAR(13) +'END CATCH'+ CHAR(13)+ 'END ' + CHAR(13) 
			+ 'ELSE PRINT ''The role [sis_public] already exists on database ['+ @newdatabase +'] '''+ CHAR(13)
			+ 'USE ' + '[' + @newdatabase + ']' + CHAR(13)
			+ 'IF  NOT EXISTS (SELECT * FROM sys.database_principals WHERE (type = ''G'' OR type = ''U'' OR type = ''S'') AND name = '
			+ '''' +  @userlogin + '''' + ')' + CHAR(13) + CHAR(10) + 'BEGIN'+ CHAR(13) + 'BEGIN TRY'+ CHAR(13) + 'USE ' + '[' + @newdatabase + ']' + CHAR(13) 
			+ 'CREATE USER ' + '[' + @userlogin +']' + ' FOR LOGIN ' + '[' + @userlogin + ']' + ' WITH DEFAULT_SCHEMA=[dbo] '
			+ CHAR(13) + ' EXEC sp_addrolemember N''sis_public'', '+ '['+ @userlogin +']'+ CHAR(13) +
			+ 'PRINT ''The user ['+ @userlogin + '] has been created on database ['+ @newdatabase +'] '''+ CHAR(13) 
			+ 'END TRY'+ CHAR(13)+ 'BEGIN CATCH' + CHAR(13)+ 'SELECT ERROR_MESSAGE() AS ErrorMessage;'
			+ CHAR(13) +'END CATCH'+ CHAR(13)+'END'+ CHAR(13)
			+ 'ELSE PRINT ''The user ' + @userlogin + ' already exists on database ['+ @newdatabase +'] ''' +CHAR(13)

-- add user on ReportCache database  by db_owner permission 

			+ 'USE [ReportCache]' + CHAR(13)
			+ 'IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = ''sis_ddladmin'' AND type = ''R'')' + CHAR(13)
			+ 'BEGIN' + CHAR(13) + 'BEGIN TRY'+  CHAR(13) + CHAR(10)+ 'USE [ReportCache]' + CHAR(13)  		
			+ 'CREATE ROLE [sis_ddladmin] AUTHORIZATION  [dbo]'+ CHAR(13) + 'BEGIN'
            + CHAR(13) + CHAR(10) + 'GRANT DELETE TO  [sis_ddladmin]'
            + CHAR(13) + CHAR(10) + 'GRANT EXECUTE TO [sis_ddladmin]'
            + CHAR(13) + CHAR(10) + 'GRANT INSERT TO [sis_ddladmin]'
            + CHAR(13) + CHAR(10) + 'GRANT SELECT TO [sis_ddladmin]'
            + CHAR(13) + CHAR(10) + 'GRANT UPDATE TO [sis_ddladmin]'
			+ 'GRANT VIEW DEFINITION TO [sis_ddladmin] ' + CHAR(13)
			+ 'EXEC sp_addrolemember N''db_owner'', N''sis_ddladmin ''' + CHAR(13)
            + 'EXEC sp_addrolemember N''db_backupoperator'', N''sis_ddladmin''' + CHAR(13)
			+ 'END' + CHAR(13)
			+ CHAR(13) + 'PRINT ''The rlole [sis_ddlrole] has been created on database [ReportCache] '''+ CHAR(13)+'END TRY'
			+ CHAR(13)+ 'BEGIN CATCH' + CHAR(13)+ 'SELECT ERROR_MESSAGE() AS ErrorMessage;'
			+ CHAR(13) +'END CATCH'+ CHAR(13)+ 'END ' + CHAR(13) 
			+ 'ELSE PRINT ''The role [sis_ddladmin] already exists on [ReportCache] '''+ CHAR(13)
			+ 'USE [ReportCache]' + CHAR(13)
			+'IF  NOT EXISTS (SELECT * FROM sys.database_principals WHERE (type = ''G'' OR type = ''U'' OR type = ''S'') AND name = '
			+ '''' +  @userlogin + '''' + ')' + CHAR(13) + CHAR(10) + 'BEGIN'+ CHAR(13) + 'BEGIN TRY'+ CHAR(13) + 'USE ' + '[ReportCache]' + CHAR(13) 
			+ 'CREATE USER ' + '[' + @userlogin +']' + ' FOR LOGIN ' + '[' + @userlogin + ']' + ' WITH DEFAULT_SCHEMA=[dbo] '
			+ CHAR(13) + ' EXEC sp_addrolemember N''sis_ddladmin'', '+ '['+ @userlogin +']'+ CHAR(13) +
			+ 'PRINT ''The user ['+ @userlogin + '] has been created on database [ReportCache] '''+ CHAR(13) 
			+ 'END TRY'+ CHAR(13)+ 'BEGIN CATCH' + CHAR(13)+ 'SELECT ERROR_MESSAGE() AS ErrorMessage;'
			+ CHAR(13) +'END CATCH'+ CHAR(13)+'END'+ CHAR(13)
			+ 'ELSE PRINT ''The user [' + @userlogin + '] already exists on [ReportCache]''' +CHAR(13)
			

-- addition for Philippines project 

			+ 'IF (LEFT( '''+ @newdatabase +''' , 11)=''Philippines'')'+ CHAR(13)
			+ 'BEGIN'+ CHAR(13)
			+ 'USE ' + '[' + @newdatabase + ']' + CHAR(13) 
			+ 'IF  EXISTS (SELECT name FROM sys.Tables where name=''IndicatorProgressValue'' )' + CHAR(13)	
			+ 'BEGIN'+ CHAR(13)	   
			+ 'USE ' + '[' + @newdatabase + ']' + CHAR(13) 
			+ 'GRANT ALTER ON [dbo].[IndicatorProgressValue] TO ['+ @userlogin +']'+ CHAR(13)
			+ 'PRINT ''The user ['+ @userlogin + '] has been granted to ALTER TABLE [IndicatorProgressValue] '''+ CHAR(13) 
			+ 'END'+ CHAR(13) +'END'

			--PRINT(@sql)
			EXEC(@sql)
								 
END

-- job permission

IF @jobperm = 'Y'
BEGIN
SET @sql1 =   'USE [msdb];'+ CHAR(13) 
			+ 'IF  NOT EXISTS (SELECT * FROM sys.database_principals WHERE (type = ''G'' OR type = ''U'' OR type = ''S'') AND name = '
			+ '''' +  @userlogin + '''' + ')' + CHAR(13) + CHAR(10) + 'BEGIN' + CHAR(13) + 'BEGIN TRY' + CHAR(13)+
			+ 'USE [msdb];' + CHAR(13) + 'CREATE USER [' + @userlogin + '] FOR LOGIN [' + @userlogin +']'+ CHAR(13)
			+  CHAR(13) + 'EXEC sp_addrolemember N''SQLAgentOperatorRole'', N'''+ @userlogin +''''+ CHAR(13)	
			+ 'PRINT ''The user ['+ @userlogin + '] has been created on database [msdb] '+''''+ CHAR(13)
			+ 'END TRY'+ CHAR(13)+ 'BEGIN CATCH' + CHAR(13)+ 'SELECT ERROR_MESSAGE() AS ErrorMessage;'
			+  CHAR(13) +'END CATCH'+ CHAR(13)+ 'END'+ CHAR(13)
			+ 'IF (select @@VERSION) like ''Microsoft SQL Server 2005%''' + CHAR(13) + 'BEGIN' + CHAR(13)
			+ 'USE [master];' + CHAR(13) +'IF  NOT EXISTS (SELECT * FROM sys.database_principals WHERE (type = ''G'' OR type = ''U'' OR type = ''S'') AND name = '
			+ '''' +  @userlogin + '''' + ')' + CHAR(13) + CHAR(10) + 'BEGIN' + CHAR(13) + 'BEGIN TRY'+ CHAR(13)
			+ 'USE [master];' + CHAR(13)+ 'CREATE USER ' + @userlogin +' FOR LOGIN ' +@userlogin 
			+ ' WITH DEFAULT_SCHEMA=[dbo]' + CHAR(13)+ 'GRANT EXECUTE ON xp_sqlagent_enum_jobs TO ['+ @userlogin +']'+ CHAR(13) 
			+ 'PRINT ''The user ['+ @userlogin + '] has been created on database [master] '+''''+ CHAR(13) 
			+ 'END TRY'+ CHAR(13)+ 'BEGIN CATCH' + CHAR(13)+ 'SELECT ERROR_MESSAGE() AS ErrorMessage;'
			+ CHAR(13) +'END CATCH'+ CHAR(13) +  'END'+ CHAR(13)+'END'+ CHAR(13)
			

		--PRINT ( @sql1 )
		EXEC ( @sql1 )

 END
 GO
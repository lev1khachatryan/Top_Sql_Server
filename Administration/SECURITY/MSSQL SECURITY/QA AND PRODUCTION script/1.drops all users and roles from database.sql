
-- OBJECT NAME: drops all users and roles from database

-- INPUTS: @newdatabase  - source database

-- DESCRIPTION: This script drops all users and roles from database  



DECLARE @newdatabase VARCHAR(256);
	SET @newdatabase =''

DECLARE @userexceptionlist VARCHAR(2000);
SET @userexceptionlist='''dbo'',
						''guest'', 
						''INFORMATION_SCHEMA'', 
						''sys'''
DECLARE @roleexceptionlist VARCHAR(2000);
SET @roleexceptionlist='''public'', 
						''db_owner'', 
						''db_accessadmin'', 
						''db_securityadmin'', 
						''db_ddladmin'', 
						''db_backupoperator'',
						''db_datareader'', 
						''db_datawriter'', 
						''db_denydatareader'', 
						''db_denydatawriter'''

DECLARE @sqlexrole VARCHAR(5000);
DECLARE @sqlexuser VARCHAR(5000);
DECLARE @sqlrole VARCHAR(5000);
DECLARE @sqluser VARCHAR(5000);
DECLARE @rolename VARCHAR(256);
DECLARE @username VARCHAR(256);

   -- Drop database users 


CREATE TABLE #droppeduserlist ([name] VARCHAR(256))

BEGIN
		SET @sqlexuser='USE ' + '[' + @newdatabase + ']' + CHAR(13)+'INSERT INTO #droppeduserlist  SELECT [name] FROM sys.database_principals 
					    WHERE [type] IN (''U'',''G'',''S'')  AND [name] NOT IN ('+ @userexceptionlist + ')' 

		EXEC(@sqlexuser)
END


  DECLARE dropusers CURSOR 
    FOR  SELECT [name] FROM #droppeduserlist

 OPEN  dropusers
 FETCH NEXT FROM dropusers INTO   @username
 WHILE @@FETCH_STATUS = 0 
 BEGIN
	
        SET @sqluser =  'USE ' + '[' + @newdatabase + ']' + CHAR(13) + 'BEGIN' + CHAR(13) + 'BEGIN TRY'					   + CHAR(13) + 'DROP USER ' + '[' + @username +']' + CHAR(13)
					   +'PRINT ''The user ' + '[' + @username +']' + ' has been dropped from database ' + '[' + @newdatabase + ']''' + CHAR(13)
					   +'END TRY'+ CHAR(13)+ 'BEGIN CATCH' + CHAR(13)+ 'SELECT ERROR_MESSAGE() AS ErrorMessage;'
					   + CHAR(13) +'END CATCH'+ CHAR(13) +'END' 
					
		--PRINT ( @sqluser )
		EXEC ( @sqluser )

 
 FETCH NEXT FROM dropusers  INTO  @username
 END  
 CLOSE dropusers
 DEALLOCATE dropusers 

 
 DROP TABLE #droppeduserlist



 -- Drop database rols 



 CREATE TABLE #droppedrolelist ([name] VARCHAR(256))

 BEGIN
		SET @sqlexrole= 'USE ' + '[' + @newdatabase + ']' + CHAR(13)+'INSERT INTO #droppedrolelist   SELECT [name] FROM sys.database_principals 
						 WHERE [type]=''R'' AND [name] NOT IN ('+ @roleexceptionlist + ')' 

		EXEC(@sqlexrole)
END



 DECLARE droproles CURSOR 
    FOR  SELECT [name] FROM #droppedrolelist

 OPEN  droproles
 FETCH NEXT FROM droproles INTO   @rolename
 WHILE @@FETCH_STATUS = 0 
 BEGIN
	
        SET @sqlrole =   'USE ' + '[' + @newdatabase + ']' + CHAR(13) + 'BEGIN' +CHAR(13) + 'BEGIN TRY'+ CHAR(13) + 'DROP ROLE ' + '['+@rolename +']'+ CHAR(13)
					   + 'PRINT ''The role ' + '[' + @rolename +']' + ' has been dropped from database ' + '[' + @newdatabase + ']''' + CHAR(13) 
					   + 'END TRY'+ CHAR(13)+ 'BEGIN CATCH' + CHAR(13)+ 'SELECT ERROR_MESSAGE() AS ErrorMessage;'
					   + CHAR(13) +'END CATCH'+ CHAR(13) + 'END' + CHAR(13)

		--PRINT ( @sqlrole )
		EXEC ( @sqlrole )

 
 FETCH NEXT FROM droproles  INTO  @rolename
 END  
 CLOSE droproles
 DEALLOCATE droproles 

 DROP TABLE #droppedrolelist 


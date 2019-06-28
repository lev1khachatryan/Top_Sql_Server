
-- OBJECT NAME: drop login
-- INPUTS: @loginname  - login name


-- DESCRIPTION: This script drop login and drop appropriate users from databases


DECLARE @loginname VARCHAR(256);
DECLARE @dbname VARCHAR(256);
SET @loginname = ''
DECLARE @sql VARCHAR(5000);
DECLARE @sql1 VARCHAR(5000);


DECLARE DROPUSERS CURSOR FOR
    SELECT name FROM sys.databases
    WHERE name NOT IN ('model', 'tempdb')

OPEN DROPUSERS

FETCH NEXT FROM DROPUSERS INTO @dbname
WHILE @@FETCH_STATUS = 0
BEGIN

    SET @SQL =   'USE [' + @dbname + ']' + CHAR(13) + 'IF EXISTS (SELECT name FROM sys.database_principals  WHERE name = '''+ @loginname+ ''''+')'+ CHAR(13) 
			   + 'BEGIN'+ CHAR(13) + 'BEGIN TRY' + CHAR(13) + 'USE [' + @dbname + ']'+ CHAR(13)+ 'DROP USER [' + @loginname + ']'+ CHAR(13)
			   + 'PRINT ''The USER ' + '[' + @loginname +']' + ' has been dropped from database ' + '[' + @dbname + ']''' + CHAR(13) 
			   + 'END TRY'+ CHAR(13)+ 'BEGIN CATCH' + CHAR(13)+ 'SELECT ERROR_MESSAGE() AS ErrorMessage;'
			   +  CHAR(13) +'END CATCH'+ CHAR(13)+ 'END'+CHAR(13)
			   + 'ELSE PRINT ''The user [' + @loginname + '] not exists on database [' + @dbname +']'''
	
	--PRINT ( @SQL )
	EXEC ( @SQL )

    FETCH NEXT FROM DROPUSERS INTO @dbname
END


CLOSE DROPUSERS
DEALLOCATE DROPUSERS


 BEGIN
        
               
        SET @sql1 =    'USE [master];' + CHAR(13) + 'IF EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname =  '
					 + '''' + @loginname + '''' + ')' + CHAR(13) + CHAR(10) + 'BEGIN '+ CHAR(13) + 'BEGIN TRY' + CHAR(13) +'USE [master];' + CHAR(13) 
					 + 'DROP LOGIN ' + @loginname + CHAR(13) 
					 + 'print ''Login ' + '[' + @loginname +']' + ' has been dropped''' + CHAR(13)
					 +'END TRY'+ CHAR(13)+ 'BEGIN CATCH' + CHAR(13)+ 'SELECT ERROR_MESSAGE() AS ErrorMessage;'
					 + CHAR(13) +'END CATCH'+ CHAR(13)+'END'+ CHAR(13)
					 + 'ELSE PRINT ''The login [' + @loginname + '] not exists'''
					
										
		--PRINT ( @sql1 )
		EXEC ( @sql1 )

 END
 GO



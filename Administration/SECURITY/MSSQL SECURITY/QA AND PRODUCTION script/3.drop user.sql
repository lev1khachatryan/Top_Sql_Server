
-- OBJECT NAME: drop user

-- INPUTS: @newdatabase - source database
--         @droppeduser - dropped user name


-- DESCRIPTION: This script drop inputted user 
 



DECLARE @newdatabase VARCHAR(256);
SET @newdatabase =''
DECLARE @droppeduser VARCHAR(256);
SET @droppeduser = ''
DECLARE @sqluser VARCHAR(5000);

   -- Drop database users 

BEGIN

        SET @sqluser =    'USE [' + @newdatabase + ']'+CHAR(13) + 'IF EXISTS (SELECT name FROM sys.database_principals  WHERE name = '''
						+  @droppeduser+ ''''+')'+ CHAR(13)+ 'BEGIN'+ CHAR(13) + 'BEGIN TRY' + CHAR(13) + 'DROP USER ' 
						+ '[' + @droppeduser +']' + CHAR(13) 
						+ 'print ''User ' + '[' + @droppeduser +']' + ' has been dropped from database [' + @newdatabase + ']''' + CHAR(13)
						+ 'END TRY'+ CHAR(13)+ 'BEGIN CATCH' + CHAR(13)+ 'SELECT ERROR_MESSAGE() AS ErrorMessage;'
						+  CHAR(13) +'END CATCH'+ CHAR(13)+'END' + CHAR(13)
					    + 'ELSE print ''The user [' + @droppeduser + '] not exists on database ['+  @newdatabase + ']'''

		--PRINT ( @sqluser )
		EXEC ( @sqluser )

END
GO



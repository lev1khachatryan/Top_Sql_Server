-- This comment was added fօr merge

--#AllPendingUsers -um pahum em bolor pahanjvogh User-neri UserID-nery

CREATE TABLE #AllPendingUsers (id INT)

INSERT INTO #AllPendingUsers
        ( id )
SELECT um_Users.UserID
FROM dbo.um_Users
INNER JOIN dbo.um_UsersRoles
ON um_UsersRoles.UserID = um_Users.UserID
WHERE UserStatusID = 5 AND             --pending
      RoleID = -4 AND                  --public user
	  um_Users.CreatedOn < '20170122'

/*
	DELETE KB-i User -nerin
*/

----------------------------------------------------------------------------------------------------------------------------------------------
--#RelationalTablesInKB -um pahum em  ayn tablenery voronq kpac en um_users-in , ev UserID-n IN e #AllPendingUsers -in  

DECLARE @sql1 AS NVARCHAR(MAX) = N'';
SELECT @sql1 += ' select ''' + OBJECT_NAME(foreign_key_columns.parent_object_id) + ''' , ''' +  columns.name + ''' from ' + OBJECT_NAME(foreign_key_columns.parent_object_id) + ' where ' +  columns.name + ' in (SELECT * FROM #AllPendingUsers) union '
FROM  sys.foreign_key_columns 
INNER JOIN sys.columns ON column_id = parent_column_id AND columns.object_id = foreign_key_columns.parent_object_id
WHERE OBJECT_NAME(foreign_key_columns.referenced_object_id)  = 'um_users'
ORDER BY  OBJECT_NAME(foreign_key_columns.parent_object_id)
SET @sql1 = SUBSTRING( @sql1, 1, LEN(@sql1) - 6)

CREATE TABLE #RelationalTablesInKB (TableName NVARCHAR(50) , RelatedColumnName NVARCHAR(50))
INSERT INTO #RelationalTablesInKB
        ( TableName, RelatedColumnName )
EXEC( @sql1)

----------------------------------------------------------------------------------------------------------------------------------------------
--KB-ic jnjenq User -nerin

EXEC sp_msforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT all'

DECLARE @DeleteFromKB AS NVARCHAR(MAX) = N''
DECLARE @KB_TableName AS NVARCHAR(100);
DECLARE @KB_RelatedColumnName AS NVARCHAR(100);
DECLARE @KB_Cursor AS CURSOR;
SET     @KB_Cursor = CURSOR FOR 
SELECT  TableName , RelatedColumnName
FROM    #RelationalTablesInKB

OPEN @KB_Cursor

FETCH NEXT FROM @KB_Cursor INTO @KB_TableName , @KB_RelatedColumnName;

WHILE @@FETCH_STATUS = 0
BEGIN
	
	SET @DeleteFromKB += ' DELETE FROM ' + @KB_TableName + ' WHERE ' + @KB_RelatedColumnName + ' IN (SELECT * FROM #AllPendingUsers) '
	FETCH NEXT FROM @KB_Cursor INTO @KB_TableName , @KB_RelatedColumnName

END


CLOSE @KB_Cursor
DEALLOCATE @KB_Cursor

--SET @DeleteFromKB = SUBSTRING( @DeleteFromKB, 1, LEN(@DeleteFromKB) - 6)
EXEC (@DeleteFromKB)
DELETE FROM dbo.um_Users
WHERE UserID IN
(
SELECT *
FROM #AllPendingUsers
)

EXEC sp_msforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL'

/*
	DELETE anenq DATA-i User -nerin
*/

----------------------------------------------------------------------------------------------------------------------------------------------
--#RelationalTablesInDATA -um pahum em DATA -i vrai ayn tablenery voronq kpac en C_User-in , ev UserID-n IN e #AllPendingUsers -in  

DECLARE @sql3 AS NVARCHAR(MAX) = N'';
SELECT DISTINCT @sql3 += N'
DECLARE @sql2 AS NVARCHAR(MAX) = N'''';
SELECT @sql2 += '' select '''''' + OBJECT_NAME([' + WorkingCopyDBName +  '].sys.foreign_key_columns.parent_object_id, DB_ID(''' + WorkingCopyDBName+''')) 
+ '''''' , '''''' +  [' + WorkingCopyDBName + '].sys.columns.name + '''''' from ['+ WorkingCopyDBName + '].dbo.'' + OBJECT_NAME([' + WorkingCopyDBName +  '].sys.foreign_key_columns.parent_object_id, DB_ID(''' + WorkingCopyDBName+ ''')) 
+ '' where '' +  [' + WorkingCopyDBName + '].sys.columns.name + '' IN (SELECT * FROM #AllPendingUsers) union ''
FROM [' + WorkingCopyDBName +  '].sys.foreign_key_columns 
INNER JOIN [' + WorkingCopyDBName + '].sys.columns ON column_id = parent_column_id AND [' + WorkingCopyDBName + '].sys.columns.object_id = [' + WorkingCopyDBName +  '].sys.foreign_key_columns.parent_object_id
WHERE OBJECT_NAME([' + WorkingCopyDBName +  '].sys.foreign_key_columns.referenced_object_id, DB_ID('''+WorkingCopyDBName+'''))  = ''C_User''
ORDER BY  OBJECT_NAME([' + WorkingCopyDBName +  '].sys.foreign_key_columns.parent_object_id)
SET @sql2 = SUBSTRING( @sql2, 1, LEN(@sql2) - 6)
EXEC( @sql2)
'
FROM dbo.KB_WorkingCopies

CREATE TABLE #RelationalTablesInDATA (TableName NVARCHAR(50) , RelatedColumnName NVARCHAR(50))
INSERT INTO #RelationalTablesInDATA
        ( TableName, RelatedColumnName )
EXECUTE(@sql3)

----------------------------------------------------------------------------------------------------------------------------------------------
--#UsedUsersDATA -um pahum em en UserID-nery voronq ogtagorcvum en DATA-i voreve table-um (Baci UserRoles table -ic)

DELETE FROM #RelationalTablesInDATA
WHERE TableName = 'UserRole'

DECLARE @UsedUsersInDATA AS NVARCHAR(MAX) = N''
DECLARE @DATA_TableName AS NVARCHAR(100);
DECLARE @DATA_RelatedColumnName AS NVARCHAR(100);
DECLARE @DATA_Cursor AS CURSOR;
SET @DATA_Cursor = CURSOR FOR 
SELECT TableName , RelatedColumnName
FROM #RelationalTablesInDATA

OPEN @DATA_Cursor

FETCH NEXT FROM @DATA_Cursor INTO @DATA_TableName , @DATA_RelatedColumnName;

WHILE @@FETCH_STATUS = 0
BEGIN
	
	SELECT DISTINCT @UsedUsersInDATA += N'
	SELECT ' + @DATA_RelatedColumnName +
	' FROM [' + WorkingCopyDBName + '].dbo.' + @DATA_TableName +
	' WHERE ' + @DATA_RelatedColumnName + ' IN 
	(SELECT * FROM #AllPendingUsers) UNION '
	FROM dbo.KB_WorkingCopies
	FETCH NEXT FROM @DATA_Cursor INTO @DATA_TableName ,@DATA_RelatedColumnName

END

CLOSE @DATA_Cursor
DEALLOCATE @DATA_Cursor

SET @UsedUsersInDATA = SUBSTRING( @UsedUsersInDATA, 1, LEN(@UsedUsersInDATA) - 6)

CREATE TABLE #UsedUsersInDATA (id int)
INSERT INTO #UsedUsersInDATA
        ( id )
EXEC (@UsedUsersInDATA)

----------------------------------------------------------------------------------------------------------------------------------------------
--DATA-ic jnjenq ayn usernerin voronq voch mi tegh kpac chen 

DECLARE @DisableAllConstraintsInDATA AS NVARCHAR(MAX) = N'';
SELECT DISTINCT @DisableAllConstraintsInDATA += N'USE [' + WorkingCopyDBName + ']' +
'EXEC sp_msforeachtable ''ALTER TABLE ? NOCHECK CONSTRAINT all'''
FROM dbo.KB_WorkingCopies
EXEC (@DisableAllConstraintsInDATA)

DECLARE @DeleteFromUserRolesInDATA AS NVARCHAR(MAX) = N''
SELECT DISTINCT @DeleteFromUserRolesInDATA += ' DELETE FROM [' + WorkingCopyDBName +'].dbo.UserRole 
WHERE UserID IN (SELECT * FROM #AllPendingUsers EXCEPT SELECT * FROM #UsedUsersInDATA )'
FROM dbo.KB_WorkingCopies
EXEC (@DeleteFromUserRolesInDATA)

DECLARE @DeleteUsersFromC_UsersInDATA AS NVARCHAR(MAX) = N''
SELECT DISTINCT @DeleteUsersFromC_UsersInDATA += N'DELETE FROM [' + WorkingCopyDBName + '].dbo.C_User
WHERE UserID IN (SELECT * FROM #AllPendingUsers EXCEPT SELECT * FROM #UsedUsersInDATA )'
FROM dbo.KB_WorkingCopies
EXEC (@DeleteUsersFromC_UsersInDATA)


DECLARE @EnableAllConstraintsInDATA AS NVARCHAR(MAX) = N'';
SELECT DISTINCT @EnableAllConstraintsInDATA += N'USE [' + WorkingCopyDBName + ']' +
'EXEC sp_msforeachtable ''ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL'''
FROM dbo.KB_WorkingCopies
EXEC (@EnableAllConstraintsInDATA)


/*
	DELETE Users in DE
*/



----------------------------------------------------------------------------------------------------------------------------------------------
--#RelationalTablesInDE -um pahum em DE -i vrai ayn tablenery voronq kpac en C_User-in , ev UserID-n IN e #AllPendingUsers -in  

DECLARE @sql5 AS NVARCHAR(MAX) = N'';
SELECT DISTINCT @sql5 += N'
DECLARE @sql4 AS NVARCHAR(MAX) = N'''';
SELECT @sql4 += '' select '''''' + OBJECT_NAME([' + REPLACE(WorkingCopyDBName,'DATA' , 'DE') +  '].sys.foreign_key_columns.parent_object_id, DB_ID(''' + REPLACE(WorkingCopyDBName,'DATA' , 'DE')+''')) 
+ '''''' , '''''' +  [' + REPLACE(WorkingCopyDBName,'DATA' , 'DE') + '].sys.columns.name + '''''' from ['+ REPLACE(WorkingCopyDBName,'DATA' , 'DE') + '].dbo.'' + OBJECT_NAME([' + REPLACE(WorkingCopyDBName,'DATA' , 'DE') +  '].sys.foreign_key_columns.parent_object_id, DB_ID(''' + REPLACE(WorkingCopyDBName,'DATA' , 'DE')+ ''')) 
+ '' where '' +  [' + REPLACE(WorkingCopyDBName,'DATA' , 'DE') + '].sys.columns.name + '' IN (SELECT * FROM #AllPendingUsers) union ''
FROM [' + REPLACE(WorkingCopyDBName,'DATA' , 'DE') +  '].sys.foreign_key_columns 
INNER JOIN [' + REPLACE(WorkingCopyDBName,'DATA' , 'DE') + '].sys.columns ON column_id = parent_column_id AND [' + REPLACE(WorkingCopyDBName,'DATA' , 'DE') + '].sys.columns.object_id = [' + REPLACE(WorkingCopyDBName,'DATA' , 'DE') +  '].sys.foreign_key_columns.parent_object_id
WHERE OBJECT_NAME([' + REPLACE(WorkingCopyDBName,'DATA' , 'DE') +  '].sys.foreign_key_columns.referenced_object_id, DB_ID('''+REPLACE(WorkingCopyDBName,'DATA' , 'DE')+'''))  = ''C_User''
ORDER BY  OBJECT_NAME([' + REPLACE(WorkingCopyDBName,'DATA' , 'DE') +  '].sys.foreign_key_columns.parent_object_id)
SET @sql4 = SUBSTRING( @sql4, 1, LEN(@sql4) - 6)
EXEC( @sql4)
'
FROM dbo.KB_WorkingCopies

CREATE TABLE #RelationalTablesInDE (TableName NVARCHAR(50) , RelatedColumnName NVARCHAR(50))
INSERT INTO #RelationalTablesInDE
        ( TableName, RelatedColumnName )
EXECUTE(@sql5)
--print(@sql5)
----------------------------------------------------------------------------------------------------------------------------------------------
--#UsedUsersDE -um pahum em en UserID-nery voronq ogtagorcvum en DE-i voreve table-um (Baci UserRoles table -ic)

DELETE FROM #RelationalTablesInDE
WHERE TableName = 'UserRole'

DECLARE @UsedUsersInDE AS NVARCHAR(MAX) = N''
DECLARE @DE_TableName AS NVARCHAR(100);
DECLARE @DE_RelatedColumnName AS NVARCHAR(100);
DECLARE @DE_Cursor AS CURSOR;
SET @DE_Cursor = CURSOR FOR 
SELECT TableName , RelatedColumnName
FROM #RelationalTablesInDE

OPEN @DE_Cursor

FETCH NEXT FROM @DE_Cursor INTO @DE_TableName , @DE_RelatedColumnName;

WHILE @@FETCH_STATUS = 0
BEGIN
	
	SELECT DISTINCT @UsedUsersInDE += N'
	SELECT ' + @DE_RelatedColumnName +
	' FROM [' + REPLACE(WorkingCopyDBName,'DATA' , 'DE') + '].dbo.' + @DE_TableName +
	' WHERE ' + @DE_RelatedColumnName + ' IN 
	(SELECT * FROM #AllPendingUsers) UNION '
	FROM dbo.KB_WorkingCopies
	FETCH NEXT FROM @DE_Cursor INTO @DE_TableName ,@DE_RelatedColumnName

END

CLOSE @DE_Cursor
DEALLOCATE @DE_Cursor

SET @UsedUsersInDE = SUBSTRING( @UsedUsersInDE, 1, LEN(@UsedUsersInDE) - 6)

--PRINT (@UsedUsersInDE)

CREATE TABLE #UsedUsersDE (id int)
INSERT INTO #UsedUsersDE
        ( id )
EXEC (@UsedUsersInDE)

----------------------------------------------------------------------------------------------------------------------------------------------
--DE-ic jnjenq ayn usernerin voronq voch mi tegh kpac chen 

DECLARE @DisableAllConstraintsDE AS NVARCHAR(MAX) = N'';
SELECT DISTINCT @DisableAllConstraintsDE += N'USE [' + REPLACE(WorkingCopyDBName,'DATA' , 'DE') + ']' +
'EXEC sp_msforeachtable ''ALTER TABLE ? NOCHECK CONSTRAINT all'''
FROM dbo.KB_WorkingCopies
EXEC (@DisableAllConstraintsDE)

DECLARE @DeleteFromUserRolesInDE AS NVARCHAR(MAX) = N''
SELECT DISTINCT @DeleteFromUserRolesInDE += 'DELETE FROM [' + REPLACE(WorkingCopyDBName,'DATA' , 'DE') +'].dbo.UserRole 
WHERE UserID IN (SELECT * FROM #AllPendingUsers EXCEPT SELECT * FROM #UsedUsersDE )'
FROM dbo.KB_WorkingCopies
EXEC (@DeleteFromUserRolesInDE)

DECLARE @DeleteFromC_UsersInDE AS NVARCHAR(MAX) = N''
SELECT DISTINCT @DeleteFromC_UsersInDE += N'DELETE FROM [' + REPLACE(WorkingCopyDBName,'DATA' , 'DE') + '].dbo.C_User
WHERE UserID IN (SELECT * FROM #AllPendingUsers EXCEPT SELECT * FROM #UsedUsersDE )'
FROM dbo.KB_WorkingCopies
EXEC (@DeleteFromC_UsersInDE)

DECLARE @EnableAllConstraintsDE AS NVARCHAR(MAX) = N'';
SELECT DISTINCT @EnableAllConstraintsDE += N'USE [' + REPLACE(WorkingCopyDBName,'DATA' , 'DE') + ']' +
'EXEC sp_msforeachtable ''ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL'''
FROM dbo.KB_WorkingCopies
EXEC (@EnableAllConstraintsDE)

DROP TABLE #AllPendingUsers
DROP TABLE #RelationalTablesInDATA
DROP TABLE #RelationalTablesInDE
DROP TABLE #RelationalTablesInKB
DROP TABLE #UsedUsersDE
DROP TABLE #UsedUsersInDATA

GO

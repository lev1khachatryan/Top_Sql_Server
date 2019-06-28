DECLARE @newTbName VARCHAR(50)
DECLARE @IncludeConditions VARCHAR(max) = NULL --The string must end with ','
DECLARE @ExcludeConditions VARCHAR(max) = 'Document, DocumentType, UserRole, ReplicationHistory ' --The string must end with ','
DECLARE  @tbIncludeConditions TABLE(name VARCHAR(500))
DECLARE  @tbExcludeConditions TABLE(name VARCHAR(500))
WHILE (ISNULL(CHARINDEX(',', @IncludeConditions),0)>0)
BEGIN
	INSERT INTO @tbIncludeConditions
	        ( name )
	VALUES  (SUBSTRING(@IncludeConditions, 0, CHARINDEX(',', @IncludeConditions)))

	SET @IncludeConditions = LTRIM(RTRIM(SUBSTRING(@IncludeConditions, CHARINDEX(',', @IncludeConditions)  + 1, LEN(@IncludeConditions))))
END

WHILE (ISNULL(CHARINDEX(',', @ExcludeConditions),0)>0)
BEGIN
	INSERT INTO @tbExcludeConditions
	        ( name )
	VALUES  (SUBSTRING(@ExcludeConditions, 0, CHARINDEX(',', @ExcludeConditions)))

	SET @ExcludeConditions = LTRIM(RTRIM(SUBSTRING(@ExcludeConditions, CHARINDEX(',', @ExcludeConditions)  + 1, LEN(@ExcludeConditions))))
END


DECLARE Alter_tables_cursor CURSOR
   FOR
   select table_name from information_schema.tables 
   WHERE table_name<>'dtProperties' and table_type<>'VIEW' 
			AND TABLE_NAME NOT LIKE 'DE%' 
			AND TABLE_NAME NOT LIKE 'wf%'
			AND TABLE_NAME NOT LIKE 'C!_%' ESCAPE '!'
			AND (@IncludeConditions IS NULL OR TABLE_NAME IN (SELECT * FROM @tbIncludeConditions))
			AND (@ExcludeConditions IS NULL OR TABLE_NAME NOT IN (SELECT * FROM @tbExcludeConditions))
OPEN Alter_tables_cursor
DECLARE @tablename sysname
FETCH NEXT FROM Alter_tables_cursor INTO @tablename
WHILE ( @@FETCH_STATUS = 0 )
BEGIN
	SET @newTbName = 'DE_' + @tablename
	BEGIN tran
	EXEC sp_rename @tablename, @newTbName;
	COMMIT tran	
	FETCH NEXT FROM Alter_tables_cursor INTO @tablename
 
END
DEALLOCATE Alter_tables_cursor

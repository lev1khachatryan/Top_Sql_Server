DECLARE @tableName NVARCHAR(200)
DECLARE @columnName NVARCHAR(200)
DECLARE @str NVARCHAR(2000)



DECLARE db_cursor CURSOR FOR  
SELECT TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE DATA_TYPE = 'bit'

OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @tableName, @columnName  

WHILE @@FETCH_STATUS = 0   
BEGIN   
       SET @str = 'ALTER TABLE ' +  @tableName + ' ALTER COLUMN ' +  @columnName + ' int' 
	   EXEC (@str)
       FETCH NEXT FROM db_cursor INTO @tableName, @columnName    
END   

CLOSE db_cursor   
DEALLOCATE db_cursor




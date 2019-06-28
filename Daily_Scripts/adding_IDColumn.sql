USE AdventureWorks2012;
GO
DECLARE @ID NVARCHAR(500);

DECLARE @sqlCommand NVARCHAR(1000);
--DECLARE @ParamDefinition NVARCHAR(500);
--SET @ParamDefinition = N'@TableName NVARCHAR(500), @TableSchema NVARCHAR(500), @ID NVARCHAR(500)';

DECLARE @TableName NVARCHAR(500);
SET @TableName = 'Location';

DECLARE @TableSchema NVARCHAR(500);
SET @TableSchema = 'Production';

SET @ID = ( SELECT  COLUMN_NAME
            FROM    information_schema.KEY_COLUMN_USAGE
            WHERE   CONSTRAINT_Name LIKE 'PK%'
                    AND TABLE_NAME = @TableName
                    AND TABLE_SCHEMA = @TableSchema
          )
		  
SET @sqlCommand = N'ALTER TABLE ' + @TableSchema + '.' + @TableName + '
				   ADD ID AS   ' + @ID

IF NOT EXISTS ( SELECT  *
                FROM    INFORMATION_SCHEMA.COLUMNS
                WHERE   TABLE_NAME = @TableName
                        AND COLUMN_NAME = 'ID' ) 
    BEGIN 
        EXEC( @sqlCommand)
		       -- or  EXECUTE sp_executesql @sqlCommand, @ParamDefinition, @TableName = @TableName , @TableSchema = @TableSchema, @ID = @ID ;
	
    END
  
ELSE 
    PRINT 'ID column is exist!!'  
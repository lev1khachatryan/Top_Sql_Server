USE AdventureWorks2012;
GO
DECLARE @IncludeConditions NVARCHAR(MAX);
DECLARE @ExcludeConditions NVARCHAR(MAX);
DECLARE @TableSchema NVARCHAR(500);
DECLARE @TableName NVARCHAR(500);
DECLARE @ID NVARCHAR(500);
DECLARE @sqlCommand NVARCHAR(1000);
DECLARE @Result TABLE ( Value NVARCHAR(MAX) );
DECLARE @str NVARCHAR(500);
DECLARE @ind INT;


SET @ExcludeConditions = 'Address, AddressType, BusinessEntity';

SET @TableSchema = 'Person';

IF ( @ExcludeConditions IS NOT NULL ) 
    BEGIN
        SET @ind = CHARINDEX(',', @ExcludeConditions)
        WHILE @ind > 0 
            BEGIN
                SET @str = SUBSTRING(@ExcludeConditions, 1, @ind - 1)
                SET @ExcludeConditions = SUBSTRING(@ExcludeConditions,
                                                   @ind + 1,
                                                   LEN(@ExcludeConditions)
                                                   - @ind)
                INSERT  INTO @Result
                VALUES  ( LTRIM(RTRIM(@str)) )
                SET @ind = CHARINDEX(',', @ExcludeConditions)
            END
        SET @str = @ExcludeConditions
        INSERT  INTO @Result
        VALUES  ( LTRIM(RTRIM(@str)) )

        SET @IncludeConditions = ''
        SELECT  @IncludeConditions = @IncludeConditions + TABLE_NAME + ','
        FROM    ( SELECT    TABLE_NAME
                  FROM      INFORMATION_SCHEMA.TABLES
                  WHERE     TABLE_TYPE = 'BASE TABLE'
                            AND TABLE_CATALOG = 'AdventureWorks2012' AND TABLE_SCHEMA = @TableSchema
                  EXCEPT
                  SELECT    *
                  FROM      @Result
                ) AS tbl
        SET @IncludeConditions = SUBSTRING(@IncludeConditions, 0,
                                           LEN(@IncludeConditions) - 1)
    END
 --SELECT * from   @Result

SET @TableName = SUBSTRING(@IncludeConditions, 0,
                           CHARINDEX(',', @IncludeConditions));
WHILE @TableName != @IncludeConditions 
    BEGIN 

	 
        SET @ID = ( SELECT  COLUMN_NAME
                    FROM    information_schema.KEY_COLUMN_USAGE
                    WHERE   CONSTRAINT_Name LIKE 'PK%'
                            AND TABLE_NAME = LTRIM(RTRIM(@TableName))
                            AND TABLE_SCHEMA = @TableSchema
                  )
		  
        SET @sqlCommand = N'ALTER TABLE ' + @TableSchema + '.' + @TableName
            + '
				   ADD ID AS   ' + @ID

        IF NOT EXISTS ( SELECT  *
                        FROM    INFORMATION_SCHEMA.COLUMNS
                        WHERE   TABLE_NAME = LTRIM(RTRIM(@TableName))
                                AND COLUMN_NAME = 'ID' ) 
            BEGIN 
                EXEC( @sqlCommand)         
            END
  
        ELSE 
            PRINT 'ID column is exist!!'  
		 
		 -- next
        SET @IncludeConditions = SUBSTRING(@IncludeConditions,
                                           CHARINDEX(',', @IncludeConditions)
                                           + 1, LEN(@IncludeConditions) + 1);
			
		--SELECT @TableName, @IncludeConditions

        IF CHARINDEX(',', @IncludeConditions) = 0 
            BEGIN
                SET @TableName = SUBSTRING(@IncludeConditions, 0,
                                           LEN(@IncludeConditions) + 1);
                SET @IncludeConditions = '';
				
            END 
        ELSE 
            SET @TableName = SUBSTRING(@IncludeConditions, 0,
                                       CHARINDEX(',', @IncludeConditions));   

		
			
       

    END 










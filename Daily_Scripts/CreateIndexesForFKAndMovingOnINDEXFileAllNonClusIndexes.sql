-- This comment was added fօr merge
DECLARE @ObjectName NVARCHAR(300),
        @IndexName NVARCHAR(300),
        @Columns NVARCHAR(MAX),
        @IncludeColumns NVARCHAR(MAX),
        @Command NVARCHAR(MAX),
		@ForRename1 NVARCHAR(300),
		@ForRename2 NVARCHAR(300)

DECLARE IndexCursor CURSOR FOR
    SELECT  OBJECT_NAME(o.object_id) AS ObjectName ,
			i.name AS Indexname, 
            STUFF((SELECT ',['+c.name+']'
            FROM sys.index_columns ic 
            INNER JOIN sys.columns c ON c.column_id = ic.column_id AND c.object_id = ic.object_id
            WHERE ic.object_id = i.object_id
                AND ic.index_id = i.index_id
                AND ic.is_included_column=0 
            ORDER BY ic.key_ordinal
            FOR XML PATH('')
            ),1,1,'') IndexColumn,
            STUFF((SELECT ',['+c.name+']'
            FROM sys.index_columns ic 
            INNER JOIN sys.columns c ON c.column_id = ic.column_id AND c.object_id = ic.object_id
            WHERE ic.object_id = i.object_id
                AND ic.index_id = i.index_id
                AND ic.is_included_column=1
            ORDER BY ic.key_ordinal
            FOR XML PATH('')
            ),1,1,'') IncludeColumn
    FROM sys.indexes i
    INNER JOIN sys.objects o ON o.object_id = i.object_id
    --INNER JOIN sys.data_spaces ds ON ds.data_space_id = i.data_space_id
    WHERE --ds.name = 'PRIMARY'
		i.type_desc = 'NONCLUSTERED'
        AND OBJECTPROPERTY(i.object_id,'IsUserTable')=1

OPEN IndexCursor
FETCH NEXT FROM IndexCursor INTO @ObjectName, @IndexName, @Columns, @IncludeColumns
WHILE @@FETCH_STATUS=0 BEGIN
	SET @ForRename1 = N'dbo.' + @ObjectName + '.' + @IndexName + ''
	SET @ForRename2 = REPLACE(@IndexName , 'UIX' ,'IX')
	EXEC sp_rename @ForRename1, @ForRename2, N'INDEX'; 

    SET @Command = 'CREATE INDEX ' + REPLACE(@IndexName , 'UIX' ,'IX') + ' ON [dbo].['+@ObjectName+']('+@Columns+') '+ ISNULL('Include ('+@IncludeColumns+')','') + ' WITH (DROP_EXISTING = ON) ON [INDEX]'
    EXEC(@Command)

    FETCH NEXT FROM IndexCursor INTO @ObjectName, @IndexName, @Columns, @IncludeColumns
END
CLOSE IndexCursor
DEALLOCATE IndexCursor
GO
--------------------------------------------
DECLARE @Command2 NVARCHAR(MAX) = N'';
DECLARE IndexCursor2 CURSOR FOR
SELECT 'IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name = ''IX_' + REPLACE(f.name ,'FK_' , '') + ''')
BEGIN
	CREATE INDEX [IX_' + REPLACE(f.name ,'FK_' , '') + '] ON ' + OBJECT_NAME(f.parent_object_id) + '(' + COL_NAME(fc.parent_object_id, fc.parent_column_id) + ') ON [INDEX]
END
'
FROM sys.foreign_keys AS f 
INNER JOIN sys.foreign_key_columns AS fc 
ON f.OBJECT_ID = fc.constraint_object_id
OPEN IndexCursor2
FETCH NEXT FROM IndexCursor2 INTO  @Command2
WHILE @@FETCH_STATUS=0 BEGIN
    EXEC(@Command2)
    FETCH NEXT FROM IndexCursor2 INTO @Command2
END
CLOSE IndexCursor2
DEALLOCATE IndexCursor2
GO

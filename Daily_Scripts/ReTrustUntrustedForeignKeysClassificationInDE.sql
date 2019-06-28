CREATE TABLE #x
	(
	drop_script NVARCHAR(MAX),
	create_script NVARCHAR(MAX)
	);
	DECLARE @drop   NVARCHAR(MAX) = N'',
    @create NVARCHAR(MAX) = N'';
	
	SELECT @drop += N'ALTER TABLE ' + QUOTENAME(cs.name) + '.' + QUOTENAME(ct.name) 
	+ ' DROP CONSTRAINT ' + QUOTENAME(fk.name) + ';'
	FROM sys.foreign_keys AS fk
	INNER JOIN sys.tables AS ct
	ON fk.parent_object_id = ct.[object_id]
	INNER JOIN sys.schemas AS cs 
	ON ct.[schema_id] = cs.[schema_id]
	where fk.Is_Not_Trusted = 1  ;

	INSERT #x(drop_script) SELECT @drop;
	
	SELECT @create += N'
	ALTER TABLE '
	+ QUOTENAME(cs.name) + '.' + QUOTENAME(ct.name)
	+ ' ADD CONSTRAINT ' + QUOTENAME(fk.name)
	+ ' FOREIGN KEY (' + STUFF((SELECT ','  + QUOTENAME(c.name)
	FROM sys.columns AS c 
    INNER JOIN sys.foreign_key_columns AS fkc 
    ON fkc.parent_column_id = c.column_id
    AND fkc.parent_object_id = c.[object_id]
    WHERE fkc.constraint_object_id = fk.[object_id]
    ORDER BY fkc.constraint_column_id
	FOR XML PATH(N''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 1, N'')
	+ ')  REFERENCES '  + QUOTENAME(rs.name) + '.'  + QUOTENAME(rt.name)
	+ '(' + STUFF((SELECT ','  + QUOTENAME(c.name)
	FROM sys.columns AS c 
    INNER JOIN sys.foreign_key_columns AS fkc 
    ON fkc.referenced_column_id = c.column_id
    AND fkc.referenced_object_id = c.[object_id]
    WHERE fkc.constraint_object_id = fk.[object_id]
    ORDER BY fkc.constraint_column_id
	FOR XML PATH(N''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 1, N'') + ');'
	FROM sys.foreign_keys AS fk
	INNER JOIN sys.tables AS rt -- referenced table
	  ON fk.referenced_object_id = rt.[object_id]
	INNER JOIN sys.schemas AS rs 
	  ON rt.[schema_id] = rs.[schema_id]
	INNER JOIN sys.tables AS ct -- constraint table
	  ON fk.parent_object_id = ct.[object_id]
	INNER JOIN sys.schemas AS cs 
	  ON ct.[schema_id] = cs.[schema_id]
	WHERE rt.is_ms_shipped = 0 AND ct.is_ms_shipped = 0
	and fk.Is_Not_Trusted = 1;

	UPDATE #x SET create_script = @create;

	--SELECT *
	--FROM #x

	PRINT @drop;
	PRINT @create;
	
	EXEC sp_executesql @drop

	EXEC sp_executesql @create;
drop table #x

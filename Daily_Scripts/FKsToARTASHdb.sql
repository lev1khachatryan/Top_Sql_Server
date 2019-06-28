INSERT INTO [ARTASH].dbo.DropFKs(DropScript)
SELECT N'
ALTER TABLE ' + QUOTENAME(cs.name) + '.' + QUOTENAME(ct.name) 
    + ' DROP CONSTRAINT ' + QUOTENAME(fk.name) + ';'
FROM sys.foreign_keys AS fk
INNER JOIN sys.tables AS ct
  ON fk.parent_object_id = ct.[object_id]
INNER JOIN sys.schemas AS cs 
  ON ct.[schema_id] = cs.[schema_id]
INNER JOIN sys.tables AS rt -- referenced table
  ON fk.referenced_object_id = rt.[object_id]
WHERE rt.name <> 'DocumentType' --rt.name NOT LIKE 'C!_%' ESCAPE '!' AND ct.name NOT LIKE 'C!_%' ESCAPE '!' AND rt.name <> 'DocumentType'



INSERT INTO [ARTASH].dbo.CreateFKs(CreateScript)
SELECT N'
ALTER TABLE ' 
   + QUOTENAME(cs.name) + '.' + QUOTENAME(ct.name) 
   + ' ADD CONSTRAINT ' + QUOTENAME(fk.name) 
   + ' FOREIGN KEY (' + STUFF((SELECT ',' + QUOTENAME(c.name)
   -- get all the columns in the constraint table
    FROM sys.columns AS c 
    INNER JOIN sys.foreign_key_columns AS fkc 
    ON fkc.parent_column_id = c.column_id
    AND fkc.parent_object_id = c.[object_id]
    WHERE fkc.constraint_object_id = fk.[object_id]
    ORDER BY fkc.constraint_column_id 
    FOR XML PATH(N''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 1, N'')
  + ') REFERENCES ' + QUOTENAME(rs.name) + '.' + QUOTENAME(rt.name)
  + '(' + STUFF((SELECT ',' + QUOTENAME(c.name)
   -- get all the referenced columns
    FROM sys.columns AS c 
    INNER JOIN sys.foreign_key_columns AS fkc 
    ON fkc.referenced_column_id = c.column_id
    AND fkc.referenced_object_id = c.[object_id]
    WHERE fkc.constraint_object_id = fk.[object_id]
    ORDER BY fkc.constraint_column_id 
    FOR XML PATH(N''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 1, N'') + ')' + 
	CASE WHEN fk.delete_referential_action = 1 THEN ' ON DELETE CASCADE ' ELSE '' END + 
	CASE WHEN fk.delete_referential_action = 2 THEN ' ON DELETE  SET NULL ' ELSE '' END + 
	CASE WHEN fk.delete_referential_action = 3 THEN ' ON DELETE SET DEFAULT ' ELSE '' END + 
	CASE WHEN fk.update_referential_action = 1 THEN ' ON UPDATE CASCADE ' ELSE '' END + 
	CASE WHEN fk.update_referential_action = 2 THEN ' ON UPDATE SET NULL ' ELSE '' END +
	CASE WHEN fk.update_referential_action = 3 THEN ' ON UPDATE SET DEFAULT ' ELSE '' END +
	';'
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
AND rt.name NOT LIKE 'C!_%' ESCAPE '!'

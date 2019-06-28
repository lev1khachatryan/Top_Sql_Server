BEGIN TRAN
BEGIN TRY


CREATE TABLE #EnabledTriggers
    (
      trigger_name NVARCHAR(500) ,
      table_name NVARCHAR(500)
    );
INSERT INTO #EnabledTriggers
        ( trigger_name, table_name )
SELECT 
     sysobjects.name AS trigger_name
    ,OBJECT_NAME(parent_obj) AS table_name
FROM sysobjects
INNER JOIN sys.tables t 
    ON sysobjects.parent_obj = t.object_id 
INNER JOIN sys.schemas s 
    ON t.schema_id = s.schema_id 
WHERE sysobjects.type = 'TR'
AND OBJECTPROPERTY(id, 'ExecIsTriggerDisabled') = 0


DECLARE @sql1 AS NVARCHAR(MAX) = N''
SELECT @sql1 += '
ALTER TABLE ' + table_name + '
DISABLE TRIGGER ' + trigger_name + '
'
FROM #EnabledTriggers
EXEC (@sql1)


DECLARE @drop   NVARCHAR(MAX) = N'',
        @create NVARCHAR(MAX) = N'';
SELECT  @drop +=  N'
ALTER TABLE ' + QUOTENAME(cs.name) + '.' + QUOTENAME(ct.name) 
    + ' DROP CONSTRAINT ' + QUOTENAME(fk.name) + ';'
FROM sys.foreign_keys AS fk
INNER JOIN sys.tables AS ct
  ON fk.parent_object_id = ct.[object_id]
INNER JOIN sys.schemas AS cs 
  ON ct.[schema_id] = cs.[schema_id]
INNER JOIN sys.tables AS rt -- referenced table
  ON fk.referenced_object_id = rt.[object_id]

SELECT @create += N'
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

EXECUTE (@drop)

EXEC [DEV-RWA_IECMS-DE_Live_20170804].[dbo].[sync_UpdateReportingTables]

EXEC dbo.DE_AfterFullSync

EXEC (@create)

DECLARE @sql3 AS NVARCHAR(MAX) = N''
SELECT @sql3 += '
ALTER TABLE ' + table_name + '
ENABLE TRIGGER ' + trigger_name + '
'
FROM #EnabledTriggers

EXEC (@sql3)

COMMIT
END TRY
BEGIN CATCH
	SELECT ERROR_LINE() , ERROR_MESSAGE() , ERROR_NUMBER() , ERROR_SEVERITY() , ERROR_STATE()
	ROLLBACK
END CATCH
GO

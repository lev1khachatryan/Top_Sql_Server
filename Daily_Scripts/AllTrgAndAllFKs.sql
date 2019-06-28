/*
	Disable Triggers  DDXK
*/

sp_msforeachtable 'ALTER TABLE ? DISABLE TRIGGER all'
GO
sp_msforeachtable 'ALTER TABLE ? ENABLE TRIGGER all'
GO


-----
DECLARE @sql1 AS NVARCHAR(MAX) = N''
SELECT @sql1 += '
ALTER TABLE ' + ddxk.table_name + '
DISABLE TRIGGER ' + ddxk.trigger_name + '
'
FROM 
(

SELECT 
     sysobjects.name AS trigger_name 
    ,OBJECT_NAME(parent_obj) AS table_name 
    ,OBJECTPROPERTY( id, 'ExecIsUpdateTrigger') AS isupdate 
    ,OBJECTPROPERTY( id, 'ExecIsDeleteTrigger') AS isdelete 
    ,OBJECTPROPERTY( id, 'ExecIsInsertTrigger') AS isinsert 
    ,OBJECTPROPERTY( id, 'ExecIsAfterTrigger') AS isafter 
    ,OBJECTPROPERTY( id, 'ExecIsInsteadOfTrigger') AS isinsteadof 
    ,OBJECTPROPERTY(id, 'ExecIsTriggerDisabled') AS [disabled] 
FROM sysobjects
INNER JOIN sys.tables t 
    ON sysobjects.parent_obj = t.object_id 
INNER JOIN sys.schemas s 
    ON t.schema_id = s.schema_id 
WHERE sysobjects.type = 'TR'
AND OBJECT_NAME(parent_obj) LIKE 'CourtCase%'

) AS ddxk

EXEC (@sql1)


/*
	Drop FKs
*/


DECLARE @sql2 AS NVARCHAR(MAX) = N''
SELECT @sql2 += '
ALTER TABLE ' + ddxk.FK_Table + '
DROP CONSTRAINT ' + ddxk.FK_Name + '
'
from
(
SELECT RC.CONSTRAINT_NAME FK_Name
, KF.TABLE_SCHEMA FK_Schema
, KF.TABLE_NAME FK_Table
, KF.COLUMN_NAME FK_Column
, RC.UNIQUE_CONSTRAINT_NAME PK_Name
, KP.TABLE_SCHEMA PK_Schema
, KP.TABLE_NAME PK_Table
, KP.COLUMN_NAME PK_Column
, RC.MATCH_OPTION MatchOption
, RC.UPDATE_RULE UpdateRule
, RC.DELETE_RULE DeleteRule
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS RC
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE KF ON RC.CONSTRAINT_NAME = KF.CONSTRAINT_NAME
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE KP ON RC.UNIQUE_CONSTRAINT_NAME = KP.CONSTRAINT_NAME
WHERE KP.TABLE_NAME LIKE 'CourtCase%'
) AS ddxk

EXEC (@sql2)

/*
	Recreate all FKs with all options
*/

DECLARE @drop   NVARCHAR(MAX) = N'',
        @create NVARCHAR(MAX) = N'';

SELECT @drop += N'
ALTER TABLE ' + QUOTENAME(cs.name) + '.' + QUOTENAME(ct.name) 
    + ' DROP CONSTRAINT ' + QUOTENAME(fk.name) + ';'
FROM sys.foreign_keys AS fk
INNER JOIN sys.tables AS ct
  ON fk.parent_object_id = ct.[object_id]
INNER JOIN sys.schemas AS cs 
  ON ct.[schema_id] = cs.[schema_id]
INNER JOIN sys.tables AS rt -- referenced table
  ON fk.referenced_object_id = rt.[object_id]
WHERE rt.name LIKE 'RCSCase%'

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
AND fk.name LIKE 'RCSCase%'

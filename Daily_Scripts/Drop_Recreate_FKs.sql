-- This comment was added fօr merge
CREATE TABLE #x -- feel free to use a permanent table
(
  drop_script NVARCHAR(MAX),
  create_script NVARCHAR(MAX),
  dropAfterDelete_script NVARCHAR(MAX),
  createAfterDelete_script NVARCHAR(MAX)
);

DECLARE @drop              NVARCHAR(MAX) = N'',
        @create            NVARCHAR(MAX) = N'',
		@dropAfterDelete   NVARCHAR(MAX) = N'',
		@createAfterDelete NVARCHAR(MAX) = N'';

-- drop is easy, just build a simple concatenated list from sys.foreign_keys:
SELECT @drop += N'
ALTER TABLE ' +  QUOTENAME(cs.name) + '.' + QUOTENAME(ct.name) 
    + ' DROP CONSTRAINT ' + QUOTENAME(fk.name) + ';'
FROM sys.foreign_keys AS fk
INNER JOIN sys.tables AS ct
  ON fk.parent_object_id = ct.[object_id]
INNER JOIN sys.schemas AS cs 
  ON ct.[schema_id] = cs.[schema_id]
  INNER JOIN sys.tables rt ON fk.referenced_object_id = rt.object_id
  WHERE ct.name LIKE 'DE_CourtCase%'
  AND rt.name LIKE 'DE_CourtCase%';



INSERT #x(drop_script) SELECT @drop;


-- create is a little more complex. We need to generate the list of 
-- columns on both sides of the constraint, even though in most cases
-- there is only one column.
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
    FOR XML PATH(N''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 1, N'') + ')' + ' ON DELETE CASCADE ;'
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
AND rt.name LIKE 'DE_CourtCase%'
AND ct.name LIKE 'DE_CourtCase%'

UPDATE #x SET create_script = @create;

--PRINT @drop
EXECUTE(@drop)

--PRINT @create
EXECUTE(@create)

------------------------------------------------------------------------------------------------------------
UPDATE A
  SET A.CourtCaseID = B.CourtCaseID
  FROM dbo.DE_CourtCasePublishedItem AS A
  INNER JOIN dbo.DE_CourtCase AS B
  ON B.CourtCaseInstanceID = A.CourtCaseInstanceID
  WHERE B.MajorVersion = 28 AND  CaseNumber LIKE 'RCA 00006/2016/TGI/NYG'

DELETE FROM dbo.DE_CourtCase
WHERE CaseNumber LIKE 'RCA 00006/2016/TGI/NYG' AND MajorVersion > 28
------------------------------------------------------------------------------------------------------------

SELECT @dropAfterDelete += N'
ALTER TABLE ' +  QUOTENAME(cs.name) + '.' + QUOTENAME(ct.name) 
    + ' DROP CONSTRAINT ' + QUOTENAME(fk.name) + ';'
FROM sys.foreign_keys AS fk
INNER JOIN sys.tables AS ct
  ON fk.parent_object_id = ct.[object_id]
INNER JOIN sys.schemas AS cs 
  ON ct.[schema_id] = cs.[schema_id]
  INNER JOIN sys.tables rt ON fk.referenced_object_id = rt.object_id
  WHERE ct.name LIKE 'DE_CourtCase%'
  AND rt.name LIKE 'DE_CourtCase%'
UPDATE #x SET dropAfterDelete_script = @dropAfterDelete;


SELECT @createAfterDelete += N'
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
    FOR XML PATH(N''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 1, N'') + '); '
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
AND rt.name LIKE 'DE_CourtCase%'
AND ct.name LIKE 'DE_CourtCase%'
UPDATE #x SET createAfterDelete_script = @createAfterDelete;

--PRINT @dropAfterDelete
EXECUTE(@dropAfterDelete)

--PRINT @createAfterDelete
EXECUTE(@createAfterDelete)

DROP TABLE #x
GO

--bolor not null-ery sarqenq null
--DROP TABLE _test1 
CREATE TABLE _test1 (test TEXT)

DECLARE @sql4 NVARCHAR(MAX) = '' ;

SELECT 
@sql4 += 
' ALTER TABLE '+ QUOTENAME(Subqu.TableName) + 
' ALTER COLUMN '+ QUOTENAME(Subqu.Columnname) + ' '+ QUOTENAME(Subqu.Columntype) + CASE WHEN Subqu.maxLen IS NOT NULL AND Subqu.maxLen <>-1 THEN  '(' + CONVERT(VARCHAR , Subqu.maxLen) + ') ' WHEN Subqu.maxLen = -1 THEN  '( MAX ) '  ELSE  ' '  END +  ' NULL '
FROM (
SELECT 
	o.name AS TableName ,
    c.name AS Columnname ,
    t.Name AS Columntype ,
    c.is_nullable AS isnullable ,
    ISNULL(i.is_primary_key, 0) AS pk, 
	CHARACTER_MAXIMUM_LENGTH AS maxLen
FROM
    sys.columns c
INNER JOIN 
	INFORMATION_SCHEMA.COLUMNS ON COLUMNS.COLUMN_NAME = c.name AND COLUMNS.TABLE_NAME = OBJECT_NAME(c.object_id) 
INNER JOIN 
    sys.types t ON c.user_type_id = t.user_type_id
INNER JOIN 
	sys.objects o ON o.object_id = c.object_id
LEFT OUTER JOIN 
    sys.index_columns ic ON ic.object_id = c.object_id AND ic.column_id = c.column_id
LEFT OUTER JOIN 
    sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
WHERE
o.type_desc = 'USER_TABLE' AND ISNULL(i.is_primary_key, 0) = 0 AND c.is_nullable = 0 AND c.is_identity = 0
) AS Subqu

--PRINT @sql4

--EXEC(@sql4)

INSERT INTO dbo._test1
        ( test )
VALUES  ( @sql4 -- test - text
          )
SELECT *
FROM dbo._test1
DROP TABLE dbo._test1


--SELECT * FROM INFORMATION_SCHEMA.COLUMNS
------------------------------------------------------------------------------------------------------------------------------------------
--jnjuma bolor PK-ery

--CREATE TABLE _test (test TEXT)

DECLARE @sql1 nvarchar(max) = ''
SELECT
@sql1 = @sql1 + 
  ' ALTER TABLE ' + OBJECT_NAME(o.OBJECT_ID) + ' DROP CONSTRAINT ' + i.name 
FROM sys.indexes i
	INNER JOIN sys.objects o ON o.object_id = i.object_id
WHERE i.name IS NOT NULL AND o.type_desc = 'USER_TABLE' AND i.type_desc = 'CLUSTERED'

--INSERT INTO dbo._test
--        ( test )
--VALUES  ( @sql2 -- test - text
--          )
--SELECT *
--FROM dbo._test
--DROP TABLE dbo._test

exec (@sql1)

-----------------------------------------------------------------------------------------------------------------------------------------
--jnjenq unique constyraintnery
DECLARE @sql3 nvarchar(max) = ''
SELECT
@sql3 = @sql3 + 
  ' ALTER TABLE ' + OBJECT_NAME(o.OBJECT_ID) + ' DROP CONSTRAINT ' + i.name 
FROM sys.indexes i
	INNER JOIN sys.objects o ON o.object_id = i.object_id
WHERE i.name IS NOT NULL AND o.type_desc = 'USER_TABLE' AND i.is_unique_constraint = 1

EXEC(@sql3)

------------------------------------------------------------------------------------------------------------------------------------------
--jnjuma bolor index-ney (non-clustered)  [verevi scriptic heto kmnan miayn index-nery u stegh kberi henc dranq]


--CREATE TABLE _test (test TEXT)

DECLARE @sql2 nvarchar(max) = ''
SELECT
@sql2 = @sql2 + 
   ' DROP INDEX ' + OBJECT_NAME(o.OBJECT_ID) + '.' + i.name 
FROM sys.indexes i
	INNER JOIN sys.objects o ON o.object_id = i.object_id
WHERE i.name IS NOT NULL AND o.type_desc = 'USER_TABLE'

--INSERT INTO dbo._test
--        ( test )
--VALUES  ( @sql2 -- test - text
--          )
--SELECT *
--FROM dbo._test
--DROP TABLE dbo._test

exec (@sql2)

------------------------------------------------------------------------------------------------------------------------------------------
--bolor not null-ery sarqenq null

--CREATE TABLE _test (test TEXT)

DECLARE @sql4 NVARCHAR(MAX) = ''
SELECT 
@sql4 = @sql4+
' ALTER TABLE '+ QUOTENAME(Sub.TableName) + 
' ALTER COLUMN '+ QUOTENAME(Sub.Columnname) + ' '+ QUOTENAME(Sub.Columntype) + ' ' + 'NULL'
FROM (
SELECT 
	o.name AS TableName ,
    c.name AS Columnname ,
    t.Name AS Columntype ,
    c.is_nullable AS isnullable ,
    ISNULL(i.is_primary_key, 0) AS pk
FROM
    sys.columns c
INNER JOIN 
    sys.types t ON c.user_type_id = t.user_type_id
INNER JOIN 
	sys.objects o ON o.object_id = c.object_id
LEFT OUTER JOIN 
    sys.index_columns ic ON ic.object_id = c.object_id AND ic.column_id = c.column_id
LEFT OUTER JOIN 
    sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
WHERE
o.type_desc = 'USER_TABLE' AND ISNULL(i.is_primary_key, 0) = 0 AND c.is_nullable = 0 AND o.name <> 'sys_rel_secteur_user'
) AS Sub

EXEC(@sql4)

--INSERT INTO dbo._test
--        ( test )
--VALUES  ( @sql4 -- test - text
--          )
--SELECT *
--FROM dbo._test
--DROP TABLE dbo._test

------------------------------------------------------------------------------------------------------------------------------------

set @sql2 = substring(@sql, 1, len(@sql) - 6)
print @sql2

ALTER TABLE c_axe_princ
ALTER COLUMN abreviationAxePrinc NVARCHAR NULL



ALTER TABLE c_axe
DROP CONSTRAINT PK_c_axe_idAxe








/*
kveradardzni nranc voronq pk chen u not null en 
*/

SELECT 
	o.name AS TableName ,
    c.name AS Columnname ,
    t.Name AS Columntype ,
    c.is_nullable AS isnullable ,
    ISNULL(i.is_primary_key, 0) AS pk
FROM    
    sys.columns c
INNER JOIN 
    sys.types t ON c.user_type_id = t.user_type_id
INNER JOIN 
	sys.objects o ON o.object_id = c.object_id
LEFT OUTER JOIN 
    sys.index_columns ic ON ic.object_id = c.object_id AND ic.column_id = c.column_id
LEFT OUTER JOIN 
    sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
WHERE
o.type_desc = 'USER_TABLE' AND ISNULL(i.is_primary_key, 0) = 0 AND c.is_nullable = 0
    --c.object_id = OBJECT_ID('sys.objects.')
ORDER BY TableName


/*
kveradardzni bolor clustered indexnery
*/


SELECT 
  'ALTER TABLE ' + OBJECT_NAME(OBJECT_ID) + ' DROP CONSTRAINT ' + name 
FROM sys.indexes WHERE type_desc = 'CLUSTERED'



SELECT 
  'ALTER TABLE ' + OBJECT_NAME(o.OBJECT_ID) + ' DROP CONSTRAINT ' + i.name 
FROM sys.indexes i
	INNER JOIN sys.objects o ON o.object_id = i.object_id
WHERE i.name IS NOT NULL AND o.type_desc = 'USER_TABLE'






DROP INDEX c_axe.index_2


SELECT   ' DROP INDEX ' + OBJECT_NAME(o.OBJECT_ID) + '.' + i.name 
FROM sys.indexes i
	INNER JOIN sys.objects o ON o.object_id = i.object_id
WHERE i.name IS NOT NULL AND o.type_desc = 'USER_TABLE'


SELECT i.name AS index_name  
    ,i.type_desc  
    ,is_unique  
    ,ds.type_desc AS filegroup_or_partition_scheme  
    ,ds.name AS filegroup_or_partition_scheme_name  
    ,ignore_dup_key  
    ,is_primary_key  
    ,is_unique_constraint  
    ,fill_factor  
    ,is_padded  
    ,is_disabled  
    ,allow_row_locks  
    ,allow_page_locks  
FROM sys.indexes AS i  
INNER JOIN sys.data_spaces AS ds ON i.data_space_id = ds.data_space_id  
--WHERE is_hypothetical = 0 AND i.index_id <> 0   
--AND i.object_id = OBJECT_ID('Production.Product');  
GO 

SELECT
' ALTER TABLE '+ QUOTENAME(Sub.TableName) + 
' ALTER COLUMN '+ QUOTENAME(Sub.Columnname) + ' '+ QUOTENAME(Sub.Columntype) + ' ' + 'NULL'
FROM (
SELECT *
	--o.name AS TableName ,
 --   c.name AS Columnname ,
 --   t.Name AS Columntype ,
 --   c.is_nullable AS isnullable ,
 --   ISNULL(i.is_primary_key, 0) AS pk
FROM    
    sys.columns c
INNER JOIN 
    sys.types t ON c.user_type_id = t.user_type_id
INNER JOIN 
	sys.objects o ON o.object_id = c.object_id
LEFT OUTER JOIN 
    sys.index_columns ic ON ic.object_id = c.object_id AND ic.column_id = c.column_id
LEFT OUTER JOIN 
    sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
WHERE
o.type_desc = 'USER_TABLE' AND ISNULL(i.is_primary_key, 0) = 0 AND c.is_nullable = 0 AND t.name = 'IDENTITY(1,1)'
) AS Sub

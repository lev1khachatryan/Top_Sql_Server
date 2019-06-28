
DECLARE @sql AS NVARCHAR(MAX) = N''
--SELECT c.name , sub.name , t.name
SELECT @sql += '
EXEC sys.sp_rename @objname = ''' + sub.name + '.Name'',
    @newname = ''Name_ENG'',
    @objtype = ''COLUMN''
'
FROM sys.columns AS c
JOIN
(
SELECT object_id , name
FROM sys.tables
WHERE name LIKE 'C!_%' ESCAPE '!'
) AS sub
ON sub.object_id = c.object_id
JOIN sys.types AS t ON t.user_type_id = c.user_type_id
WHERE t.name LIKE '%char%' 
AND sub.name NOT IN
( 'C_User',
'C_Role',
'C_Group',
'C_DummyParty'
)
AND c.name = 'Name'
EXEC (@sql)
------------------------------------------------------------------------
DECLARE @sql1 AS NVARCHAR(MAX) = N''
--SELECT c.name , sub.name , t.name
--SELECT c.name , sub.name , t.name , c.max_length /2
SELECT @sql1 += '
ALTER TABLE dbo.' + sub.name + '
ADD Name_KRW NVARCHAR('  + CAST( c.max_length AS NVARCHAR(10) ) + ')
'
FROM sys.columns AS c
JOIN
(
SELECT object_id , name
FROM sys.tables
WHERE name LIKE 'C!_%' ESCAPE '!'
) AS sub
ON sub.object_id = c.object_id
JOIN sys.types AS t ON t.user_type_id = c.user_type_id
WHERE t.name LIKE '%char%' 
AND sub.name NOT IN
( 'C_User',
'C_Role',
'C_Group',
'C_DummyParty'
--'C_WFProcesses'
)
AND c.name = 'Name_ENG'
EXEC (@sql1)

ALTER TABLE dbo.Document
ADD Title_KRW NVARCHAR(500)

ALTER TABLE dbo.Document
ADD Description_KRW NVARCHAR(500)

ALTER TABLE dbo.C_User
ADD Name_KRW NVARCHAR(500)

---
---
--- Export Classifiers
---
---

--CREATE TABLE #TableNames(
--	TableName NVARCHAR(250)
--)
--INSERT INTO #TableNames
--        ( TableName )
--SELECT sub.name
--FROM sys.columns AS c
--JOIN (
--SELECT object_id , name
--FROM sys.tables
--WHERE name LIKE 'C!_%' ESCAPE '!'
--AND name NOT IN
--( 'C_User',
--'C_Role',
--'C_Group',
--'C_DummyParty'
----'C_WFProcesses'
--)
--) AS sub
--ON sub.object_id = c.object_id
--WHERE
--c.name = 'Name_KRW'

--CREATE INDEX i1 ON #TableNames(TableName)

--DECLARE @var AS NVARCHAR(MAX) = N'';
--SELECT @var += '
--SELECT Name_ENG
--FROM dbo.' + TableName + '
--'
--FROM #TableNames
--EXEC (@var);

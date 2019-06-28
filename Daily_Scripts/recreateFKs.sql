DROP TABLE #TEMP

CREATE TABLE #temp
(
DropStmt NVARCHAR(MAX),
CreateStmt NVARCHAR(MAX),
ForeignTableName NVARCHAR(500),
Name NVARCHAR(500),
rnbm INT
)

;WITH cte
AS
(
SELECT
  DropStmt = 'ALTER TABLE [' + ForeignKeys.ForeignTableSchema + 
      '].[' + ForeignKeys.ForeignTableName + 
      '] DROP CONSTRAINT [' + ForeignKeys.ForeignKeyName + ']; '
,  CreateStmt = 'ALTER TABLE [' + ForeignKeys.ForeignTableSchema + 
      '].[' + ForeignKeys.ForeignTableName + 
      '] WITH CHECK ADD CONSTRAINT [' +  ForeignKeys.ForeignKeyName + 
      '] FOREIGN KEY([' + ForeignKeys.ForeignTableColumn + 
      ']) REFERENCES [' + schema_name(sys.objects.schema_id) + '].[' +
  sys.objects.[name] + ']([' +
  sys.columns.[name] + ']) ON DELETE CASCADE; '
,ForeignKeys.ForeignTableName
,sys.objects.name
,ROW_NUMBER() OVER(PARTITION BY ForeignKeys.ForeignTableName , sys.objects.name ORDER BY ForeignKeys.ForeignTableName , sys.objects.name) AS rnmb
 from sys.objects
  inner join sys.columns
    on (sys.columns.[object_id] = sys.objects.[object_id])
  inner join (
    select sys.foreign_keys.[name] as ForeignKeyName
     ,schema_name(sys.objects.schema_id) as ForeignTableSchema
     ,sys.objects.[name] as ForeignTableName
     ,sys.columns.[name]  as ForeignTableColumn
     ,sys.foreign_keys.referenced_object_id as referenced_object_id
     ,sys.foreign_key_columns.referenced_column_id as referenced_column_id
     from sys.foreign_keys
      inner join sys.foreign_key_columns
        on (sys.foreign_key_columns.constraint_object_id
          = sys.foreign_keys.[object_id])
      inner join sys.objects
        on (sys.objects.[object_id]
          = sys.foreign_keys.parent_object_id)
        inner join sys.columns
          on (sys.columns.[object_id]
            = sys.objects.[object_id])
           and (sys.columns.column_id
            = sys.foreign_key_columns.parent_column_id)
		WHERE sys.foreign_keys.delete_referential_action_desc <> 'CASCADE'
    ) ForeignKeys
    on (ForeignKeys.referenced_object_id = sys.objects.[object_id])
     and (ForeignKeys.referenced_column_id = sys.columns.column_id)
 where (sys.objects.[type] = 'U') AND 
 --(
 --ForeignKeys.ForeignTableName LIKE 'Activity%' OR 
 --ForeignKeys.ForeignTableName LIKE 'DE!_Activity%' ESCAPE '!' OR
 --ForeignKeys.ForeignTableName LIKE 'DE!_Deliverable%' ESCAPE '!' OR
 --ForeignKeys.ForeignTableName LIKE 'Deliverable%' OR
 --ForeignKeys.ForeignTableName LIKE 'DE!_DonorAgreement%' ESCAPE '!' OR
 --ForeignKeys.ForeignTableName LIKE 'DonorAgreement%' OR
 --ForeignKeys.ForeignTableName LIKE 'DE!_FrameworkLevelName%' ESCAPE '!' OR
 --ForeignKeys.ForeignTableName LIKE 'FrameworkLevelName%' OR
 --ForeignKeys.ForeignTableName LIKE 'DE!_Indicator%' ESCAPE '!' OR
 --ForeignKeys.ForeignTableName LIKE 'Indicator%' OR
 --ForeignKeys.ForeignTableName LIKE 'DE!_PlanResultFramework%' ESCAPE '!' OR
 --ForeignKeys.ForeignTableName LIKE 'PlanResultFramework%' OR
 --ForeignKeys.ForeignTableName LIKE 'DE!_Programme%' ESCAPE '!' OR
 --ForeignKeys.ForeignTableName LIKE 'Programme%' OR
 --ForeignKeys.ForeignTableName LIKE 'DE!_Project%' ESCAPE '!' OR
 --ForeignKeys.ForeignTableName LIKE 'Project%' OR
 --ForeignKeys.ForeignTableName LIKE 'Master%' OR
 --ForeignKeys.ForeignTableName LIKE 'C!_IRRMFL%' ESCAPE '!' OR
 --ForeignKeys.ForeignTableName LIKE 'C!_RRFL%' ESCAPE '!' 
 --)
 --AND (
 --( sys.objects.name LIKE 'C!_IRRMFL%' ESCAPE '!' OR
 --sys.objects.name LIKE 'C!_RRFL%' ESCAPE '!' ) OR sys.objects.name NOT LIKE 'C!_%' ESCAPE '!'
 --) 
 --AND
 ForeignKeys.ForeignTableName LIKE 'DE!_%' ESCAPE '!' AND
 sys.objects.name LIKE 'DE!_%' ESCAPE '!'
 
  --AND (ForeignKeys.ForeignTableName NOT LIKE 'C!_%' ESCAPE '!' OR ForeignKeys.ForeignTableName LIKE 'C!_IRRMFL%' ESCAPE '!'
		--OR ForeignKeys.ForeignTableName LIKE 'C!_RRF%' ESCAPE '!') AND sys.objects.name NOT LIKE 'C!_%' ESCAPE '!'

  --and (sys.objects.[name] in ('C_role'))
--ORDER BY ForeignKeys.ForeignTableName, sys.objects.name
)
INSERT INTO dbo.#temp
        ( DropStmt ,
          CreateStmt ,
          ForeignTableName ,
          Name ,
          rnbm
        )
SELECT cte.DropStmt ,
       cte.CreateStmt ,
       cte.ForeignTableName ,
       cte.name ,
       cte.rnmb
FROM cte

SELECT *
FROM dbo.#temp
EXCEPT
SELECT *
FROM dbo.#temp
WHERE rnbm = 1


SELECT   
    f.name AS foreign_key_name  
   ,OBJECT_NAME(f.parent_object_id) AS table_name  
   ,COL_NAME(fc.parent_object_id, fc.parent_column_id) AS constraint_column_name  
   ,OBJECT_NAME (f.referenced_object_id) AS referenced_object  
   ,COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS referenced_column_name  
   ,is_disabled  
   ,delete_referential_action_desc  
   ,update_referential_action_desc  
FROM sys.foreign_keys AS f  
INNER JOIN sys.foreign_key_columns AS fc   
   ON f.object_id = fc.constraint_object_id   
WHERE f.delete_referential_action_desc = 'CASCADE'
ORDER BY table_name , referenced_object

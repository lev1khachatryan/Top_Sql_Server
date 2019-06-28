
CREATE TABLE #Field2
(
FieldID INT
)
INSERT INTO #Field2
        ( FieldID )
SELECT f.FieldID
-- c.CategoryApiName, f.FieldApiName, f.FieldKindVariationID,kv.FieldKindVariationName, im.ResultSetName
--, fc.FunctionalApiName
FROM dbo.KB_Categories c
JOIN dbo.KB_Fields f ON c.CategoryID = f.OwnerCategoryID
JOIN KB_C_FieldKindVariations kv ON f.FieldKindVariationID = kv.FieldKindVariationID
JOIN dbo.KB_Items i ON c.CategoryID = i.ItemID
JOIN dbo.KB_ItemMappings im ON im.ItemID = i.ItemID
--JOIN dbo.KB_Functionals fc ON fc.OwnerCategoryID = c.CategoryID
WHERE c.WorkingCopyID = -1
AND f.WorkingCopyID = -1
AND im.WorkingCopyID = -1
AND im.ResultSetName NOT LIKE 'C!_%' ESCAPE '!'
AND f.FieldKindVariationID = 4
--AND fc.WorkingCopyID = -1
--AND fc.FunctionalApiName NOT LIKE 's!_%' ESCAPE '!'
UNION
SELECT fd.FieldID
--, f.FunctionalApiName, fd.FieldApiName , *
FROM dbo.KB_Functionals f
JOIN dbo.KB_Fields fd ON fd.OwnerFunctionalID = f.FunctionalID AND fd.WorkingCopyID = f.WorkingCopyID
JOIN KB_C_FieldKindVariations kv ON kv.FieldKindVariationID = fd.FieldKindVariationID
WHERE f.FunctionalApiName NOT LIKE 's!_%' ESCAPE '!'
AND f.WorkingCopyID = -1
AND kv.FieldKindVariationID = 4


CREATE TABLE #Field3
(
FieldID INT
)
INSERT INTO #Field3
        ( FieldID )
SELECT f.FieldID
-- c.CategoryApiName, f.FieldApiName, f.FieldKindVariationID,kv.FieldKindVariationName, im.ResultSetName
--, fc.FunctionalApiName
FROM dbo.KB_Categories c
JOIN dbo.KB_Fields f ON c.CategoryID = f.OwnerCategoryID
JOIN KB_C_FieldKindVariations kv ON f.FieldKindVariationID = kv.FieldKindVariationID
JOIN dbo.KB_Items i ON c.CategoryID = i.ItemID
JOIN dbo.KB_ItemMappings im ON im.ItemID = i.ItemID
--JOIN dbo.KB_Functionals fc ON fc.OwnerCategoryID = c.CategoryID
WHERE c.WorkingCopyID = -1
AND f.WorkingCopyID = -1
AND im.WorkingCopyID = -1
AND im.ResultSetName NOT LIKE 'C!_%' ESCAPE '!'
AND f.FieldKindVariationID = 5
--AND fc.WorkingCopyID = -1
--AND fc.FunctionalApiName NOT LIKE 's!_%' ESCAPE '!'
UNION 
SELECT fd.FieldID
--, f.FunctionalApiName, fd.FieldApiName , *
FROM dbo.KB_Functionals f
JOIN dbo.KB_Fields fd ON fd.OwnerFunctionalID = f.FunctionalID AND fd.WorkingCopyID = f.WorkingCopyID
JOIN KB_C_FieldKindVariations kv ON kv.FieldKindVariationID = fd.FieldKindVariationID
WHERE f.FunctionalApiName NOT LIKE 's!_%' ESCAPE '!'
AND f.WorkingCopyID = -1
AND kv.FieldKindVariationID = 5

UPDATE Fi
SET Fi.FieldKindVariationID = 3
FROM dbo.KB_Fields AS Fi
JOIN #Field3 ON #Field3.FieldID = Fi.FieldID

UPDATE FiM
SET FiM.ColumnKey = 'singleText'
FROM dbo.KB_FieldMappings AS FiM
JOIN #Field3 ON #Field3.FieldID = FiM.FieldID

UPDATE Fi
SET Fi.FieldKindVariationID = 2
FROM dbo.KB_Fields AS Fi
JOIN #Field2 ON #Field2.FieldID = Fi.FieldID

UPDATE FiM
SET FiM.ColumnKey = 'singleText'
FROM dbo.KB_FieldMappings AS FiM
JOIN #Field2 ON #Field2.FieldID = FiM.FieldID

DROP TABLE #Field2
DROP TABLE #Field3

---
---
---
---

UPDATE fm
SET fm.ColumnName = 'Name_ENG'
FROM dbo.KB_Categories c
JOIN dbo.KB_Fields f ON c.CategoryID = f.OwnerCategoryID
JOIN KB_C_FieldKindVariations kv ON f.FieldKindVariationID = kv.FieldKindVariationID
JOIN dbo.KB_Items i ON c.CategoryID = i.ItemID
JOIN dbo.KB_ItemMappings im ON im.ItemID = i.ItemID
--JOIN dbo.KB_Functionals fc ON fc.OwnerCategoryID = c.CategoryID
JOIN dbo.KB_FieldMappings AS fm ON fm.FieldID = f.FieldID
WHERE c.WorkingCopyID = -1
AND f.WorkingCopyID = -1
AND im.WorkingCopyID = -1
AND im.ResultSetName LIKE 'C!_%' ESCAPE '!'
AND f.FieldKindVariationID = 4
AND fm.ColumnName = 'Name'

---
---
---
---


CREATE TABLE #Field3NotName
(
FieldID INT
)
INSERT #Field3NotName
        ( FieldID )
SELECT f.FieldID
-- c.CategoryApiName, f.FieldApiName, f.FieldKindVariationID,kv.FieldKindVariationName, im.ResultSetName
--, fc.FunctionalApiName
FROM dbo.KB_Categories c
JOIN dbo.KB_Fields f ON c.CategoryID = f.OwnerCategoryID
JOIN KB_C_FieldKindVariations kv ON f.FieldKindVariationID = kv.FieldKindVariationID
JOIN dbo.KB_Items i ON c.CategoryID = i.ItemID
JOIN dbo.KB_ItemMappings im ON im.ItemID = i.ItemID
--JOIN dbo.KB_Functionals fc ON fc.OwnerCategoryID = c.CategoryID
JOIN dbo.KB_FieldMappings AS FiM ON FiM.FieldID = f.FieldID
WHERE c.WorkingCopyID = -1
AND f.WorkingCopyID = -1
AND im.WorkingCopyID = -1
AND im.ResultSetName LIKE 'C!_%' ESCAPE '!'
AND f.FieldKindVariationID = 4
AND FiM.ColumnName NOT LIKE 'Name%'


UPDATE Fi
SET Fi.FieldKindVariationID = 3
FROM dbo.KB_Fields AS Fi
JOIN #Field3NotName ON #Field3NotName.FieldID = Fi.FieldID

UPDATE FiM
SET FiM.ColumnKey = 'singleText'
FROM dbo.KB_FieldMappings AS FiM
JOIN #Field3NotName ON #Field3NotName.FieldID = FiM.FieldID

CREATE TABLE #Field2NotName
(
FieldID INT
)
INSERT #Field2NotName
        ( FieldID )
SELECT f.FieldID
-- c.CategoryApiName, f.FieldApiName, f.FieldKindVariationID,kv.FieldKindVariationName, im.ResultSetName
--, fc.FunctionalApiName
FROM dbo.KB_Categories c
JOIN dbo.KB_Fields f ON c.CategoryID = f.OwnerCategoryID
JOIN KB_C_FieldKindVariations kv ON f.FieldKindVariationID = kv.FieldKindVariationID
JOIN dbo.KB_Items i ON c.CategoryID = i.ItemID
JOIN dbo.KB_ItemMappings im ON im.ItemID = i.ItemID
--JOIN dbo.KB_Functionals fc ON fc.OwnerCategoryID = c.CategoryID
JOIN dbo.KB_FieldMappings AS FiM ON FiM.FieldID = f.FieldID
WHERE c.WorkingCopyID = -1
AND f.WorkingCopyID = -1
AND im.WorkingCopyID = -1
AND im.ResultSetName LIKE 'C!_%' ESCAPE '!'
AND f.FieldKindVariationID = 5
AND FiM.ColumnName NOT LIKE 'Name%'


UPDATE Fi
SET Fi.FieldKindVariationID = 3
FROM dbo.KB_Fields AS Fi
JOIN #Field2NotName ON #Field2NotName.FieldID = Fi.FieldID

UPDATE FiM
SET FiM.ColumnKey = 'singleText'
FROM dbo.KB_FieldMappings AS FiM
JOIN #Field2NotName ON #Field2NotName.FieldID = FiM.FieldID

---
---
---
---

INSERT INTO dbo.KB_FieldMappings
        ( FieldID ,
          WorkingCopyID ,
          ColumnName ,
          ColumnSqlType ,
          ColumnKey
        )
SELECT DISTINCT f.FieldID , -1 , 'Name_KRW' , 'nvarchar' , 'KRW'
FROM dbo.KB_Categories c
JOIN dbo.KB_Fields f ON c.CategoryID = f.OwnerCategoryID
JOIN KB_C_FieldKindVariations kv ON f.FieldKindVariationID = kv.FieldKindVariationID
JOIN dbo.KB_Items i ON c.CategoryID = i.ItemID
JOIN dbo.KB_ItemMappings im ON im.ItemID = i.ItemID
--JOIN dbo.KB_Functionals fc ON fc.OwnerCategoryID = c.CategoryID
JOIN dbo.KB_FieldMappings AS fm ON fm.FieldID = f.FieldID
WHERE c.WorkingCopyID = -1
AND f.WorkingCopyID = -1
AND im.WorkingCopyID = -1
AND im.ResultSetName LIKE 'C!_%' ESCAPE '!'
AND f.FieldKindVariationID = 4
AND fm.ColumnName LIKE 'Name%'

INSERT INTO dbo.KB_FieldMappings
        ( FieldID ,
          WorkingCopyID ,
          ColumnName ,
          ColumnSqlType ,
          ColumnKey
        )
SELECT DISTINCT f.FieldID , 7 , 'Name_KRW' , 'nvarchar' , 'KRW'
FROM dbo.KB_Categories c
JOIN dbo.KB_Fields f ON c.CategoryID = f.OwnerCategoryID
JOIN KB_C_FieldKindVariations kv ON f.FieldKindVariationID = kv.FieldKindVariationID
JOIN dbo.KB_Items i ON c.CategoryID = i.ItemID
JOIN dbo.KB_ItemMappings im ON im.ItemID = i.ItemID
--JOIN dbo.KB_Functionals fc ON fc.OwnerCategoryID = c.CategoryID
JOIN dbo.KB_FieldMappings AS fm ON fm.FieldID = f.FieldID
WHERE c.WorkingCopyID = -1
AND f.WorkingCopyID = -1
AND im.WorkingCopyID = -1
AND im.ResultSetName LIKE 'C!_%' ESCAPE '!'
AND f.FieldKindVariationID = 4
AND fm.ColumnName LIKE 'Name%'


INSERT INTO dbo.KB_FieldMappings
        ( FieldID ,
          WorkingCopyID ,
          ColumnName ,
          ColumnSqlType ,
          ColumnKey
        )
SELECT DISTINCT f.FieldID , -1 , 'Name_KRW' , 'nvarchar' , 'KRW'
FROM dbo.KB_Categories c
JOIN dbo.KB_Fields f ON c.CategoryID = f.OwnerCategoryID
JOIN KB_C_FieldKindVariations kv ON f.FieldKindVariationID = kv.FieldKindVariationID
JOIN dbo.KB_Items i ON c.CategoryID = i.ItemID
JOIN dbo.KB_ItemMappings im ON im.ItemID = i.ItemID
--JOIN dbo.KB_Functionals fc ON fc.OwnerCategoryID = c.CategoryID
JOIN dbo.KB_FieldMappings AS fm ON fm.FieldID = f.FieldID
WHERE c.WorkingCopyID = -1
AND f.WorkingCopyID = -1
AND im.WorkingCopyID = -1
AND im.ResultSetName LIKE 'C!_%' ESCAPE '!'
AND f.FieldKindVariationID = 5
AND fm.ColumnName LIKE 'Name%'

INSERT INTO dbo.KB_FieldMappings
        ( FieldID ,
          WorkingCopyID ,
          ColumnName ,
          ColumnSqlType ,
          ColumnKey
        )
SELECT DISTINCT f.FieldID , 7 , 'Name_KRW' , 'nvarchar' , 'KRW'
FROM dbo.KB_Categories c
JOIN dbo.KB_Fields f ON c.CategoryID = f.OwnerCategoryID
JOIN KB_C_FieldKindVariations kv ON f.FieldKindVariationID = kv.FieldKindVariationID
JOIN dbo.KB_Items i ON c.CategoryID = i.ItemID
JOIN dbo.KB_ItemMappings im ON im.ItemID = i.ItemID
--JOIN dbo.KB_Functionals fc ON fc.OwnerCategoryID = c.CategoryID
JOIN dbo.KB_FieldMappings AS fm ON fm.FieldID = f.FieldID
WHERE c.WorkingCopyID = -1
AND f.WorkingCopyID = -1
AND im.WorkingCopyID = -1
AND im.ResultSetName LIKE 'C!_%' ESCAPE '!'
AND f.FieldKindVariationID = 5
AND fm.ColumnName LIKE 'Name%'


UPDATE  a
SET a.FieldName = 'Izina'
FROM dbo.KB_FieldNames AS a
WHERE FieldName LIKE '%![krw!]Name%' ESCAPE '!'
GO

--
--
-- orderingy dzogh scripty run tveci
--
--





--
--MRT-ic berac sp e
--
GO
CREATE  PROCEDURE [dbo].[up_DE_I_Message]
    @WorkingCopyID INT ,
    @RangeStart INT ,
    @RangeEnd INT ,
    @RangeMinValue INT
AS
    BEGIN
    
        SET NOCOUNT ON
        IF @RangeStart <= @RangeEnd
            AND @RangeStart >= @RangeMinValue
            AND @RangeEnd >= @RangeMinValue
            AND @RangeStart >= 0
            AND @RangeEnd >= 0
            BEGIN 
		;
                WITH    cte ( n )
                          AS ( SELECT   @RangeStart
                               UNION ALL
                               SELECT   n + 1
                               FROM     cte
                               WHERE    n < @RangeEnd
                             )
                    MERGE dbo.DE_Messages D
                    USING
                        ( SELECT    cte.n AS MessageID ,
                                    l.LanguageID AS LanguageID ,
                                    CAST(cte.n AS NVARCHAR) AS MessageText ,
                                    @WorkingCopyID AS WorkingCopyID
                          FROM      cte
                                    CROSS JOIN ( SELECT LanguageID
                                                 FROM   dbo.KB_C_Languages
                                               ) l
                        ) S
                    ON D.MessageID = S.MessageID
                        AND D.LanguageID = S.LanguageID
                        AND D.WorkingCopyID = S.WorkingCopyID
                    WHEN NOT MATCHED THEN
                        INSERT ( MessageID ,
                                 LanguageID ,
                                 MessageText ,
                                 WorkingCopyID 
                               )
                        VALUES ( S.MessageID ,
                                 S.LanguageID ,
                                 S.MessageText ,
                                 S.WorkingCopyID
                               )
                    OPTION
                        ( MAXRECURSION 0 ) ; 
    
            END
        ELSE
            BEGIN 
                PRINT 'Range Start/End is not in predefined scope'
            END 
    END
GO




----
----
----Measures and Categories
----
----

--SELECT DISTINCT MeasureID , RTRIM(LTRIM(REPLACE(MeasureName ,'[krw]' , ''))) AS Name
--FROM dbo.KB_MeasureNames
--WHERE MeasureName LIKE '![krw!]%' ESCAPE '!'
--ORDER BY Name

--SELECT DISTINCT MeasureID , RTRIM(LTRIM(REPLACE(UserDefinedName ,'[krw]' , ''))) AS Name
--FROM dbo.KB_MeasureNames
--WHERE UserDefinedName LIKE '![krw!]%' ESCAPE '!'
--ORDER BY Name

--SELECT DISTINCT CategoryID , RTRIM(LTRIM(REPLACE(CategoryName ,'[krw]' , ''))) AS Name
--FROM dbo.KB_CategoryNames
--WHERE CategoryName LIKE '![krw!]%' ESCAPE '!'
--ORDER BY Name

--SELECT DISTINCT ExpressionID , RTRIM(LTRIM(REPLACE(ExpressionName ,'[krw]' , ''))) AS Name
--FROM dbo.KB_ExpressionNames
--WHERE ExpressionName LIKE '![krw!]%' ESCAPE '!'
--ORDER BY Name

--SELECT DISTINCT GroupID , RTRIM(LTRIM(REPLACE(GroupName ,'[krw]' , ''))) AS Name
--FROM dbo.UI_GroupNames
--WHERE GroupName LIKE '![krw!]%' ESCAPE '!'
--ORDER BY Name

--SELECT DISTINCT ExpressionUserDefinedID , RTRIM(LTRIM(REPLACE(ExpressionUserDefinedName ,'[krw]' , ''))) AS Name
--FROM dbo.KB_ExpressionUserDefinedNames
--WHERE ExpressionUserDefinedName LIKE '![krw!]%' ESCAPE '!'
--ORDER BY Name

--SELECT DISTINCT PathID , RTRIM(LTRIM(REPLACE(PathName ,'[krw]' , ''))) AS Name
--FROM dbo.KB_PathNames
--WHERE PathName LIKE '![krw!]%' ESCAPE '!'
--ORDER BY Name

--SELECT DISTINCT SubTabID , RTRIM(LTRIM(REPLACE(SubTabTitle ,'[krw]' , ''))) AS Name
--FROM dbo.UI_SubTabNames
--WHERE SubTabTitle LIKE '![krw!]%' ESCAPE '!'
--ORDER BY Name

--SELECT DISTINCT TabID , RTRIM(LTRIM(REPLACE(TabTitle ,'[krw]' , ''))) AS Name
--FROM dbo.UI_TabNames
--WHERE TabTitle LIKE '![krw!]%' ESCAPE '!'
--ORDER BY Name

--SELECT DISTINCT DatasetID , RTRIM(LTRIM(REPLACE(DatasetName ,'[krw]' , ''))) AS Name
--FROM dbo.KB_DatasetNames
--WHERE DatasetName LIKE '![krw!]%' ESCAPE '!'
--ORDER BY Name

--SELECT DISTINCT FunctionalID , RTRIM(LTRIM(REPLACE(FunctionalName ,'[krw]' , ''))) AS Name
--FROM dbo.KB_FunctionalNames
--WHERE FunctionalName LIKE '![krw!]%' ESCAPE '!'
--ORDER BY Name

--SELECT DISTINCT FieldID , RTRIM(LTRIM(REPLACE(FieldName ,'[krw]' , ''))) AS Name
--FROM dbo.KB_FieldNames
--WHERE FieldName LIKE '![krw!]%' ESCAPE '!'
--ORDER BY Name

--SELECT DISTINCT MessageValueID , RTRIM(LTRIM(REPLACE(MessageValue ,'[krw]' , ''))) AS Name
--FROM dbo.KB_C_MessageValues
--WHERE MessageValue LIKE '![krw!]%' ESCAPE '!'
--ORDER BY Name



----DE-messages-ic

--SELECT MessageID , RTRIM(LTRIM(MessageText)) AS Name
--FROM dbo.DE_Messages
--WHERE LanguageID = 3 AND WorkingCopyID = -1
--AND MessageText LIKE '%--%'


--SELECT sub2.MessageID , CASE WHEN LEFT(sub2.Name , 1) = '-' THEN RTRIM(LTRIM( SUBSTRING(sub2.Name , 2 , LEN(sub2.Name)-1))) ELSE sub2.Name END AS name
--FROM 
--(
--SELECT sub.MessageID , CASE WHEN LEFT(sub.Name , 1) = '-' THEN RTRIM(LTRIM( SUBSTRING(sub.Name , 2 , LEN(sub.Name)-1))) ELSE sub.Name END AS name
--FROM 
--(
--SELECT MessageID ,  RTRIM(LTRIM(MessageText)) AS Name
--FROM dbo.DE_Messages
--WHERE LanguageID = 3 AND WorkingCopyID = -1
--) AS sub
--) AS sub2


-----
-----

--SELECT *
--FROM dbo.DE_Messages


--UPDATE T
--SET T.MeasureName = Newname
--FROM dbo.KB_MeasureNames T
--JOIN dbo._one ON MeasureID = ID
--WHERE T.MeasureName LIKE '![krw!]%' ESCAPE '!'

----UPDATE T
----SET T.UserDefinedName = 5
----FROM dbo.KB_MeasureNames T
----JOIN dbo._one ON MeasureID = ID
------WHERE T.MeasureName LIKE '![krw!]%' ESCAPE '!'
----WHERE T.MeasureName = '1'

--UPDATE T
--SET T.CategoryName = NewName
--FROM dbo.KB_CategoryNames AS T
--JOIN dbo._Two ON CategoryID = ID
--WHERE CategoryName LIKE '![krw!]%' ESCAPE '!'

--UPDATE T
--SET T.GroupName = NewName
--FROM dbo.UI_GroupNames AS T
--JOIN dbo._Four ON T.GroupID = ID
--WHERE T.GroupName LIKE '![krw!]%' ESCAPE '!'

--UPDATE T
--SET T.ExpressionName = NewName
--FROM dbo.KB_ExpressionNames AS T
--JOIN dbo._Three ON T.ExpressionID = ID
--WHERE T.ExpressionName LIKE '![krw!]%' ESCAPE '!'

--UPDATE T
--SET T.ExpressionUserDefinedName = NewName
--FROM dbo.KB_ExpressionUserDefinedNames AS T
--JOIN dbo._six ON T.ExpressionUserDefinedID = ID
--WHERE ExpressionUserDefinedName LIKE '![krw!]%' ESCAPE '!'

--UPDATE T
--SET T.PathName = NewName,
--	T.UserDefinedName = NewName
--FROM dbo.KB_PathNames AS T
--JOIN dbo._seven ON T.PathID = ID
--WHERE T.PathName LIKE '![krw!]%' ESCAPE '!'

--UPDATE T
--SET T.SubTabTitle = NewName
--FROM dbo.UI_SubTabNames AS T
--JOIN dbo._eight ON T.SubTabID = ID
--WHERE T.SubTabTitle LIKE '![krw!]%' ESCAPE '!'

--UPDATE T
--SET T.TabTitle = NewName
--FROM dbo.UI_TabNames AS T
--JOIN dbo._Nine ON T.TabID = ID
--WHERE T.TabTitle LIKE '![krw!]%' ESCAPE '!'

--UPDATE T
--SET T.DatasetName = NewName
--FROM dbo.KB_DatasetNames AS T
--JOIN dbo._ten ON ID = DatasetID
--WHERE T.DatasetName LIKE '![krw!]%' ESCAPE '!'

--UPDATE T
--SET T.FunctionalName = NewName
--FROM dbo.KB_FunctionalNames AS T
--JOIN dbo._FuncNames ON T.FunctionalID = ID 
--WHERE T.FunctionalName LIKE '![krw!]%' ESCAPE '!'

--UPDATE T
--SET T.FieldName = NewName
--FROM dbo.KB_FieldNames AS T
--JOIN dbo._FieldNames ON T.FieldID = ID 
--WHERE T.FieldName LIKE '![krw!]%' ESCAPE '!'

--UPDATE T
--SET T.MessageValue = 222
--FROM KB_C_MessageValues AS T
--WHERE MessageValue LIKE '![krw!]%' ESCAPE '!' 


SELECT ddxk1.[Refrenced table]
FROM (

SELECT
    --fk.name 'FK Name',
    --tp.name 'Parent table',
    --cp.name, cp.column_id,
    DISTINCT tr.name 'Refrenced table'
    --cr.name, cr.column_id
FROM 
    sys.foreign_keys fk
INNER JOIN 
    sys.tables tp ON fk.parent_object_id = tp.object_id
INNER JOIN 
    sys.tables tr ON fk.referenced_object_id = tr.object_id
INNER JOIN 
    sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
INNER JOIN 
    sys.columns cp ON fkc.parent_column_id = cp.column_id AND fkc.parent_object_id = cp.object_id
INNER JOIN 
    sys.columns cr ON fkc.referenced_column_id = cr.column_id AND fkc.referenced_object_id = cr.object_id
--WHERE tr.name = 'DE_CourtCase' AND cp.name = 'CategoryID'
WHERE tp.name LIKE 'DE_Exec%' AND tr.name LIKE 'C!_%' ESCAPE '!'
--ORDER BY
--    tp.name, cp.column_id

EXCEPT

SELECT
    --fk.name 'FK Name',
    --tp.name 'Parent table',
    --cp.name, cp.column_id,
    DISTINCT tr.name 'Refrenced table'
    --cr.name, cr.column_id
FROM 
    sys.foreign_keys fk
INNER JOIN 
    sys.tables tp ON fk.parent_object_id = tp.object_id
INNER JOIN 
    sys.tables tr ON fk.referenced_object_id = tr.object_id
INNER JOIN 
    sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
INNER JOIN 
    sys.columns cp ON fkc.parent_column_id = cp.column_id AND fkc.parent_object_id = cp.object_id
INNER JOIN 
    sys.columns cr ON fkc.referenced_column_id = cr.column_id AND fkc.referenced_object_id = cr.object_id
--WHERE tr.name = 'DE_CourtCase' AND cp.name = 'CategoryID'
WHERE tp.name not LIKE 'DE_Exec%' AND tr.name LIKE 'C!_%' ESCAPE '!'
) AS ddxk1
EXCEPT
SELECT ddxk2.[Refrenced table]
FROM (

SELECT
    --fk.name 'FK Name',
    --tp.name 'Parent table',
    --cp.name, cp.column_id,
    DISTINCT tr.name 'Refrenced table'
    --cr.name, cr.column_id
FROM 
    [RWA-IECMS-story-ExecutionCaseReporting_20181106-DATA].sys.foreign_keys fk
INNER JOIN 
    [RWA-IECMS-story-ExecutionCaseReporting_20181106-DATA].sys.tables tp ON fk.parent_object_id = tp.object_id
INNER JOIN 
    [RWA-IECMS-story-ExecutionCaseReporting_20181106-DATA].sys.tables tr ON fk.referenced_object_id = tr.object_id
INNER JOIN 
    [RWA-IECMS-story-ExecutionCaseReporting_20181106-DATA].sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
INNER JOIN 
    [RWA-IECMS-story-ExecutionCaseReporting_20181106-DATA].sys.columns cp ON fkc.parent_column_id = cp.column_id AND fkc.parent_object_id = cp.object_id
INNER JOIN 
    [RWA-IECMS-story-ExecutionCaseReporting_20181106-DATA].sys.columns cr ON fkc.referenced_column_id = cr.column_id AND fkc.referenced_object_id = cr.object_id
--WHERE tr.name = 'DE_CourtCase' AND cp.name = 'CategoryID'
WHERE tp.name LIKE 'Exec%' AND tr.name LIKE 'C!_%' ESCAPE '!'
--ORDER BY
--    tp.name, cp.column_id

EXCEPT

SELECT
    --fk.name 'FK Name',
    --tp.name 'Parent table',
    --cp.name, cp.column_id,
    DISTINCT tr.name 'Refrenced table'
    --cr.name, cr.column_id
FROM 
    [RWA-IECMS-story-ExecutionCaseReporting_20181106-DATA].sys.foreign_keys fk
INNER JOIN 
    [RWA-IECMS-story-ExecutionCaseReporting_20181106-DATA].sys.tables tp ON fk.parent_object_id = tp.object_id
INNER JOIN 
    [RWA-IECMS-story-ExecutionCaseReporting_20181106-DATA].sys.tables tr ON fk.referenced_object_id = tr.object_id
INNER JOIN 
    [RWA-IECMS-story-ExecutionCaseReporting_20181106-DATA].sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
INNER JOIN 
    [RWA-IECMS-story-ExecutionCaseReporting_20181106-DATA].sys.columns cp ON fkc.parent_column_id = cp.column_id AND fkc.parent_object_id = cp.object_id
INNER JOIN 
    [RWA-IECMS-story-ExecutionCaseReporting_20181106-DATA].sys.columns cr ON fkc.referenced_column_id = cr.column_id AND fkc.referenced_object_id = cr.object_id
--WHERE tr.name = 'DE_CourtCase' AND cp.name = 'CategoryID'
WHERE tp.name not LIKE 'Exec%' AND tr.name LIKE 'C!_%' ESCAPE '!'

) AS ddxk2

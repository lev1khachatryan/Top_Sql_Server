SELECT *
FROM 
(SELECT name
FROM [DEV-RWA_IECMS-DATA].sys.objects
WHERE type_desc = 'USER_TABLE'
AND name LIKE'C!_%' ESCAPE '!'
EXCEPT
SELECT *
FROM [ARTASH].dbo.Articles
) AS a
WHERE a.name NOT IN
(
'C_Asset',
'C_Child',
'C_DummyParty',
'C_DummyPartyAddress',
'C_DummyPartyRepresentative',
'C_Land',
'C_MapShapeSubTypes',
'C_MapShapeTypes',
'C_PartyCrime',
'C_SeizedObjectNumber',
'C_SemiAnnual',
'C_Vehicle' ,
'C_Participant'
)

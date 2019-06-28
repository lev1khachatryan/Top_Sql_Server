CREATE TABLE #ChangedCaseNumbers
    (
      NewCaseNumber NVARCHAR(2000)
    );
INSERT  INTO #ChangedCaseNumbers
        ( NewCaseNumber
        )
        SELECT  'TRF ' + CaseNumber
        FROM    _RevertableCourtCases;

DECLARE @sql AS NVARCHAR(MAX) = N'';
SELECT  @sql += '
EXEC dbo.DeleteCourtCase @CourtCaseInstanceID = ' + cc.CourtCaseInstanceID + '
'
FROM    dbo.DE_CourtCase AS cc
        JOIN dbo.DE_CourtCasePublishedItem AS ccpi ON ccpi.CourtCaseID = cc.CourtCaseID
WHERE   cc.CaseNumber IN ( SELECT   NewCaseNumber
                           FROM     #ChangedCaseNumbers );
EXEC ( @sql );

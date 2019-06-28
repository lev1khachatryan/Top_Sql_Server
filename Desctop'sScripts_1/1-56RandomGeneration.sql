-- This comment was added fօr merge

CREATE TABLE #test (ids INT, ProjectID INT )
INSERT INTO #test
        ( ids, ProjectID )
SELECT ABS(CHECKSUM(NEWID())) % 56 + 1 AS RandNum, ProjectID
FROM dbo.de_Project

INSERT INTO dbo.DE_ProjectLocation
        ( ProjectID ,
          Loc1CountryID ,
          Loc2WilayaID ,
          Loc3MoughataaID ,
          Percentage
        )

SELECT #test.ProjectID, 1 , Loc2WilayaID, Loc3MoughataaID , 100.00
FROM #test
JOIN C_Loc3Moughataa ON ids = Loc3MoughataaID
JOIN dbo.DE_Project ON DE_Project.ProjectID = #test.ProjectID
GO

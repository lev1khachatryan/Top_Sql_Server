SELECT  C_Location.Name_ENG AS RegioName ,
        --Location1ID AS RegionID ,
        C_Zone.Name_ENG AS ZoneName ,
        --C_Zone.ZoneID AS ZoneID ,
        C_Woreda.Name_ENG AS WoredaName ,
        WoredaID AS WoredaID
FROM    dbo.C_Woreda
        LEFT JOIN dbo.C_Zone ON C_Zone.ZoneID = C_Woreda.ZoneID
        LEFT JOIN dbo.C_Location ON C_Location.Location1ID = C_Zone.LocationID
WHERE C_Location.MapShapeID IS NULL AND C_Woreda.MapShapeID IS NULL AND C_Zone.MapShapeID IS NULL
GO

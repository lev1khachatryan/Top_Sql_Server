DECLARE @cnt INT = 10;


DECLARE @AssetID INT = 1; --dzer chtal
WHILE @cnt > 0
    BEGIN
        INSERT  INTO dbo.C_Asset
                ( AssetID,
					Name_ENG ,
                  Name_KRW ,
                  Description ,
                  AssetTypeID ,
                  StartingValue
		        )
                SELECT  @AssetID,
				CONCAT('TestAssetNameEng_',
                               ABS(CHECKSUM(NEWID())) % 1000000) ,
                        CONCAT('TestAssetNameKRW_',
                               ABS(CHECKSUM(NEWID())) % 1000000) ,
                        Concat('TestAssetDescription_',
                               ABS(CHECKSUM(NEWID())) % 1000000) ,
                        ABS(CHECKSUM(NEWID())) % 1 + 1 ,
                        10000;
        SET @cnt = @cnt - 1;
		SET @AssetID = @AssetID + 1
    END;
GO
-- kak minimum 10 hat auction u asset unem



INSERT INTO dbo.AuctionAsset
        ( AuctionID ,
          AssetID
        )
SELECT 1, 1
UNION
SELECT 1, 2
UNION
SELECT 1, 3
UNION
SELECT 1, 4
UNION
SELECT 1, 5
UNION
SELECT 2, 1
UNION
SELECT 2, 6
UNION
SELECT 3, 9
UNION
SELECT 4, 10
UNION
SELECT 5, 2
UNION
SELECT 6, 1

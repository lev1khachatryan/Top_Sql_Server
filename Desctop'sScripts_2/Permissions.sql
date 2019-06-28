INSERT INTO dbo.um_PermissionDirectoryUsers
        ( PermissionID ,
          ItemID ,
          ValueID ,
          UserID
        )
VALUES  ( 30 , -- PermissionID - int
          0 , -- ItemID - int
          1 , -- ValueID - int
          -1  -- UserID - int
        ),
		( 31 , -- PermissionID - int
          0 , -- ItemID - int
          1 , -- ValueID - int
          -1  -- UserID - int
        ),
		( 32 , -- PermissionID - int
          0 , -- ItemID - int
          1 , -- ValueID - int
          -1  -- UserID - int
        ),
		( 33 , -- PermissionID - int
          0 , -- ItemID - int
          1 , -- ValueID - int
          -1  -- UserID - int
        )

SELECT *
FROM dbo.KB_Measures
WHERE MeasureID IN 
(
1095352 ,1095343
)

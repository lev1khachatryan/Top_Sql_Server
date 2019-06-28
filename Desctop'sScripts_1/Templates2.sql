
DECLARE @InnerCursor AS CURSOR;
DECLARE @TemplateID AS INT;
DECLARE @TransferTypeID AS INT;
DECLARE @IsTheSameAsNotofication AS INT;
DECLARE @LanguageID AS INT;
DECLARE @TemplateTransferTypeBody AS NVARCHAR(MAX);
DECLARE @TemplateTransferTypeSubject AS NVARCHAR(MAX);
DECLARE @CurrentTemplateTransferTypeID AS INT;

SET @InnerCursor = CURSOR FOR
SELECT TemplateID , TransferTypeID , IsTheSameAsNotification
FROM [DEV-RWA_IECMS-KB].dbo.ns_TemplateTransferTypes
WHERE TemplateID = @TemplateID

OPEN @InnerCursor;
FETCH NEXT FROM @InnerCursor INTO @TemplateID , @TransferTypeID , @IsTheSameAsNotofication;

WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO dbo.ns_TemplateTransferTypes
	        ( TemplateID ,
	          TransferTypeID ,
	          IsTheSameAsNotification
	        )
	VALUES (@TemplateID ,@TransferTypeID , @IsTheSameAsNotofication)
	SET @CurrentTemplateTransferTypeID = IDENT_CURRENT( 'ns_TemplateTransferTypes');
	
	--
	DECLARE @OuterCursor AS CURSOR;
	SET @OuterCursor = CURSOR FOR
	SELECT LanguageID ,
           TemplateTransferTypeBody ,
           TemplateTransferTypeSubject
	FROM [DEV-RWA_IECMS-KB].dbo.ns_TemplateTransferTypeNames AS a
	JOIN [DEV-RWA_IECMS-KB].dbo.ns_TemplateTransferTypes AS b ON a.TemplateTransferTypeID = b.TemplateTransferTypeID
	WHERE TemplateID = @TemplateID

	OPEN @OuterCursor;
	FETCH NEXT FROM @OuterCursor INTO @LanguageID , @TemplateTransferTypeBody , @TemplateTransferTypeSubject
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    INSERT INTO dbo.ns_TemplateTransferTypeNames
	            ( TemplateTransferTypeID ,
	              LanguageID ,
	              TemplateTransferTypeBody ,
	              TemplateTransferTypeSubject
	            )
	    VALUES (@CurrentTemplateTransferTypeID , @LanguageID , @TemplateTransferTypeBody , @TemplateTransferTypeSubject)

		FETCH NEXT FROM @OuterCursor INTO @LanguageID , @TemplateTransferTypeBody , @TemplateTransferTypeSubject
	END



	FETCH NEXT FROM @InnerCursor INTO @TemplateID , @TransferTypeID , @IsTheSameAsNotofication;
END
CLOSE @InnerCursor;
DEALLOCATE @InnerCursor;
GO
-- This comment was added fօr merge
IF OBJECT_ID('ChangeTemplate') IS NOT NULL
    BEGIN
        DROP PROCEDURE dbo.ChangeTemplate;
    END;
GO
CREATE PROCEDURE dbo.ChangeTemplate
    @TemplateID INT ,
    @TransferTypeID INT ,
    @IsTheSameAsNotification INT ,
    @LanguageID INT = 3 ,
    @TemplateTransferTypeBody NVARCHAR(MAX) ,
    @TemplateTransferTypeSubject NVARCHAR(MAX)
AS
    BEGIN
        DELETE  FROM dbo.ns_TemplateTransferTypes
        WHERE   TemplateID = @TemplateID;
        DECLARE @TemplateTransferTypeID AS INT;
        INSERT  INTO dbo.ns_TemplateTransferTypes
                ( TemplateID ,
                  TransferTypeID ,
                  IsTheSameAsNotification
	            )
        VALUES  ( @TemplateID ,
                  @TransferTypeID ,
                  @IsTheSameAsNotification
                );
        SET @TemplateTransferTypeID = SCOPE_IDENTITY();

        INSERT  INTO dbo.ns_TemplateTransferTypeNames
                ( TemplateTransferTypeID ,
                  LanguageID ,
                  TemplateTransferTypeBody ,
                  TemplateTransferTypeSubject
	            )
        VALUES  ( @TemplateTransferTypeID ,
                  @LanguageID ,
                  @TemplateTransferTypeBody ,
                  @TemplateTransferTypeSubject
                );

    END;
GO

SELECT 'INSERT INTO dbo.MyTable (MyCol1, MyCol2) VALUES (' + MyCol1 + ',' + MyCol2 + ')' AS InsertStatement FROM dbo.MyTable


---

IF OBJECT_ID('CreateTemplate') IS NOT NULL
    BEGIN
        DROP PROCEDURE dbo.CreateTemplate;
    END;
GO
CREATE PROCEDURE dbo.CreateTemplate
    @TemplateID INT ,
    @SourceDB NVARCHAR(1000)
AS
    BEGIN
        DECLARE @sql1 AS NVARCHAR(MAX) = N'';
        SET @sql1 += '
DECLARE @InnerCursor AS CURSOR;
DECLARE @OuterCursor AS CURSOR;
DECLARE @TemplateID AS INT;
DECLARE @TransferTypeID AS INT;
DECLARE @IsTheSameAsNotofication AS INT;
DECLARE @LanguageID AS INT;
DECLARE @TemplateTransferTypeBody AS NVARCHAR(MAX);
DECLARE @TemplateTransferTypeSubject AS NVARCHAR(MAX);
DECLARE @CurrentTemplateTransferTypeID AS INT;

SET @InnerCursor = CURSOR FOR
SELECT TemplateID , TransferTypeID , IsTheSameAsNotification
FROM [' + @SourceDB + '].dbo.ns_TemplateTransferTypes
WHERE TemplateID = @TemplateID

OPEN @InnerCursor;
FETCH NEXT FROM @InnerCursor INTO @TemplateID , @TransferTypeID , @IsTheSameAsNotofication;

WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO dbo.ns_TemplateTransferTypes
	        ( TemplateID ,
	          TransferTypeID ,
	          IsTheSameAsNotification
	        )
	VALUES (@TemplateID ,@TransferTypeID , @IsTheSameAsNotofication)
	SET @CurrentTemplateTransferTypeID = IDENT_CURRENT( ''ns_TemplateTransferTypes'');
	
	--
	SET @OuterCursor = CURSOR FOR
	SELECT LanguageID ,
           TemplateTransferTypeBody ,
           TemplateTransferTypeSubject
	FROM [' + @SourceDB + '].dbo.ns_TemplateTransferTypeNames AS a
	JOIN [' + @SourceDB + '].dbo.ns_TemplateTransferTypes AS b ON a.TemplateTransferTypeID = b.TemplateTransferTypeID
	WHERE TemplateID = @TemplateID

	OPEN @OuterCursor;
	FETCH NEXT FROM @OuterCursor INTO @LanguageID , @TemplateTransferTypeBody , @TemplateTransferTypeSubject
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    INSERT INTO dbo.ns_TemplateTransferTypeNames
	            ( TemplateTransferTypeID ,
	              LanguageID ,
	              TemplateTransferTypeBody ,
	              TemplateTransferTypeSubject
	            )
	    VALUES (@CurrentTemplateTransferTypeID , @LanguageID , @TemplateTransferTypeBody , @TemplateTransferTypeSubject)

		FETCH NEXT FROM @OuterCursor INTO @LanguageID , @TemplateTransferTypeBody , @TemplateTransferTypeSubject
	END



	FETCH NEXT FROM @InnerCursor INTO @TemplateID , @TransferTypeID , @IsTheSameAsNotofication;
END

CLOSE @OuterCursor;
DEALLOCATE @OuterCursor;
CLOSE @InnerCursor;
DEALLOCATE @InnerCursor;
GO
';
        PRINT ( @sql1 );
    END;
GO
EXEC dbo.CreateTemplate @TemplateID = 22, -- int
    @SourceDB = N'DEV-RWA_IECMS-KB' -- nvarchar(1000)

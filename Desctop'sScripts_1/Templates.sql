--IF OBJECT_ID('DropTemplate') IS NOT NULL
--    BEGIN
--        DROP PROCEDURE DropTemplate;
--    END;
--GO
--CREATE PROCEDURE dbo.DropTemplate @TemplateID INT
--AS
--    BEGIN
--        DELETE FROM dbo.ns_TemplateTransferTypes
--		WHERE TemplateID = @TemplateID

--    END;
--GO

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
	INSERT INTO dbo.ns_TemplateTransferTypes
	        ( TemplateID ,
	          TransferTypeID ,
	          IsTheSameAsNotification
	        )
	SELECT TemplateID ,TransferTypeID ,IsTheSameAsNotification
	FROM [' + @SourceDB + '].dbo.ns_TemplateTransferTypes
	WHERE TemplateID = ' + CAST(@TemplateID AS NVARCHAR(10)) + '
	';
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
	JOIN [' + @SourceDB + '].dbo.dbo.ns_TemplateTransferTypes AS b ON a.TemplateTransferTypeID = b.TemplateTransferTypeID
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
    END;
GO
';
END


/*

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
	SET @CurrentTemplateTransferTypeID = IDENT_CURRENT( 'ns_TemplateTransferTypes' );
	
	--
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
 
CLOSE @OuterCursor;
DEALLOCATE @OuterCursor;
CLOSE @InnerCursor;
DEALLOCATE @InnerCursor;

*/


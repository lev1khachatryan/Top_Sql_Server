-- =============================================
-- Author:		<LKH>
-- Create date: <20160928>
-- Description:	<ADD NOCOUNT ON>
-- =============================================

ALTER PROCEDURE [dbo].[Add_NOCOUNT_ON] 
@list NVARCHAR(MAX) = NULL

AS
BEGIN
	SET NOCOUNT ON 
	SET @list = @list +','
	DECLARE @HelpText TABLE
	(
	    Val NVARCHAR(MAX)
	);
	DECLARE @parameters TABLE
	(
	    Name NVARCHAR(MAX)
	);	
	DECLARE @sp_names TABLE
	(
	    ID INT PRIMARY KEY IDENTITY,
	    Name NVARCHAR(128)
	);
	DECLARE @sp_count INT,
	        @spID INT = 0,
	        @sp_name NVARCHAR(128),
	        @text NVARCHAR(MAX);

	IF NOT ( @list IS NULL OR LEN(@list) = 0 )
	BEGIN
		WHILE CHARINDEX(',', @list) > 0
		BEGIN
			DECLARE @pos INT
			SET @pos = CHARINDEX(',', @list)
			INSERT INTO @parameters ( Name )  
			SELECT SUBSTRING(@list, 1, @pos-1)		
			SELECT @list = SUBSTRING(@list, @pos+1, LEN(@list)-@pos)
		END	
	END
	INSERT INTO @sp_names ( Name )  
	SELECT Name
	FROM   sys.Procedures
	WHERE  sys.Procedures.name NOT IN (SELECT Name FROM @parameters) AND sys.procedures.name LIKE 'de!_%' ESCAPE '!' --sys.procedures.name NOT LIKE '[^DE]%'
	SET @sp_count = (SELECT COUNT(1) FROM @sp_names);
	WHILE (@sp_count > @spID)
	BEGIN
	    SET @spID = @spID + 1;
	    SET @text = N'';
	    SET @sp_name = (SELECT  name
	                    FROM    @sp_names
	                    WHERE   ID = @spID);
	
	    INSERT INTO @HelpText
	    EXEC sp_HelpText @sp_name;
	    SELECT  @text = COALESCE(@text + Val, Val)
	    FROM    @HelpText;
	    DELETE FROM @HelpText;
	    IF @text LIKE '%SET NOCOUNT ON%'
	    BEGIN
	        CONTINUE
	    END
	    ELSE
	    BEGIN
				IF @text LIKE '%CREATE PROCEDURE%'
				BEGIN
					SET @text = REPLACE(@text, 'CREATE PROCEDURE', 'ALTER PROCEDURE');
				END
				ELSE
				BEGIN
					SET @text = REPLACE(@text, 'CREATE PROC', 'ALTER PROCEDURE');
				END
				IF CHARINDEX('BEGIN', @text) = 0
				BEGIN
											  
					  --IF @text LIKE '%ALTER PROCEDURE ![dbo!].![' + @sp_name + '!]' + + CHAR(13) + CHAR(10) + 'AS%'ESCAPE '!'
					  --BEGIN
					  --    PRINT 'yes'
					  --END
					  --ELSE
					  --BEGIN
					  --    PRINT '%ALTER PROCEDURE [dbo].[' + @sp_name + ']' + CHAR(13) + 'AS%'
						 -- PRINT @text
					  --END
					  SET @text = REPLACE ( @text ,'ALTER PROCEDURE [dbo].[' + @sp_name + ']'  + CHAR(13) + CHAR(10) + 'AS' ,'ALTER PROCEDURE [dbo].[' + @sp_name + ']'  + CHAR(13) + CHAR(10) + 'AS'  + CHAR(13) + CHAR(10) + 'BEGIN'   + CHAR(13) + CHAR(10) + 'SET NOCOUNT ON;'  ) + CHAR(13) + CHAR(10) + 'END'
				END
				ELSE
				BEGIN
					SET @text = STUFF(@text, CHARINDEX('BEGIN', @text), LEN('BEGIN'), 'BEGIN' + CHAR(13) + CHAR(10) + SPACE(4) + 'SET NOCOUNT ON;');
				END
				--PRINT @text				
				EXECUTE sp_executesql @text;
		END
	END
END
GO

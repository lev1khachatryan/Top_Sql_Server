
ALTER PROCEDURE [dbo].[BackupAndRestoreDatabase]
    @SourceDatabaseName NVARCHAR(100) , -- the db name that must be backup
    @backupDirectory NVARCHAR(500),
	@restoreDB bit = 0,
	@DestinationDatabaseName NVARCHAR(100) = NULL,  -- the new db name (if null then it will be oldDB_yyyymmdd_hh_mm)
	@FilePath NVARCHAR(500) = NULL
	--WITH EXECUTE AS SELF
AS
    BEGIN
	    SET NOCOUNT ON;
		DECLARE @sql NVARCHAR(2500) 
        DECLARE @fileName NVARCHAR(256)
        DECLARE @fileDate NVARCHAR(20)
        DECLARE @FullPath NVARCHAR(500)
        DECLARE @LdfName NVARCHAR(500) 
        DECLARE @MdfName NVARCHAR(500)
        DECLARE @OldLdfName NVARCHAR(500)
        DECLARE @OldMdfName NVARCHAR(500)
        SELECT  @fileDate = LEFT(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(50), GETDATE(), 120),
                                                         '-', ''), ' ', '_'),
                                         ':', '_'), 14)
        IF @DestinationDatabaseName IS NULL
            BEGIN
                SET @DestinationDatabaseName = @SourceDatabaseName + '_'
                    + @fileDate
            END
		CREATE TABLE #temp (OldFileName NVARCHAR(500), NewFileName NVARCHAR(500), ID INT IDENTITY)
		;		
        WITH    cte
                  AS ( SELECT   physical_name ,
                                LEFT(physical_name,
                                     LEN(physical_name) - CHARINDEX('\',
                                                              REVERSE(physical_name))
                                     + 1) AS FullPath ,
                                ROW_NUMBER() OVER ( ORDER BY physical_name ) AS Id
                       FROM     sys.master_files mf
                                INNER JOIN sys.databases db ON db.database_id = mf.database_id
                       WHERE    db.name = @SourceDatabaseName
                     )
			INSERT INTO #temp
			        ( OldFileName, NewFileName )
            SELECT  physical_name ,
                    CASE WHEN @FilePath IS NULL THEN cte.FullPath ELSE @FilePath END
                    + @DestinationDatabaseName + '_' + @fileDate
                    + CASE WHEN physical_name LIKE '%.mdf' THEN +'.mdf'
                           WHEN physical_name LIKE '%.ldf' THEN +'_log.ldf'
                           WHEN physical_name LIKE '%.ndf'
                           THEN +'_' + CAST(Id AS NVARCHAR(50)) + '.ndf'
                      END
            FROM    cte; 
			--SELECT *
			--FROM #temp
        SET @fileName = @backupDirectory + '\' + @SourceDatabaseName + '_'
            + @fileDate + '.BAK'
        
        BACKUP DATABASE @SourceDatabaseName TO DISK = @fileName 
		
		IF @restoreDB = 1
		BEGIN
				

DECLARE @Table TABLE
    (
      LogicalName VARCHAR(128) ,
      [PhysicalName] VARCHAR(128) ,
      [Type] VARCHAR ,
      [FileGroupName] VARCHAR(128) ,
      [Size] VARCHAR(128) ,
      [MaxSize] VARCHAR(128) ,
      [FileId] VARCHAR(128) ,
      [CreateLSN] VARCHAR(128) ,
      [DropLSN] VARCHAR(128) ,
      [UniqueId] VARCHAR(128) ,
      [ReadOnlyLSN] VARCHAR(128) ,
      [ReadWriteLSN] VARCHAR(128) ,
      [BackupSizeInBytes] VARCHAR(128) ,
      [SourceBlockSize] VARCHAR(128) ,
      [FileGroupId] VARCHAR(128) ,
      [LogGroupGUID] VARCHAR(128) ,
      [DifferentialBaseLSN] VARCHAR(128) ,
      [DifferentialBaseGUID] VARCHAR(128) ,
      [IsReadOnly] VARCHAR(128) ,
      [IsPresent] VARCHAR(128) ,
      [TDEThumbprint] VARCHAR(128)
    );
				INSERT INTO @Table
				EXEC ('RESTORE FILELISTONLY FROM DISK = ''' + @filename + '''')

				--SELECT *
				--FROM @Table
				SET @sql ='RESTORE DATABASE [' + @DestinationDatabaseName + '] FROM DISK = ''' + @fileName + '''' + CHAR(13) +
				'WITH '

				DECLARE @i INT = 1
				DECLARE @j INT = (SELECT COUNT(*) FROM #temp)

				WHILE @i <= @j
				BEGIN
					SET @sql = @sql + 'MOVE ''' + (SELECT LogicalName FROM #temp JOIN @Table ON OldFileName = PhysicalName WHERE ID = @i) + ''' TO ''' + (SELECT NewFileName FROM #temp WHERE ID = @i) + '''' + CASE WHEN @i < @j THEN ',' ELSE '' END + CHAR(13)
				    SET @i = @i + 1
				END
				SET @sql = @sql + 'PRINT (''Restored DB name is''+'' [' + @DestinationDatabaseName +']'')'

				EXEC (@sql)
				--PRINT @sql
		END    
END

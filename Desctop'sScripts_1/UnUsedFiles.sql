CREATE TABLE #Files
    (
      FilePath NVARCHAR(1000) ,
      FileName NVARCHAR(1000)
    );
INSERT  INTO #Files
        ( FileName
        )
        EXECUTE xp_cmdshell 'dir E:\DEFAULT.DATA\ /b';
UPDATE  #Files
SET     FilePath = 'E:\DEFAULT.DATA\'
WHERE   FilePath IS NULL;
INSERT  INTO #Files
        ( FileName
        )
        EXECUTE xp_cmdshell 'dir E:\DEFAULT.LOG\ /b';
UPDATE  #Files
SET     FilePath = 'E:\DEFAULT.LOG\'
WHERE   FilePath IS NULL;
INSERT  INTO #Files
        ( FileName )
        EXECUTE xp_cmdshell 'dir E:\CI\ /b';
UPDATE  #Files
SET     FilePath = 'E:\CI\'
WHERE   FilePath IS NULL;
DELETE  FROM #Files
WHERE   FileName IS NULL
        OR FileName LIKE '%BAK';

DELETE FROM #Files
WHERE FileName NOT IN
(
SELECT  FileName
FROM    #Files
EXCEPT
SELECT  RIGHT(physical_name, CHARINDEX('\', REVERSE(physical_name)) - 1) AS name
FROM    sys.master_files
)

SELECT *
FROM #Files


--DECLARE @sql AS NVARCHAR(MAX) = N''
--SELECT @sql +='
--EXECUTE sys.xp_cmdshell  ''del ' + FilePath + FileName + ''''
--FROM #Files

--EXECUTE (@sql)

--DROP TABLE #Files;

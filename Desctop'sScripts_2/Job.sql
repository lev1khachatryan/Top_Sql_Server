--SELECT CreatorName
--FROM dbo._DE_BuildNumber

--ALTER TABLE dbo._DE_BuildNumber
--ADD CreatorName NVARCHAR(500)

--UPDATE dbo._DE_BuildNumber
--SET creatorname = 'levon.khachatryan'


CREATE TABLE #DBs ( DBName NVARCHAR(500) , CreatorName NVARCHAR(500) );
DECLARE @sql AS NVARCHAR(MAX) = N'';
SELECT  @sql += '
SELECT TABLE_CATALOG AS DBName
FROM [' + name + '].INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = ''_DE_BuildNumber''
AND COLUMN_NAME = ''CreatorName'' UNION
'
FROM    sys.databases
WHERE 
--(name LIKE 'USA%' OR name LIKE 'RWA%' OR name LIKE 'MRT%') AND
	(is_published = 0 AND is_subscribed = 0 AND
  is_merge_published = 0 AND is_distributor = 0 )
IF ( LEN(@sql) > 7 )
    BEGIN
        SET @sql = SUBSTRING(@sql, 1, LEN(@sql) - 7);
    END;
INSERT  INTO #DBs
        ( DBName )
        EXEC ( @sql
            );

DECLARE @update AS NVARCHAR(MAX) = N''
SELECT @update +='
UPDATE #DBs
SET CreatorName = (SELECT CreatorName FROM [' + DBName + '].dbo._DE_BuildNumber)
WHERE DBName = ''' + DBName + '''
'
FROM #DBs
EXEC (@update)
----
DECLARE @Email AS NVARCHAR(MAX) = N'';
SELECT @Email +='
EXEC [msdb].dbo.sp_send_dbmail @profile_name = ''DBA'',
    @recipients = ''' + CreatorName + '.@synisys.com'',
    @subject = N''valod'',
    @body = N''DDXK'' ,
    @query = N''SELECT DBName
				FROM #DBs
				WHERE CreatorName = ''''' + CreatorName + ''''''' ,
    @reply_to = ''Levon.Khachatryan@synisys.com''
'
FROM #DBs

SELECT *

PRINT (@Email)

--DROP TABLE #dbs

----
----
----

--EXEC [msdb].dbo.sp_send_dbmail @profile_name = 'DBA',
--    @recipients = 'artashes.khachatryan@synisys.com',
--    @subject = N'valod',
--    @body = N'DDXK' ,
--    @query = N'select1' ,
--    @reply_to = 'levon.khachatryan@synisys.com'


---

EXECUTE msdb.dbo.sysmail_add_account_sp
    @account_name = 'Mail Account',
    @description = 'Mail account for administrative e-mail.',
    @email_address = 'noreply_db@synisys.com',
    @display_name = 'Test Display',
    @mailserver_name = 'mail.synisys.com',
    @port = 25,
    @username = 'noreply_db@synisys.com',
    @password = 'a79:cytxefQw~Ad8',
    @enable_ssl = 1




EXEC msdb.dbo.sp_send_dbmail
    @recipients=N'levon.khachatryan@synisys.com',
	@reply_to = 'levon.khachatryan@synisys.com' ,
    @body= 'barlus dzez',
    @subject = 'hangstaci axpeeers menq qezi arden et enq berum',
    @profile_name = 'Mail Profile'

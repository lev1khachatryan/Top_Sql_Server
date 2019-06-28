function loadSQLPS {
    #$mssql_version = "C:\sql\logs\mssql_version.tmp"
    $SQLversion = gc $mssql_version

    # Test to see if the SQLPS module is loaded, and if not, load it
    writeLog "Checking if SQLPS module is imported or not"  Yellow
    if (-not(Get-Module -name sqlps)){
        Get-Module -ListAvailable | % {
            if ($_.name -eq 'SQLPS') {
                writeLog "Importing SQLPS module"  Yellow            
				while(get-module -Name sqlps){
					Import-Module -Name SQLPS -DisableNameChecking
                    Invoke-Expression "c:"
				}
                writeLog "SQLPS imported successfully"  Green
            }
        }
    } else {
        writeLog "SQLPS module is already imported" Green
	}
	
    $typesVar = $(get-Variable -name ('MSSQLTypesToLoad' + $SQLversion)).Value
  
  	writeLog "adding types" Yellow
    $typesVar | % { Add-Type -Path $_  }
    writeLog "Types added" Green
}

function User-Mapping {
	param ($db, $User, $db_role, $schema, $Username , $Password)

    writeLog "Mapping $User login to $db"  Cyan
    Invoke-Sqlcmd -ServerInstance $MSSQLServerName -Query "
		
        USE [$db]
        GO

        IF NOT EXISTS (SELECT 1 FROM sysusers WHERE name = '$User')
        BEGIN
	        EXEC ('CREATE USER [$User] FOR LOGIN [$User];')
	        EXEC ('ALTER ROLE [$db_role] ADD MEMBER [$User];')
        END
        " -Username $Username -Password $Password

    #writeLog "$User user mapped to $db with $db_role role successfully"  Green
}

function Remove-Inheritance {
    param(
		$path,
		[parameter(Mandatory=$false)]
		[Switch]
		$log = $false,
		[parameter(Mandatory=$false)]
		[Switch]
		$inherit = $false
	)
                
    if ($log){writeLog "Removing inheritance from $path folder" -ForegroundColor Yellow}
    $acl = Get-Item $path | get-acl
    if (-not $inherit){
        $acl.SetAccessRuleProtection($true,$true)
    } else {
        $acl.SetAccessRuleProtection($false,$false)
    }
    $acl |Set-Acl
    if ($log){
		writeLog "Inheritance has been disabled on $path folder" -ForegroundColor Green
	}
}

function Reset-Inheritance {
	param ($Path)
	
	writeLog "Reseting inheritance for $Path subfolders" -ForegroundColor Yellow
	$ACL = Get-Acl -Path $Path 

	$icacls = "$Path\*"
	Set-ACL -Path $Path -AclObject $ACL -ErrorAction Stop
	icacls $icacls /q /c /t /reset 
	writeLog "Inheritance has been set for $Path subfolders" -ForegroundColor Green
}

function Remove-AccessRule {
    param(
        $path,
        $user,
        [parameter(Mandatory=$false)]
        [Switch]
        $log = $false
    )

    if ($log){writeLog "Removing access rules of users: $user from $path folder" -ForegroundColor Yellow}

    # This removes all access for the group in question
    $acl = get-acl $path 
    $acl.access | Where-Object {$user -contains $_.IdentityReference} | % {
        $acl.RemoveAccessRule($_)
    } | out-null
    $acl |Set-Acl
    if ($log){writeLog "Users: $user access rules has been removed from $path folder" -ForegroundColor Green}
}

function writeLog {
    param ($log, $ForegroundColor)

    if ($ForegroundColor -eq $null){$ForegroundColor = 'white'}

    $log = "$(Get-Date -format 'u') --->  " + $log 

    Write-Host $log -ForegroundColor $ForegroundColor
	#$LogFile = Join-Path $logsFolder "script_log.txt"

    #$log >> $LogFile
}

function Get-Set-ACL {
    param(
        $User             = $false,
        $Rights           = $false,
        $userObjAcE       = $false,
        $InheritanceFlag  = $false,
        $Folder,
        [parameter(Mandatory=$false)]
        [Switch]
        $RemoveAccessRule,
        [parameter(Mandatory=$false)]
        [Switch]
        $noInheritance
    )

    if ($noInheritance){
        Remove-Inheritance -path $Folder
    }
    
    if ($RemoveAccessRule){
        Remove-AccessRule -path $Folder -user $User 
    }
    
    if (-not $userObjAcE){
        $colRights = $Rights
        if (-not $InheritanceFlag){$InheritanceFlag = "ContainerInherit, ObjectInherit"}
        $PropagationFlag = 'none'
        $objType = 'Allow'
        $objUser = $User 
    
        $objACE = New-Object System.Security.AccessControl.FileSystemAccessRule($objUser, $colRights, $InheritanceFlag, $PropagationFlag, $objType) 
    } else {
        $objACE = $userObjAcE
    }

    $objACL = Get-Acl $Folder
	$objACL.AddAccessRule($objACE) 

    Set-Acl -Path $Folder -AclObject $objACL #-Verbose
}

function Create-DistributorDbQuery {
    param($DataPath, $LogPath, $ReplicationPath, $SQLServer, $DBName)

    $query = "
    USE [master]

    exec sp_adddistributor @distributor = N'$SQLServer',   ---Add SQL Server instance name where Distributor stored
					       @password = N''
    GO
    exec sp_adddistributiondb @database = N'$DBName', @data_folder = N'$DataPath', -- distribution database data file(*.mdf) location
													       @log_folder = N'$LogPath', -- distribution database log file(*.ldf) location
													       @log_file_size = 2, @min_distretention = 0, @max_distretention = 72, @history_retention = 48, @security_mode = 1
    GO

    USE [$DBName] 
    if (not exists (select * from sysobjects where name = 'UIProperties' and type = 'U ')) 
	    create table UIProperties(id int) 
    if (exists (select * from ::fn_listextendedproperty('SnapshotFolder', 'user', 'dbo', 'table', 'UIProperties', null, null))) 

	    EXEC sp_updateextendedproperty N'SnapshotFolder', N'$ReplicationPath', -- Replication folder where snapshot files will be created (Agent service account need have R/W access on this folder)
														    'user', dbo, 'table', 'UIProperties' 
    else 
	    EXEC sp_addextendedproperty N'SnapshotFolder', N'$ReplicationPath', 'user', dbo, 'table', 'UIProperties'
    GO

    exec sp_adddistpublisher @publisher = N'$SQLServer', ---Add SQL Server instance name where Publisher stored
						    @distribution_db = N'$DBName', @security_mode = 1, @working_directory = N'$ReplicationPath',
    @trusted = N'false', @thirdparty_flag = 0, @publisher_type = N'MSSQLSERVER'
    GO"

    Write-Output $query
}

function CreateReplication_Articles {
    param ($importedColumnList, $Data_DB_Name, $publicationName, $publisherName)

    $execArticleQuery = "
    use [$Data_DB_Name]
    exec sp_replicationdboption @dbname = N'$Data_DB_Name', @optname = N'publish', @value = N'true'
    GO
    -- Adding the transactional publication
    use [$Data_DB_Name]
    exec sp_addpublication @publication = N'$publicationName', @description = N'Transactional publication of database ''$Data_DB_Name'' from Publisher ''$publisherName''.', @sync_method = N'concurrent', @retention = 0, @allow_push = N'true', @allow_pull = N'true', @allow_anonymous = N'true', @enabled_for_internet = N'false', @snapshot_in_defaultfolder = N'true', @compress_snapshot = N'false', @ftp_port = 21, @ftp_login = N'anonymous', @allow_subscription_copy = N'false', @add_to_active_directory = N'false', @repl_freq = N'continuous', @status = N'active', @independent_agent = N'true', @immediate_sync = N'true', @allow_sync_tran = N'false', @autogen_sync_procs = N'false', @allow_queued_tran = N'false', @allow_dts = N'false', @replicate_ddl = 1, @allow_initialize_from_backup = N'false', @enabled_for_p2p = N'false', @enabled_for_het_sub = N'false'
    GO

    exec sp_addpublication_snapshot @publication = N'$publicationName', @frequency_type = 1, @frequency_interval = 0, @frequency_relative_interval = 0, @frequency_recurrence_factor = 0, @frequency_subday = 0, @frequency_subday_interval = 0, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @job_login = null, @job_password = null, @publisher_security_mode = 1

    "

    foreach ($table in $importedColumnList){

        $execArticleQuery += "

        use [$Data_DB_Name]
        exec sp_addarticle @publication = N'$publicationName', @article = N'$table', @source_owner = N'dbo', @source_object = N'$table', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x0000000008037FDF, @identityrangemanagementoption = N'manual', @destination_table = N'$table', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dbo$table', @del_cmd = N'CALL sp_MSdel_dbo$table', @upd_cmd = N'SCALL sp_MSupd_dbo$table'
        GO

        "
    }

    Write-Output $execArticleQuery 
}

function Alter_Replication_No_replicate_DDL {
    param ($Data_DB_Name, $publicationName)

    $query = "
    USE [$Data_DB_Name]
    EXEC sp_changepublication 
    @publication = N'$publicationName', 
    @property = N'replicate_ddl', 
    @value = 0;
    "
    Write-Output $query
}

function Create-Subscription {
    param ($Data_DB_Name, $De_DB_Name,  $publicationName, $SQLServer, $DitributorName)
    $query = "
        -----------------BEGIN: Script to be run at Publisher 
    use [$Data_DB_Name]  ------ Publisher Database name
    exec sp_addsubscription @publication = N'$publicationName', 
    @subscriber = N'$SQLServer',  			----Subscriber SQL Instance
    @destination_db = N'$De_DB_Name',  	----Subscriber database
    @subscription_type = N'Push', @sync_type = N'automatic', 
    @article = N'all', @update_mode = N'read only', @subscriber_type = 0


    exec sp_addpushsubscription_agent @publication = N'$publicationName', 
    @subscriber = N'$SQLServer', 			----Subscriber SQL Instance
    @subscriber_db = N'$De_DB_Name',	----Subscriber database 
    @job_login = null, @job_password = null, @subscriber_security_mode = 1, @frequency_type = 64, @frequency_interval = 0, @frequency_relative_interval = 0, 
    @frequency_recurrence_factor = 0, @frequency_subday = 0, 
    @frequency_subday_interval = 0, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 20150811, @active_end_date = 99991231,
     @enabled_for_syncmgr = N'False', 
    @dts_package_location = N'Distributor'
    GO
    -----------------END: Script to be run at Publisher 
    "
    
    Write-Output $query
}

function Get-SnapshotAgentstatus {
    #Write-Host ""
    #Write-Host "[+]Snapshot Agent Current Status" -BackgroundColor Green -ForegroundColor Black
    #Write-Host ""
    foreach($SMonitorServers in $RepInstanceStatus.EnumSnapshotAgents()) {
        foreach($SMon in $SMonitorServers.Tables)
        {
            foreach($SnapshotAgent in $SMon | SELECT dbname,name,status,publisher,publisher_db,publication,subscriber,subscriber_db,starttime,time,duration,comments)
            {
                #Write-Host "dbname :" $SnapshotAgent.dbname
                #Write-Host "Snapshot Agent :" $SnapshotAgent.name -ForegroundColor Green
                #write-host "status :" $SnapshotAgent.status
                #write-host "publisher :" $SnapshotAgent.publisher
                #write-host "publisher_db :" $SnapshotAgent.publisher_db
                #write-host "publication :" $SnapshotAgent.publication
                #write-host "subscriber :" $SnapshotAgent.subscriber
                #write-host "subscriber_db :" $SnapshotAgent.subscriber_db
                #write-host "starttime :" $SnapshotAgent.starttime
                #write-host "time :" $SnapshotAgent.time
                #write-host "duration :" $SnapshotAgent.duration
                #write-host "comments :" $SnapshotAgent.comments -ForegroundColor Green
                #write-host "*********************************************************************"
                return $SnapshotAgent.comments
            }
        }
    }
}

function Get-LogReaderAgentstatus {
    #Write-Host ""
    #Write-Host "[+]LogReader Agent Current Status" -BackgroundColor Green -ForegroundColor Black
    #Write-Host ""
    foreach($PMonitoreServers in $RepInstanceStatus.EnumLogReaderAgents()){
        foreach($PubMon in $PMonitoreServers.Tables){
            foreach($LogAgent in $PubMon | SELECT dbname,name,status,publisher,publisher_db,publication,subscriber,subscriber_db,starttime,time,duration,comments){
                #Write-Host "dbname :" $LogAgent.dbname
                #Write-Host "LogReader Agent :" $LogAgent.name -ForegroundColor Green
                #write-host "status :" $LogAgent.status
                #write-host "publisher :" $LogAgent.publisher
                #write-host "publisher_db :" $LogAgent.publisher_db
                #write-host "publication :" $LogAgent.publication
                #write-host "subscriber :" $LogAgent.subscriber
                #write-host "subscriber_db :" $LogAgent.subscriber_db
                #write-host "starttime :" $LogAgent.starttime
                #write-host "time :" $LogAgent.time
                #write-host "duration :" $LogAgent.duration
                #write-host $LogAgent.comments -ForegroundColor Cyan
                #write-host "*********************************************************************"
                return $LogAgent.comments
            }
        }
    }
}

function Get-DitributorAgentstatus {
    #Write-Host ""
    #Write-Host "[+]Distributor Agent Current Status" -BackgroundColor Yellow -ForegroundColor Black
    #Write-Host ""
    foreach($DMonitorervers in $RepInstanceStatus.EnumDistributionAgents()){
        foreach($DisMon in $DMonitorervers.Tables){
            foreach($DisAgent in $DisMon | SELECT dbname,name,status,publisher,publisher_db,publication,subscriber,subscriber_db,starttime,time,duration,comments){
                #Write-Host "dbname :" $DisAgent.dbname
                #Write-Host "Distributor Agent:" $DisAgent.name -ForegroundColor Yellow
                #write-host "status :" $DisAgent.status
                #write-host "publisher :" $DisAgent.publisher
                #write-host "publisher_db :" $DisAgent.publisher_db
                #write-host "publication :" $DisAgent.publication
                #write-host "subscriber :" $DisAgent.subscriber
                #write-host "subscriber_db :" $DisAgent.subscriber_db
                #write-host "starttime :" $DisAgent.starttime
                #write-host "time :" $DisAgent.time
                #write-host "duration :" $DisAgent.duration
                #write-host $DisAgent.comments -ForegroundColor Yellow
                #write-host "*********************************************************************"
                return $DisAgent.comments
            }
        }
    }
}

function Start-ReplicationJob {
    param ($Data_DB_Name)
    $query = "
    DECLARE @id UNIQUEIDENTIFIER

	SELECT @id = job_id
	FROM [msdb].dbo.sysjobs
	WHERE name = (

	SELECT name
	FROM distribution.dbo.MSsnapshot_agents
	WHERE publisher_db = '$Data_DB_Name')
	

	EXEC msdb.dbo.sp_start_job  @job_id = @id 
    "
    Write-Output $query
}

function Check-ReplicationStatus {
    param ($Data_DB_Name)
    $query = "
    SELECT 1	
	FROM distribution.dbo.MSsnapshot_history a ,distribution.dbo.MSsnapshot_agents b 	
	WHERE b.publisher_db = '$Data_DB_Name' AND b.id = a.agent_id  AND a.runstatus = 2
    "
    Write-Output $query
}

function Replication_AfterCreate {
    param ($DE_DB_Name)

    $query = "
    USE [Development_DB]
    GO

    /****** Object:  StoredProcedure [dbo].[Replication_AfterCreate]    Script Date: 8/12/2016 1:00:57 PM ******/
    SET ANSI_NULLS ON
    GO

    SET QUOTED_IDENTIFIER ON
    GO



    -- =============================================
    -- Author:		<AKH>
    -- Create date: <20160322>
    -- Description:	<Stored procedure must be called before configuring replication>
    -- =============================================
    CREATE PROCEDURE [dbo].[Replication_AfterCreate]
	    @Subscriber_DB NVARCHAR(500) = '$DE_DB_Name'	
    AS
    BEGIN
	    -- SET NOCOUNT ON added to prevent extra result sets from
	    -- interfering with SELECT statements.
	    SET NOCOUNT ON;
	
	    DECLARE @sql NVARCHAR(MAX)

	    SET @sql = 'USE [' + @Subscriber_DB + '] 
	
	    declare @sql nvarchar(max) = ''
	    CREATE VIEW [dbo].[View_DE_ArticleCrimes] WITH SCHEMABINDING
    AS

    SELECT 
    C_Article.ArticleID
    ,C_Article.Name AS Article
    , C_CrimeCategory.Name AS CrimeCategory
    , C_CrimeCategory.CrimeCategoryID
    FROM dbo.C_Article
    JOIN dbo.C_ArticleCrimeCategory ON C_ArticleCrimeCategory.ArticleID = C_Article.ArticleID
    JOIN dbo.C_CrimeCategory ON C_CrimeCategory.CrimeCategoryID = C_ArticleCrimeCategory.CrimeCategoryID''

    exec (@sql)
    '
	    EXEC (@sql)
	    SET @sql = 'USE [' + @Subscriber_DB + '] CREATE UNIQUE CLUSTERED INDEX [CIX_View_DE_ArticleCrimes] ON [dbo].[View_DE_ArticleCrimes]
    (
	    [ArticleID] ASC,
	    [CrimeCategoryID] ASC
    )'
	    EXEC (@sql)
    END
    
    GO

    "
    Write-Output $query
} 

function Replication_BeforeCreate {
    param ($DE_DB_Name)

    $query = "
    USE [Development_DB]
    GO

    SET ANSI_NULLS ON
    GO

    SET QUOTED_IDENTIFIER ON
    GO

    CREATE PROCEDURE [dbo].[Replication_BeforeCreate]
	    @Subscriber_DB NVARCHAR(500) = '$DE_DB_Name'	
    AS
    BEGIN
	    -- SET NOCOUNT ON added to prevent extra result sets from
	    -- interfering with SELECT statements.
	    SET NOCOUNT ON;
	
	    DECLARE @sql NVARCHAR(MAX)

	    SET @sql = 'USE [' + @Subscriber_DB + '] DROP VIEW dbo.View_DE_ArticleCrimes'
	    EXEC (@sql)
    END

    GO
    "
    Write-Output $query
}

function Run-procedureBeforeRepl {
    param ($DE_DB_Name)

    $query = "EXEC Development_DB.dbo.Replication_BeforeCreate @Subscriber_DB  = '$DE_DB_Name'"
    Write-Output $query
}

function Run-procedureAfterRepl {
    param ($DE_DB_Name)

    $query = "EXEC Development_DB.dbo.Replication_AfterCreate @Subscriber_DB  = '$DE_DB_Name'"
    Write-Output $query
}

function Update-Articles {
    param ($Data_DB_Name, $publicationName)
    
    $query = "
       
    ---------------------Automatically change all articles properties to include indexes and keys into replication--------------
    USE [$Data_DB_Name]
    GO
    /*
    Change Publication name ,Publisher DB and snapshot agent name

    */
    create table #tarticles(article_id	int,article_name sysname,base_object nvarchar(257),destination_object sysname,synchronization_object nvarchar(257),[type] smallint,
    [status] tinyint,filter	nvarchar(257) null,[description]	nvarchar(255) null,insert_command nvarchar(255),update_command nvarchar(255),delete_command nvarchar(255),
    creation_script_path nvarchar(255) null,vertical_partition bit,pre_creation_cmd tinyint,filter_clause ntext null,schema_option binary(8),dest_owner sysname,source_owner sysname,
    unqua_source_object	sysname,sync_object_owner sysname,unqualified_sync_object sysname,filter_owner sysname null,unqua_filter sysname null,auto_identity_range int,publisher_identity_range int null,
    identity_range bigint null,threshold bigint null,identityrangemanagementoption int,fire_triggers_on_snapshot bit)


    insert into #tarticles
    EXEC sp_helparticle '$publicationName'	--Publication name

    declare	 articles cursor for
    select article_name,schema_option 
    from #tarticles

    declare 	@article_name sysname,@schema_option binary(8)

    open articles
    fetch next from articles into @article_name,@schema_option
 
    while @@FETCH_STATUS=0
    begin

    if @schema_option<>0x0000000008237FDF
    EXEC sp_changearticle 
      @publication = '$publicationName',   
      @article = @article_name, 
      @property = N'schema_option', 
      @value = '0x0000000008237FDF',
      @force_invalidate_snapshot = 1,
      @force_reinit_subscription = 1;

    fetch next from articles into @article_name,@schema_option
    end

    exec sp_refreshsubscriptions '$publicationName'

    drop table #tarticles
    close articles
    deallocate articles
    "
    Write-Output $query
}

function Check-Publication {
	param ($Distribution)
	$query = "select * from $Distribution.dbo.MSpublications"
	Write-Output $query
}

function Drop-Replication {
    param ($Data_DB_Name, $publicationName)
	#    EXEC sp_dropsubscription  @publication= 'all'
	#    EXEC sys.sp_droppublication @publication = 'all'
	
    $query = "
    
    /*Change publisher DB name in the script 
    before executing*/

    USE [$Data_DB_Name]

    DECLARE @PublisherDBName NVARCHAR(max) = '$Data_DB_Name'
    DECLARE @Publication NVARCHAR(max)
    DECLARE @LogReaderAgentJobName NVARCHAR(max)  

    SELECT @Publication = publication
    FROM distribution.dbo.MSpublications
    WHERE publisher_db = @PublisherDBName

    SELECT @LogReaderAgentJobName = name
    FROM distribution.dbo.MSlogreader_agents
    WHERE publisher_db = @PublisherDBName

    PRINT @LogReaderAgentJobName + ' ' + @Publication

    EXEC msdb.dbo.sp_stop_job @job_name = @LogReaderAgentJobName

    EXEC sp_dropsubscription  @publication= '$publicationName'
        ,@article= 'all'
    , @subscriber= 'all'
    , @destination_db= NULL

    EXEC sys.sp_droppublication @publication = '$publicationName'

    EXEC master.dbo.sp_replicationdboption 
      @dbname = @PublisherDBName, 
      @optname = N'publish', 
      @value = N'false';
    GO

    sp_helpreplicationdb

    use [master]
    exec sp_dropdistributor @no_checks = 1
    GO
    
	EXEC sp_dropdistributiondb 'distribution'; 
	
	EXEC sp_dropdistributor; 
	
    "
    Write-Output $query
}

function Drop-Replication-cleanup {
    param ($Data_DB_Name)

    $query = "
    
    IF EXISTS (SELECT 1 FROM [development_db].sys.procedures WHERE name = 'dropreplication')
	BEGIN
		DROP PROCEDURE [development_db].sys.procedures WHERE name = 'dropreplication'
	END
	GO
	CREATE PROCEDURE [dbo].[DropReplication]
		@PublisherDBName NVARCHAR(500)
	AS
	BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		DECLARE @sql NVARCHAR(max)
		IF EXISTS (SELECT 1 FROM distribution.dbo.MSpublications WHERE publisher_db = @PublisherDBName)
		BEGIN
		SET @sql = 'USE ['  + @PublisherDBName + '] 
		DECLARE @PublisherDBName NVARCHAR(max) = ''' + @PublisherDBName + '''
	DECLARE @Publication NVARCHAR(max)
	DECLARE @LogReaderAgentJobName NVARCHAR(max)
	DECLARE @SubscriberDBName nvarchar(max)

	select distinct @SubscriberDBName =  subscriber_db
	FROM distribution.dbo.MSsubscriptions
	WHERE publisher_db = ''' + @PublisherDBName + '''
	and subscriber_db <> ''virtual''

	SELECT @Publication = publication
	FROM distribution.dbo.MSpublications
	WHERE publisher_db = @PublisherDBName

	SELECT @LogReaderAgentJobName = name
	FROM distribution.dbo.MSlogreader_agents
	WHERE publisher_db = @PublisherDBName

	PRINT @LogReaderAgentJobName + '' '' + @Publication

	EXEC msdb.dbo.sp_stop_job @job_name = @LogReaderAgentJobName

	EXEC sp_dropsubscription  @publication= ''all''
		,@article= ''all''
	, @subscriber= ''all''
	, @destination_db= NULL

	EXEC sys.sp_droppublication @publication = ''all''

	EXEC master.dbo.sp_replicationdboption 
	  @dbname = @PublisherDBName, 
	  @optname = N''publish'', 
	  @value = N''false'';

	  EXEC sp_removedbreplication @SubscriberDBName
	'
	EXEC (@sql)
	END
	END

    exec [development_db].dbo.dropreplication @PublisherDBName = N'$Data_DB_Name' 
    "
    Write-Output $query
}

function Alter-Identity {
    param ($DE_DB_Name)

    $query = "
    
    USE [$DE_DB_Name]
    -------Change All columns identyty values--------
    declare @tname varchar(200),@cname varchar(200)
    declare @outccount int 
    declare @SQLString nvarchar(500);
    declare @ParmDefinition nvarchar(25);
    declare @CountSQLQuery varchar(30);

    declare  SCRIPT cursor for 
    SELECT   ic.name, t.name--,ic.last_value
    FROM sys.identity_columns ic,sys.tables t
    where ic.object_id=t.object_id and t.name in (SELECT   A.[article]    
														    FROM [distribution].[dbo].[MSarticles] AS A
														    INNER JOIN [distribution].[dbo].[MSpublications] AS P
															      ON (A.[publication_id] = P.[publication_id])
															    WHERE p.publication='DATA_TO_DE_REPL_Staging_20151203')
    OPEN SCRIPT

    FETCH NEXT FROM SCRIPT 
    INTO @cname,@tname

    WHILE @@FETCH_STATUS = 0
    BEGIN

    SET @SQLString = 'SELECT @result=MAX('+@cname+') from ['+@tname+']';
    SET @ParmDefinition = N'@result int OUTPUT';
    print @SQLString
    EXECUTE sp_executesql @SQLString, @ParmDefinition, @result=@outccount OUTPUT;
    if (@outccount>1)
    begin
    print 'count:'+cast (@outccount as varchar)
    print 'DBCC CHECKIDENT ('+@tname+', RESEED, '+cast(@outccount as varchar)+');'
    DBCC CHECKIDENT (@tname, RESEED,@outccount);
    end
    else
    begin
    DBCC CHECKIDENT (@tname, RESEED,0);
    print 'count:'+cast (@outccount as varchar)
    print 'DBCC CHECKIDENT ('+@tname+', RESEED, 0);'
    end
    FETCH NEXT FROM SCRIPT 
    INTO @cname,@tname
    END

    CLOSE SCRIPT;
    DEALLOCATE SCRIPT;

    "
    Write-Output $query
}

function Configure-ReplHistory {
    param ($DE_DB_Name)
    $query = "

    USE [$DE_DB_Name]	
    --------------Alter all replication procedures for ReplicationHistory---------------

    DECLARE @text  NVARCHAR(MAX)
    DECLARE @text1  NVARCHAR(MAX)
    DECLARE @name  varchar(200)
    DECLARE @tname varchar(200)
    DECLARE @addscript nvarchar(max)
    DECLARE curHelp CURSOR 
    FOR
    select replace(sc.text,'create procedure','alter procedure'),t.name from syscomments sc,sys.all_objects  t
     where
     sc.id=t.object_id and t.name like 'sp_MS%' and sc.text not like '%replicationhistory%'

    OPEN curHelp

    FETCH next FROM curHelp INTO @text,@name

    WHILE @@FETCH_STATUS = 0
    BEGIN
 
 
     select @tname=substring(@name,13,len(@name)-12)
     set @addscript='		
    if not exists(select tablename from dbo.Replicationhistory where tablename='''+@tname+''' )
    insert into dbo.Replicationhistory(tablename,DateUpdated)
    values('''+@tname+''',getdate())
    else
    update Replicationhistory
    set DateUpdated=getdate()
    where tablename='''+@tname+''+'''
    end' 
    
    set @text1=concat(reverse(right(reverse(@text),len(@text)-charindex('dne', reverse(@text))-2)),@addscript)

    --print @text1
    exec( @text1 )
    --print '---'

    FETCH next FROM curHelp INTO @text,@name
    END

    CLOSE curHelp
    DEALLOCATE curHelp

    "
    Write-Output $query
}

function Fix-FK {
    param ($DE_DB_Name)

    $query = "

    USE [$DE_DB_Name]
    CREATE TABLE #x -- feel free to use a permanent table
    (
      drop_script NVARCHAR(MAX),
      create_script NVARCHAR(MAX)
    );
  
    DECLARE @drop   NVARCHAR(MAX) = N'',
            @create NVARCHAR(MAX) = N'';

    -- drop is easy, just build a simple concatenated list from sys.foreign_keys:
    SELECT @drop += N'
    ALTER TABLE ' + QUOTENAME(cs.name) + '.' + QUOTENAME(ct.name) 
        + ' DROP CONSTRAINT ' + QUOTENAME(fk.name) + ';'
    FROM sys.foreign_keys AS fk
    INNER JOIN sys.tables AS ct
      ON fk.parent_object_id = ct.[object_id]
    INNER JOIN sys.schemas AS cs 
      ON ct.[schema_id] = cs.[schema_id]
      where fk.Is_Not_Trusted = 1  ;

    INSERT #x(drop_script) SELECT @drop;

    -- create is a little more complex. We need to generate the list of 
    -- columns on both sides of the constraint, even though in most cases
    -- there is only one column.
    SELECT @create += N'
    ALTER TABLE ' 
       + QUOTENAME(cs.name) + '.' + QUOTENAME(ct.name) 
       + ' ADD CONSTRAINT ' + QUOTENAME(fk.name) 
       + ' FOREIGN KEY (' + STUFF((SELECT ',' + QUOTENAME(c.name)
       -- get all the columns in the constraint table
        FROM sys.columns AS c 
        INNER JOIN sys.foreign_key_columns AS fkc 
        ON fkc.parent_column_id = c.column_id
        AND fkc.parent_object_id = c.[object_id]
        WHERE fkc.constraint_object_id = fk.[object_id]
        ORDER BY fkc.constraint_column_id 
        FOR XML PATH(N''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 1, N'')
      + ') REFERENCES ' + QUOTENAME(rs.name) + '.' + QUOTENAME(rt.name)
      + '(' + STUFF((SELECT ',' + QUOTENAME(c.name)
       -- get all the referenced columns
        FROM sys.columns AS c 
        INNER JOIN sys.foreign_key_columns AS fkc 
        ON fkc.referenced_column_id = c.column_id
        AND fkc.referenced_object_id = c.[object_id]
        WHERE fkc.constraint_object_id = fk.[object_id]
        ORDER BY fkc.constraint_column_id 
        FOR XML PATH(N''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 1, N'') + ');'
    FROM sys.foreign_keys AS fk
    INNER JOIN sys.tables AS rt -- referenced table
      ON fk.referenced_object_id = rt.[object_id]
    INNER JOIN sys.schemas AS rs 
      ON rt.[schema_id] = rs.[schema_id]
    INNER JOIN sys.tables AS ct -- constraint table
      ON fk.parent_object_id = ct.[object_id]
    INNER JOIN sys.schemas AS cs 
      ON ct.[schema_id] = cs.[schema_id]
    WHERE rt.is_ms_shipped = 0 AND ct.is_ms_shipped = 0
    and fk.Is_Not_Trusted = 1;

    UPDATE #x SET create_script = @create;

    PRINT @drop;
    PRINT @create;
        
    EXEC sp_executesql @drop
    -- clear out data etc. here
    EXEC sp_executesql @create;
    
    drop table #x

    "
    Write-Output $query
}

function Use-RunAs 
{    
    # Check if script is running as Adminstrator and if not use RunAs 
    # Use Check Switch to check if admin 
     
    param([Switch]$Check) 
     
    $IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()` 
        ).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") 
         
    if ($Check) { return $IsAdmin }     
 
    if ($MyInvocation.ScriptName -ne "") 
    {  
        if (-not $IsAdmin)  
        {  
            try 
            {  
                $arg = "-file `"$($MyInvocation.ScriptName)`"" 
                Start-Process "$psHome\powershell.exe" -Verb Runas -ArgumentList $arg -ErrorAction 'stop'  
            } 
            catch 
            { 
                Write-Warning "Error - Failed to restart script with runas"  
                break               
            }
            exit # Quit this session of powershell 
        }  
    }  
    else  
    {  
        Write-Warning "Error - Script must be saved as a .ps1 file first"  
        break  
    }  
} 

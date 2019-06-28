
declare @namep VARCHAR(256)
declare @sql VARCHAR(8000)
declare c1 cursor for SELECT name FROM sys.databases where name not in ('master','model','msdb','tempd')
    open c1
    fetch next from c1 into @namep
    While @@fetch_status <> -1
      begin
      --bulk insert won't take a variable name, so make a sql and execute it instead:
       set @sql ='declare @newdatabase VARCHAR(256)'+ CHAR(13)+
	   'SET @newdatabase ='''+ @namep+''''+CHAR(13)+ 

'EXEC  [DBAMonitor].[dbo].[SEC_sp_DropUsers] @newdatabase
EXEC  [DBAMonitor].[dbo].[SEC_sp_DropRoles] @newdatabase
EXEC  [DBAMonitor].[dbo].[SEC_sp_createidmdaduser] @newdatabase
EXEC  [DBAMonitor].[dbo].[SEC_sp_CreateRoles] @newdatabase
EXEC  [DBAMonitor].[dbo].[SEC_sp_CreateLoginsAndUsers] @newdatabase'+ CHAR (13)




    print @sql
   exec (@sql)

      fetch next from c1 into @namep
      end
    close c1
    deallocate c1


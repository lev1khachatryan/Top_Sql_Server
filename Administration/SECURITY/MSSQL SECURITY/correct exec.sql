declare @newdatabase VARCHAR(256)
SET @newdatabase = 

EXEC  [DBAMonitor].[dbo].[SEC_sp_DropUsers] @newdatabase
EXEC  [DBAMonitor].[dbo].[SEC_sp_DropRoles] @newdatabase
EXEC  [DBAMonitor].[dbo].[SEC_sp_createidmdaduser] @newdatabase
EXEC  [DBAMonitor].[dbo].[SEC_sp_CreateRoles] @newdatabase
EXEC  [DBAMonitor].[dbo].[SEC_sp_CreateLoginsAndUsers] @newdatabase
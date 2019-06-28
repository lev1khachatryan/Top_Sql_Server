-- replicationy miacnum enq `
EXEC sp_replicationdboption @dbname = N'AdventureWorks2014_ddxk', @optname = N'publish', @value = N'true'

-- anjatum enq `
EXEC sp_replicationdboption @dbname = N'AdventureWorks2014_ddxk', @optname = N'publish', @value = N'false'


-- vercnum enq ayn DB-nery  , voronc vra replication ka miacrac

select name, is_published, is_subscribed, is_merge_published, is_distributor
from sys.databases
where is_published = 1 or is_subscribed = 1 or
is_merge_published = 1 or is_distributor = 1


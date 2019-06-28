--DBCC SHRINKFILE ()


SELECT  DB_NAME(mf.database_id) AS DatabaseName ,
        SUSER_SNAME(owner_sid) AS OwnerName ,
        mf.name AS LogicalFileName ,
        mf.physical_name AS PhysicalFileName ,
        mf.type_desc
FROM    sys.master_files AS mf
        LEFT JOIN sys.databases AS db ON mf.database_id = db.database_id;
GO


SELECT name ,
       SUSER_SNAME(owner_sid) AS 'owner' , *
FROM   sys.databases;

--SELECT  u.name
--FROM    YourDB.sys.syslogins l
--        INNER JOIN YourDB.sys.sysusers u ON l.sid = u.sid
--WHERE   l.loginname = ANY ( SELECT  *
--                            FROM    sys.server_principals
--                            WHERE   type_desc = 'WINDOWS_GROUP'
--                                    AND IS_MEMBER(name) = 1 );

-- Generate script to alter the ownership of the databases
--SELECT 'IF EXISTS(SELECT name FROM sys.server_principals WHERE name = ''' 
--  + P.name + ''') ALTER AUTHORIZATION ON DATABASE::[' + D.name +
--  '] TO [' + P.name + '];
--GO'
--FROM sys.databases D
--  JOIN sys.server_principals P
--    ON D.owner_sid = P.sid
--WHERE D.name NOT IN ('master', 'model', 'msdb', 'tempdb')
--ORDER BY D.name;

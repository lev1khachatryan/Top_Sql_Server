SELECT name,crdate 
FROM master..sysdatabases
where crdate<'2013-07-30 21:25:38.357' and (name like 'IDM-Kb%' or name like 'IDM-Data%')

order by crdate


SELECT d.name,
ROUND(SUM(mf.size) * 8 / 1024, 0) Size_MBs
FROM sys.master_files mf
INNER JOIN sys.databases d ON d.database_id = mf.database_id
WHERE d.database_id > 4 and d.name in (SELECT name
--name,crdate 
FROM master..sysdatabases
where crdate<'2013-07-30 21:25:38.357' and (name like 'IDM-Kb%' or name like 'IDM-Data%')
)
GROUP BY d.name
ORDER BY d.name
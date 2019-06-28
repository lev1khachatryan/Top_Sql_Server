SELECT Blocker.text '–', Blocker.*, *
FROM sys.dm_exec_connections AS Conns
INNER JOIN sys.dm_exec_requests AS BlockedReqs
    ON Conns.session_id = BlockedReqs.blocking_session_id
INNER JOIN sys.dm_os_waiting_tasks AS w
    ON BlockedReqs.session_id = w.session_id
CROSS APPLY sys.dm_exec_sql_text(Conns.most_recent_sql_handle) AS Blocker


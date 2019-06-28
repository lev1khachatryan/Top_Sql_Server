USE [master]
GO

/****** Object:  DdlTrigger [IDMDADISERDENY]    Script Date: 8/2/2013 5:43:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE TRIGGER [IDMDADISERDENY]
ON ALL SERVER --WITH EXECUTE AS 'idmdaduser'
FOR LOGON
AS
BEGIN

IF ORIGINAL_LOGIN()= 'idmdaduser' AND
(SELECT client_interface_name
FROM sys.dm_exec_sessions
WHERE  session_id = @@SPID and
is_user_process = 1
AND original_login_name = 'IDMDADUSER'
)
='.Net SqlClient Data Provider'

ROLLBACK;

END




GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

ENABLE TRIGGER [IDMDADISERDENY] ON ALL SERVER
GO



USE master;
GRANT EXECUTE on xp_cmdshell to [SIS\Team DB]
EXEC sp_xp_cmdshell_proxy_account NULL
EXEC sp_xp_cmdshell_proxy_account 'sis\mariam.barkhudaryan', 'qwaszx9865'




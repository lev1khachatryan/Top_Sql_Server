cd c:\perf\
mysqlcheck -u root -proot25 --optimize --all-databases >c:\perf\log\optimize_table_log.txt
mysqlcheck -u root -proot25 --analyze --all-databases >c:\perf\log\analize_table_log.txt
powershell -file "C:\Perf\sendmail.ps1" >> c:\perf\mail_log.txt
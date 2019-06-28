for %G in (.bak) do forfiles /p "D:\MSSQL\Backup" /s /m *%G  /d -190 /c "cmd /c  rar a -ad   @fname__oldr.rar @path && del "@path""
forfiles /p "D:\MSSQL\Backup" /s /m *  /d -190 /c "cmd /c if @fname == @FILE (rar a -ad   @fname__old.rar @path && del "@path")"

set pagesize 0
set linesize 1500
set feedback off
set term off
SET VERIFY OFF
set serveroutput on size 1000000
column vpath new_value new_vpath
column dt new_value new_dt 
column ext new_value new_ext
column awr new_value new_awr
select 'C:\PERF\' vpath,'awr_' awr, to_char(sysdate,'YYYYMMDD') dt,'.html' ext from dual; 
spool &new_vpath&new_awr&new_dt&new_ext
variable begin_snap number
variable end_snap number
exec select max(snap_id) into :end_snap from dba_hist_snapshot;
exec select max(snap_id)-7 into :begin_snap from dba_hist_snapshot;
select output from table(dbms_workload_repository.awr_report_html(3765453767, 1, :begin_snap, :end_snap, 0 ));
SPOOL OFF
set linesize 150
set serveroutput on size 10000
column vpath1 new_value new_vpath1
column dt1 new_value new_dt1 
column ext1 new_value new_ext1
column sql_id new_value new_sql_id
select 'C:\PERF\' vpath1,'sql_id_' sql_id, to_char(sysdate,'YYYYMMDD') dt1,'.txt' ext1 from dual;
spool &new_vpath1&new_sql_id&new_dt1&new_ext1 
SELECT parsing_schema_name,
sql_id
FROM v$sql;
spool off
column vpath2 new_value new_vpath2
column dt2 new_value new_dt2 
column ext2 new_value new_ext2
column blocking_sessions new_value new_blocking_sessions
select 'C:\PERF\' vpath2,'blocking_sessions_' blocking_sessions, to_char(sysdate,'YYYYMMDD') dt2,'.txt' ext2 from dual;
spool &new_vpath2&new_blocking_sessions&new_dt2&new_ext2 
SELECT  distinct (select username from dba_users where user_id=a.user_id) schema_name, s.sql_text 
FROM  GV$ACTIVE_SESSION_HISTORY a  ,gv$sql s
where a.sql_id=s.sql_id
and blocking_session is not null
and a.user_id <> 0 
and a.sample_time > sysdate - 1;
spool off
quit




















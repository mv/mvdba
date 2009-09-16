rem $DBA/waitstat.sql
rem
rem Creates a report (waitstat.lst) of all session waits, and either system or
rem session event statistics) in the database for one or all Oracle Session IDs.
rem
rem Parameters:
rem	&1 = Session ID to print report for (or 0 for all sessions)
rem	     (If zero, system event statistics will also be pronted).
rem	     (If nonzero, session event statistics will also be pronted).
rem
rem Restrictions:
rem	1) Oracle 7.3 required, since SECONDS_IN_WAIT and BLOCK columns are
rem	   accessed.
rem	2) Oracle 7.2 required, since STATE column is accessed.
rem
rem <<<<<<<<<<<<<<<<<<< MODIFICATION HISTORY >>>>>>>>>>>>>>>>>>>
rem 04/03/98 Brian Lomasky	Change time headings from .001 to .01 seconds.
rem 03/06/98 Brian Lomasky	Added additional decoding of wait events.
rem				  Reformat.
rem 03/03/97 Brian Lomasky	Original
rem
set echo off
set feedback off
set heading off
set pagesize 0
set verify off
set termout off
drop table wait_stat_temp;
set termout on
create table wait_stat_temp (lineno NUMBER, text VARCHAR2(80));
declare
	cursor init_cursor is
		select name, to_char(sysdate, 'MM/DD/YY')
		from v$database;
	cursor session_wait_cursor is
		select /*+ use_nl(w,s) */
			w.sid,
			s.username,
			w.event,
			w.p1,
			w.p2,
			w.p3,
			decode(w.state,
				'WAITING',
					substr(to_char(w.seconds_in_wait,
					'9999999'), 2),
				'WAITING UNKNOWN TIME',
					'      ?',
				'WAITED SHORT TIME',
					'   < 10',
				'WAITED KNOWN TIME',
					substr(to_char(w.wait_time,
					'9999999'), 2),
				'???????'),
			decode(w.state,
				'WAITING',
					'CURR',
				'WAITING UNKNOWN TIME',
					' ',
				'WAITED SHORT TIME',
					' ',
				'WAITED KNOWN TIME',
					'prev',
				'????'),
			s.paddr,
			s.type
		from v$session_wait w, v$session s
		where w.sid = s.sid and (to_char(w.sid) = '&&1' or '&&1' = '0')
		and s.status = 'ACTIVE' and w.event <> 'rdbms ipc message' and
		w.event <> 'smon timer' and
		w.event <> 'SQL*Net message from client'
		order by 1;
	cursor session_cursor is
		select sid, username, paddr
		from v$session
		where to_char(sid) = '&&1';
	cursor session_event_cursor (my_sid in number) is
		select event, total_waits, total_timeouts, time_waited,
			average_wait
		from v$session_event
		where sid = my_sid
		order by 1;
	cursor background_process_cursor (my_paddr in raw) is
		select name
		from v$bgprocess
		where paddr = my_paddr;
	cursor dba_data_files_cursor (my_p1 in number) is
		select tablespace_name
		from sys.dba_data_files
		where file_id = my_p1;
	cursor latch_cursor (my_latch# in number) is
		select name
		from v$latchname
		where latch# = my_latch#;
	cursor locks_cursor (my_lock_name in varchar2) is
		select sid,
			id1,
			id2,
			decode(lmode,
				1, 'null',
				2, 'Read',
				3, 'Writ',
				4, 'PrRd',
				5, 'PrWr',
				6, 'Excl',
				'????'),
			block
		from v$lock
		where type = my_lock_name and lmode > 0;
	cursor system_event_cursor is
		select event, total_waits, total_timeouts, time_waited,
			average_wait
		from v$system_event
		where total_waits > 0
		order by total_waits desc;
	lv_name			sys.v_$database.name%TYPE;
	lv_today		varchar2(8);
	lv_username		sys.v_$session.username%TYPE;
	lv_paddr		sys.v_$session.paddr%TYPE;
	lv_type			sys.v_$session.type%TYPE;
	lv_event		sys.v_$session_event.event%TYPE;
	lv_event29		char(29);
	lv_total_waits		sys.v_$session_event.total_waits%TYPE;
	lv_total_timeouts	sys.v_$session_event.total_timeouts%TYPE;
	lv_time_waited		sys.v_$session_event.time_waited%TYPE;
	lv_average_wait		sys.v_$session_event.average_wait%TYPE;
	lv_sid			sys.v_$session_wait.sid%TYPE;
	lv_p1			sys.v_$session_wait.p1%TYPE;
	lv_p2			sys.v_$session_wait.p2%TYPE;
	lv_p3			sys.v_$session_wait.p3%TYPE;
	lv_wait_string		varchar2(10);
	lv_waitis_string	varchar2(4);
	lv_tablespace_name	sys.dba_data_files.tablespace_name%TYPE;
	lv_latch_name		sys.v_$latchname.name%TYPE;
	do_dba_file		boolean;
	do_locks		boolean;
	head			boolean;
	lock_name		varchar2(2);
	lock_mode		number;
	lv_id1			sys.v_$lock.id1%TYPE;
	lv_id2			sys.v_$lock.id2%TYPE;
	mode_desc		varchar2(4);
	lv_block		sys.v_$lock.block%TYPE;
	lv_sevent		sys.v_$system_event.event%TYPE;
	lv_event31		char(31);
	lv_stotal_waits		sys.v_$system_event.total_waits%TYPE;
	lv_stotal_timeouts	sys.v_$system_event.total_timeouts%TYPE;
	lv_stime_waited		sys.v_$system_event.time_waited%TYPE;
	lv_saverage_wait	sys.v_$system_event.average_wait%TYPE;
	contention		number;
	lv_lineno		number;
	a_lin			varchar2(80);

	function wri(x_lin in varchar2, x_str in varchar2, x_force in number)
		return varchar2 is
	begin
		if length(x_lin) + length(x_str) > 79 then
			lv_lineno := lv_lineno + 1;
			insert into wait_stat_temp values (lv_lineno, x_lin);
			if x_force = 0 then
				return '          ' || x_str;
			else
				lv_lineno := lv_lineno + 1;
				insert into wait_stat_temp values
					(lv_lineno, '          ' || x_str);
				return '';
			end if;
		else
			if x_force = 0 then
				return x_lin||x_str;
			else
				lv_lineno := lv_lineno + 1;
				insert into wait_stat_temp values (
					lv_lineno, x_lin || x_str);
				return '';
			end if;
		end if;
	end wri;
begin
	a_lin := '';
	lv_lineno := 0;
	open init_cursor;
	fetch init_cursor into lv_name, lv_today;
	if init_cursor%NOTFOUND then
		lv_name := '????';
		lv_today := '??/??/??';
	end if;
	close init_cursor;
	a_lin := wri(a_lin, rpad('Database: ' || lv_name, 28) ||
		'SESSION WAIT STATISTICS' || lpad(lv_today, 29), 1);
	a_lin := wri(a_lin, '', 1);
	a_lin := wri(a_lin, '                                           ' ||
		'            Wait Wait', 1);
	a_lin := wri(a_lin, '  SID Username     Event                   ' ||
		'           hsecs  is', 1);
	a_lin := wri(a_lin, '----- ------------ ------------------------' ||
		'-------- ------- ----', 1);
	open session_wait_cursor;
	loop
		fetch session_wait_cursor into
			lv_sid,
			lv_username,
			lv_event,
			lv_p1,
			lv_p2,
			lv_p3,
			lv_wait_string,
			lv_waitis_string,
			lv_paddr,
			lv_type;
		exit when session_wait_cursor%NOTFOUND;
		-- See if we found a background process:
		if lv_type = 'BACKGROUND' then
			open background_process_cursor(lv_paddr);
			fetch background_process_cursor into lv_username;
			if background_process_cursor%NOTFOUND then
				lv_username := '<n/a>';
			end if;
			close background_process_cursor;
		end if;
		if lv_username is null then
			lv_username := '<null>';
		end if;
		a_lin := wri(a_lin,
			rpad(substr(to_char(lv_sid, '99999'), 2), 5) ||
			' ' || rpad(substr(lv_username, 1, 12), 12) || ' ' ||
			rpad(substr(lv_event, 1, 32), 32) || ' ' ||
			rpad(substr(lv_wait_string, 1, 7), 7) || ' ' ||
			rpad(substr(lv_waitis_string, 1, 4), 4), 1);
		do_locks := false;
		do_dba_file := false;
		if lv_event = 'db file sequential read' then
			do_dba_file := true;
		elsif lv_event = 'db file scattered read' then
			do_dba_file := true;
		elsif lv_event = 'DFS enqueue lock acquisition' then
			do_locks := true;
		elsif lv_event = 'DFS lock acquisition' then
			do_locks := true;
		elsif lv_event = 'DFS lock handle' then
			do_locks := true;
		elsif lv_event = 'latch free' then
			open latch_cursor(lv_p2);
			fetch latch_cursor into lv_latch_name;
			if latch_cursor%FOUND then
				a_lin := wri(a_lin,
					'                        Latch ' ||
					lv_latch_name, 0);
				a_lin := wri(a_lin, ' (# of sleeps = ' ||
					to_char(lv_p3) || ')', 1);
			end if;
			close latch_cursor;
		end if;
		if do_dba_file then
			open dba_data_files_cursor(lv_p1);
			fetch dba_data_files_cursor into lv_tablespace_name;
			if dba_data_files_cursor%FOUND then
				a_lin := wri(a_lin,
					'                   Tablespace ' ||
					lv_tablespace_name, 0);
				a_lin := wri(a_lin, ' (File ID ' ||
					to_char(lv_p1) || ', block ' ||
					to_char(lv_p2) || ')', 1);
			end if;
			close dba_data_files_cursor;
		end if;
		if do_locks then
			lock_name := chr(bitand(lv_p1, -16777216) / 16777215) ||
				chr(bitand(lv_p1, 16711680) / 65535);
			lock_mode := bitand(lv_p1, 65536);
			a_lin := wri(a_lin,
				'                   Trying to enqueue lock' ||
				' type ' || lock_name || ', mode ' ||
				to_char(lock_mode), 1);
			head := false;
			open locks_cursor(lock_name);
			loop
				fetch locks_cursor into
					lv_sid, lv_id1, lv_id2, mode_desc,
					lv_block;
				exit when locks_cursor%NOTFOUND;
				if not head then
					head := true;
					a_lin := wri(a_lin, '             ' ||
						'      Blocked by lock(s):', 1);
				end if;
				a_lin := wri(a_lin,
					'                        SID ' ||
					rpad(substr(to_char(lv_sid, '99999'),
					2), 5) || ' Mode ' || mode_desc, 0);
				if lv_block = 0 then
					a_lin := wri(a_lin, ' non-blocking', 1);
				elsif lv_block = 1 then
					a_lin := wri(a_lin, ' ** BLOCKING **',
						1);
				else
					a_lin := wri(a_lin, '', 1);
				end if;
			end loop;
			close locks_cursor;
		end if;
	end loop;
	close session_wait_cursor;
	-- See if all events wanted
	if '&&1' = '0' then
		a_lin := wri(a_lin, '', 1);
		a_lin := wri(a_lin, '             ============ SYSTEM-WIDE' ||
			' EVENT STATISTICS ============', 1);
		a_lin := wri(a_lin, '', 1);
		a_lin := wri(a_lin, '                                   ' ||
			'   Total      Total        Time         Avg', 1);
		a_lin := wri(a_lin, 'Event                              ' ||
			'   Waits    Timeouts      Waited        Wait', 1);
		a_lin := wri(a_lin, '------------------------------- ---' ||
			'-------- ----------- ----------- -----------', 1);
		open system_event_cursor;
		loop
			fetch system_event_cursor into
				lv_sevent,
				lv_stotal_waits,
				lv_stotal_timeouts,
				lv_stime_waited,
				lv_saverage_wait;
			exit when system_event_cursor%NOTFOUND;
			lv_event31 := substr(lv_sevent, 1, 31);
			a_lin := wri(a_lin, lv_event31 ||
				to_char(lv_stotal_waits, '99999999990') ||
				to_char(lv_stotal_timeouts, '99999999990') ||
				to_char(lv_stime_waited, '99999999990') ||
				to_char(lv_saverage_wait, '99999999990'), 1);
		end loop;
		close system_event_cursor;
		a_lin := wri(a_lin, '', 1);
		a_lin := wri(a_lin, '-------------------------------------' ||
			'------------------------------------------', 1);
		a_lin := wri(a_lin, '', 1);
	else
		open session_cursor;
		fetch session_cursor into lv_sid, lv_username, lv_paddr;
		if session_cursor%FOUND then
			-- See if we found a background process:
			if lv_username is null then
				open background_process_cursor (lv_paddr);
				fetch background_process_cursor into
					lv_username;
				if background_process_cursor%NOTFOUND then
					lv_username := '<n/a>';
				end if;
				close background_process_cursor;
			end if;
			a_lin := wri(a_lin, '', 1);
			a_lin := wri(a_lin, '              ========== SID:  ' ||
				to_char(lv_sid) || '    Username: ' ||
				lv_username || ' ==========', 1);
			a_lin := wri(a_lin, '', 1);
			a_lin := wri(a_lin,
				'                                    ' ||
				'                       Total         Avg', 1);
			a_lin := wri(a_lin,
				'                                    ' ||
				'                        .01          .01', 1);
			a_lin := wri(a_lin,
				'                                    ' ||
				'Total      Total        secs         secs', 1);
			a_lin := wri(a_lin,
				'Event                               ' ||
				'Waits    Timeouts      Waited        Wait', 1);
			a_lin := wri(a_lin,
				'----------------------------- ------' ||
				'----- ----------- ----------- -----------', 1);
			contention := 0;
			open session_event_cursor (lv_sid);
			loop
				fetch session_event_cursor into
					lv_event,
					lv_total_waits,
					lv_total_timeouts,
					lv_time_waited,
					lv_average_wait;
				exit when session_event_cursor%NOTFOUND;
				lv_event29 := substr(lv_event, 1, 29);
				a_lin := wri(a_lin, lv_event29 ||
					to_char(lv_total_waits,
						'99999999990') ||
					to_char(lv_total_timeouts,
						'99999999990') ||
					to_char(lv_time_waited,
						'99999999990') ||
					to_char(round(lv_average_wait),
						'99999999990'), 0);
				-- Contention exists if avg wait is non-zero
				if round(lv_average_wait) <> 0 then
					a_lin := wri(a_lin, ' *', 1);
					contention := 1;
				else
					a_lin := wri(a_lin, '', 1);
				end if;
			end loop;
			close session_event_cursor;
			if contention = 1 then
				a_lin := wri(a_lin, '', 1);
				a_lin := wri(a_lin,
					'   * = Indicates contention', 1);
			end if;
		end if;
		close session_cursor;
	end if;
end;
/

rem
rem Create report
rem
set linesize 80
set termout on
set concat +
spool waitstat.lst
set concat .
select text from wait_stat_temp order by lineno;
spool off
rem
rem Done
rem
drop table wait_stat_temp;
prompt
prompt Created waitstat.lst report for your viewing pleasure...
prompt
exit

rem $DBA/tblsizec.sql
rem
rem This script creates another script (inserts.sql) that contain the INSERT
rem statements required by the tblsize.sql script (except for the initial
rem number of rows and growth per month for each table, and any constraints
rem other than "not null").
rem
rem This can be run for an existing small "test" database, which has the
rem identical structure as a large "production" database that you are
rem planning to create, in order to save lots of typing in order to properly
rem run the tblsize.sql script when creating a differently-sized database
rem than the existing one.
rem
rem The below flag (make_snapshots) can be set to create INSERT statements
rem which can be used by tblsize.sql to create snapshot logs on the local
rem system, and snapshots on a remote system.  (This assumes that simple
rem snapshots are being created).
rem
rem Prompts:
rem	1) Schema name to access.
rem
rem Restrictions:
rem	1) Ensure there is sufficient free space in this user's default
rem	   tablespace for the tablc_temp temporary table.
rem	2) Requires read access to the DBA_TABLES, DBA_TAB_COLUMNS, DBA_INDEXES,
rem	   and DBA_IND_COLUMNS data dictionary tables.
rem	3) Requires that the DBMS_OUTPUT package exist and be executable.
rem	4) In order to use the use_current_size parameter, Oracle 7.2.2.3 or
rem	   later is required, since the DBMS_SQL package must exist and be
rem	   executable by the current username.
rem     5) To run this script on a remote system (in order to gather the master
rem	   table information from the snapshot system), you must manually edit
rem	   this script and add an appropriate "@DATABASE-LINK" specification
rem	   after the following clauses:
rem		"from sys.dba_tables"	  (in the tab_cursor definition)
rem		"from sys.dba_tab_columns"(in the col_cursor definition)
rem		"from sys.dba_indexes"	  (in the tab_ind_cursor definition)
rem		"from sys.dba_tab_columns"(in the column_cursor definition)
rem		"ownr || '.' || tabnam"	  (2 places in the row_counts procedure)
rem	   (==> Search for "APPEND DATABASE LINK" to find the locations <==)
rem	   This will require that the username specified in the database link
rem	   definition have SELECT access to SYS.DBA_TABLES and SYS.DBA_INDEXES
rem	   views, as well as the tables owned by the specified schema, on the
rem	   remote system.
rem
rem <<<<<<<< MODIFICATION HISTORY >>>>>>>>
rem 09/19/97	Brian Lomasky	Also exclude LONG RAW from column_cursor.
rem 12/17/97	Brian Lomasky	Added restriction warning about sufficient free
rem				  space in the default tablespace.  Commented
rem				  out the calls to dbms_sql.last_error_position,
rem				  since it sometimes returned an error where
rem				  none existed.  Allow default values to contain
rem				  an apostrophe.
rem 11/21/97	Brian Lomasky	Added support to create snapshot data and
rem				  extract database block size.
rem 08/28/97	Brian Lomasky	Added use_current_size parameter.
rem 08/25/97	Brian Lomasky	Support for LONG datatypes.  Trap for default
rem				  values containing an apostrophe.
rem 08/20/97	Brian Lomasky	Original
rem
set verify off
set feedback off
set echo off
set pagesize 0
set termout on
set serveroutput on size 100000
def q=chr(39)
def default_initial=1000	/* Default value for initial number of rows */
def default_growth=1		/* Default value for monthly row growth */
def use_current_size=1
rem ****************************************************************************
rem ***** If the use_current_size parameter is set to 1, this script will: *****
rem *****                                                                  *****
rem *****  1) Count the number of rows in each table                       *****
rem *****  2) Calculate the average row size of each table                 *****
rem *****  3) Use the current number of rows as the initial number of rows *****
rem *****     (The default_initial parameter will be ignored)              *****
rem *****  4) Use the average row size value when calculating table sizes  *****
rem *****                                                                  *****
rem ***** If the use_current_size parameter is set to 0, this script will: *****
rem *****                                                                  *****
rem *****  1) Use the default_initial parameter as the initial # of rows   *****
rem *****  2) Use the maximum size of each column as its average size      *****
rem ****************************************************************************
def make_snapshots=1
rem ****************************************************************************
rem ***** If the make_snapshots parameter is set to 1, this script will:   *****
rem *****                                                                  *****
rem *****  1) Extract table and segment data which will be used by tblsize *****
rem *****     to calculate the correct snapshot table and index sizes      *****
rem *****     (This assumes that simple snapshots are being created).      *****
rem *****  2) The tblsize script will also create snapshot logs.           *****
rem *****  3) Force the use_current_size flag to a value of 1.             *****
rem *****                                                                  *****
rem ****************************************************************************
rem
accept schema char prompt 'Enter schema name to be accessed: '

create table tablc_temp (	code VARCHAR2(1),
				lineno NUMBER,
				text VARCHAR2(80));
declare
	cursor blocksize_cursor is select
		value
		from v$parameter
		where name = 'db_block_size';
	cursor tab_cursor is select
		upper(owner),
		upper(table_name),
		pct_free,
		pct_used,
		tablespace_name
		from sys.dba_tables	/* APPEND DATABASE LINK */
		where owner = upper('&&schema') and
		upper(table_name) not like 'SNAP$_%' and
		upper(table_name) not like 'MLOG$_%'
		order by owner, table_name;
	cursor tab_ind_cursor (t_own VARCHAR2, t_nam VARCHAR2) is select
		distinct tablespace_name
		from sys.dba_indexes	/* APPEND DATABASE LINK */
		where table_owner = t_own and table_name = t_nam;
	cursor col_cursor (c_own VARCHAR2, c_tab VARCHAR2) is select
		owner,
		upper(column_name),
		upper(data_type),
		data_length,
		data_precision,
		data_scale,
		default_length,
		nullable,
		data_default,
		column_id
		from sys.dba_tab_columns	/* APPEND DATABASE LINK */
		where table_name = c_tab and owner = c_own
		order by column_id;
	cursor column_cursor (c_own VARCHAR2, c_tab VARCHAR2) is select
		upper(column_name)
		from sys.dba_tab_columns	/* APPEND DATABASE LINK */
		where table_name = c_tab and owner = c_own and data_type <>
		'LONG' and data_type <> 'RAW' and data_type <> 'LONG RAW';
	cursor ind_cursor is select
		a.uniqueness,
		upper(a.owner),
		upper(a.index_name),
		upper(a.table_name),
		decode(nvl(b.constraint_type, '-'), 'P', 1, 2)
		from sys.dba_indexes a, sys.dba_constraints b
		where a.owner = upper('&&schema') and a.table_type = 'TABLE' and
		upper(a.owner) = b.owner (+) and
		upper(a.index_name) = b.constraint_name (+)
		order by a.owner, a.table_name,
		decode(nvl(b.constraint_type, '-'), 'P', 1, 2);
	cursor indcol_cursor (c_own varchar2, c_ind varchar2) is select
		upper(column_name),
		column_position
		from sys.dba_ind_columns
		where index_name = c_ind and index_owner = c_own
		order by column_position;
	cursor now_cursor is select
		to_char(sysdate, 'MM/DD/YY HH:MI:SS')
		from dual;

	lv_db_block_size	varchar2(512);
	lv_owner		sys.dba_tables.owner%TYPE;
	lv_table_name		sys.dba_tables.table_name%TYPE;
	prev_table_name		sys.dba_tables.table_name%TYPE;
	lv_pct_free		sys.dba_tables.pct_free%TYPE;
	lv_pct_used		sys.dba_tables.pct_used%TYPE;
	lv_tablespace_name	sys.dba_tables.tablespace_name%TYPE;
	ind_tablespace_name	sys.dba_tables.tablespace_name%TYPE;
	lv_column_name		sys.dba_tab_columns.column_name%TYPE;
	lv_data_type		sys.dba_tab_columns.data_type%TYPE;
	lv_data_length		sys.dba_tab_columns.data_length%TYPE;
	lv_data_precision	sys.dba_tab_columns.data_precision%TYPE;
	lv_data_scale		sys.dba_tab_columns.data_scale%TYPE;
	lv_default_length	sys.dba_tab_columns.default_length%TYPE;
	lv_nullable		sys.dba_tab_columns.nullable%TYPE;
	lv_data_default		sys.dba_tab_columns.data_default%TYPE;
	lv_column_id		sys.dba_tab_columns.column_id%TYPE;
	lv_uniqueness		sys.dba_indexes.uniqueness%TYPE;
	lv_index_name		sys.dba_indexes.index_name%TYPE;
	lv_table_type		sys.dba_indexes.table_type%TYPE;
	primary_key		number;
	found_index		number;
	lv_column_position	sys.dba_ind_columns.column_position%TYPE;
	lv_lineno		number := 0;
	a_lin			varchar2(80);
	sqltxt			varchar2(2000);
	ind_seq_no		number;
	cursor1			number;
	dummy			number;
	row_cnt			number;
	avg_row_size		number;
	text_len		number;
	last_len		number;
	m			number;
	n			number;
	first_exec		boolean;
	now			varchar2(17);
	num_tables		number;
	error_desc		varchar2(160);
	error_code		number;
	no_blocksize		exception;
	bad_data_type		exception;
	dbms_sql_error		exception;

	function wri(x_lin in varchar2, x_cod in varchar2, x_str in varchar2,
		x_force in number) return varchar2 is
	begin
		if length(x_lin) + length(x_str) > 77 then
			lv_lineno := lv_lineno + 1;
			insert into tablc_temp values (x_cod, lv_lineno, x_lin);
			if x_force = 0 then
				return '   ' || x_str;
			else
				lv_lineno := lv_lineno + 1;
				insert into tablc_temp values (x_cod, lv_lineno,
					'   ' || x_str);
				return '';
			end if;
		else
			if x_force = 0 then
				return x_lin||x_str;
			else
				lv_lineno := lv_lineno + 1;
				insert into tablc_temp values (
					x_cod, lv_lineno, x_lin||x_str);
				return '';
			end if;
		end if;
 	end wri;

	procedure display_time(a_desc IN varchar2) is
	begin
		open now_cursor;
		fetch now_cursor into now;
		dbms_output.put_line(a_desc || now);
		close now_cursor;
	end display_time;

	procedure row_counts(ownr IN varchar2, tabnam IN varchar2,
		num_rows IN OUT number, avg_row_siz IN OUT number) is
	begin
		error_desc := 'begin';
		cursor1 := dbms_sql.open_cursor;
		first_exec := TRUE;
		row_cnt := 0;
		if &make_snapshots = 1 then
			/* Include size of the M_ROW$$ column */
			avg_row_size := 18;
		else
			avg_row_size := 0;
		end if;
		sqltxt := '@';
		last_len := 8 + length(ownr) + length(tabnam);
		error_desc := 'open ' || ownr || '.' || tabnam;
		open column_cursor(ownr, tabnam);
		loop
			error_desc := 'fetch ' || ownr || '.' || tabnam;
			fetch column_cursor into lv_column_name;
			exit when column_cursor%notfound;
			if sqltxt = '@' then
				sqltxt := 'select count(*),';
				text_len := length(sqltxt);
			end if;
			if text_len + length(lv_column_name) + 20 <
				2000 - last_len
			then
				sqltxt := sqltxt || 'avg(nvl(vsize(' ||
					lv_column_name || '),0))+';
				text_len := length(sqltxt);
			else
				/* APPEND DATABASE LINK TO END OF NEXT LINE: */
				sqltxt := sqltxt || '0 from ' || ownr || '.' ||
					tabnam;
				error_desc := 'parse ' || ownr || '.' || tabnam;
				dbms_sql.parse(cursor1, sqltxt, dbms_sql.v7);
				-- error_code := dbms_sql.last_error_position;
				-- if error_code <> 0 then
				--	error_desc := 'error ' || ownr || '.' ||
				--		tabnam;
				--	raise dbms_sql_error;
				-- end if;
				error_desc := 'defc ' || ownr || '.' || tabnam;
				if first_exec then
					dbms_sql.define_column(cursor1, 1, m);
					dbms_sql.define_column(cursor1, 2, n);
				else
					dbms_sql.define_column(cursor1, 1, n);
				end if;
				error_desc := 'exec ' || ownr || '.' || tabnam;
				dummy := dbms_sql.execute(cursor1);
				error_desc := 'frow ' || ownr || '.' || tabnam;
				if dbms_sql.fetch_rows(cursor1) > 0 then
					if first_exec then
						dbms_sql.column_value(cursor1,
							1, m);
						dbms_sql.column_value(cursor1,
							2, n);
						if m is not null then
							row_cnt := row_cnt + m;
						end if;
						if n is not null then
							avg_row_size :=
								avg_row_size +
								n;
						end if;
					else
						dbms_sql.column_value(cursor1,
							1, n);
						if n is not null then
							avg_row_size :=
								avg_row_size +
								n;
						end if;
					end if;
				end if;
				first_exec := FALSE;
				error_desc := 'sel ' || ownr || '.' || tabnam;
				sqltxt := 'select avg(nvl(vsize(' ||
					lv_column_name || '),0))+';
				text_len := length(sqltxt);
			end if;
		end loop;
		close column_cursor;
		if sqltxt <> '@' then
			/* APPEND DATABASE LINK TO END OF NEXT LINE: */
			sqltxt := sqltxt || '0 from ' || ownr || '.' || tabnam;
			error_desc := 'parse2 ' || ownr || '.' || tabnam;
			dbms_sql.parse(cursor1, sqltxt, dbms_sql.v7);
			-- error_code := dbms_sql.last_error_position;
			-- if error_code <> 0 then
			--	raise dbms_sql_error;
			-- end if;
			error_desc := 'definecol' || ownr || '.' || tabnam;
			if first_exec then
				dbms_sql.define_column(cursor1, 1, m);
				dbms_sql.define_column(cursor1, 2, n);
			else
				dbms_sql.define_column(cursor1, 1, n);
			end if;
			error_desc := 'execute ' || ownr || '.' || tabnam;
			dummy := dbms_sql.execute(cursor1);
			error_desc := 'fetchrows ' || ownr || '.' || tabnam;
			if dbms_sql.fetch_rows(cursor1) > 0 then
				if first_exec then
					dbms_sql.column_value(cursor1, 1, m);
					dbms_sql.column_value(cursor1, 2, n);
					if m is not null then
						row_cnt := row_cnt + m;
					end if;
					if n is not null then
						avg_row_size := avg_row_size +
							n;
					end if;
				else
					dbms_sql.column_value(cursor1, 1, n);
					if n is not null then
						avg_row_size := avg_row_size +
							n;
					end if;
				end if;
			end if;
		end if;
		error_desc := 'close ' || ownr || '.' || tabnam;
		dbms_sql.close_cursor(cursor1);
		num_rows := row_cnt;
		avg_row_siz := avg_row_size;
		error_desc := 'exit ' || ownr || '.' || tabnam;
	exception
		when others then
			if dbms_sql.is_open(cursor1) then
				dbms_sql.close_cursor(cursor1);
			end if;
        	        raise_application_error(-20000,
	                        'Unexpected row_counts error ' ||
				to_char(error_code) || ' on ' || ownr || '.' ||
				tabnam || ':' || chr(10) || sqlerrm ||
				chr(10) || 'after: ' || error_desc ||
				chr(10) || 'sqltxt is: ' || sqltxt);
	end row_counts;
begin
	display_time('Starting program at ');
	num_tables := 0;
	open blocksize_cursor;
	fetch blocksize_cursor into lv_db_block_size;
	if blocksize_cursor%notfound then
		raise no_blocksize;
	end if;
	close blocksize_cursor;
	a_lin := '';
	a_lin := wri(a_lin, 'b', 'rem', 1);
	a_lin := wri(a_lin, 'b',
		'rem ******************* DB_BLOCK_SIZE definition' ||
		' *******************', 1);
	a_lin := wri(a_lin, 'b', 'rem Database block size (in bytes)', 1);
	a_lin := wri(a_lin, 'b', 'rem', 1);
	a_lin := wri(a_lin, 'b', 'insert into tbldefb values(' ||
		lv_db_block_size || ');', 1);
	a_lin := wri(a_lin, 't', 'rem', 1);
	a_lin := wri(a_lin, 't', '', 1);
	a_lin := wri(a_lin, 't',
		'rem ********************** Table definitions' ||
		' ***********************', 1);
	a_lin := wri(a_lin, 't', 'rem Owner, TABLE_NAME, TABLESPACE_NAME,' ||
		' Tablespace name for this table' || &q || 's', 1);
	a_lin := wri(a_lin, 't', 'rem   indexes (or ' || &q || &q ||
		' if <tablespace_name>_NDX is to be used), PCTFREE, PCTUSED',
		1);
	a_lin := wri(a_lin, 't', 'rem   max # of rows to size table for,' ||
		' number of rows added per month', 1);
	if &make_snapshots = 1 then
		a_lin := wri(a_lin, 't', 'rem   (Note that snapshot logs are' ||
			' sized for an average of 1000 rows)', 1);
	end if;
	if &use_current_size = 1 or &make_snapshots = 1 then
		a_lin := wri(a_lin, 't',
			'rem   (Using actual row counts and column sizes)', 1);
	end if;
	a_lin := wri(a_lin, 't', 'rem', 1);
	a_lin := wri(a_lin, 'a', 'rem', 1);
	a_lin := wri(a_lin, 'a',
		'rem ******************** Avg Row Size definitions' ||
		' *********************', 1);
	a_lin := wri(a_lin, 'a', 'rem TABLE_NAME, Average Row Size', 0);
	if &make_snapshots = 1 then
		a_lin := wri(a_lin, 'a', ' (including M_ROW$$ rowid)', 0);
	end if;
	a_lin := wri(a_lin, 'a', '', 1);
	a_lin := wri(a_lin, 'a', 'rem   (This overrides the program' ||
		chr(39) || 's calculations of the avg row size for each', 1);
	if &make_snapshots = 0 then
		a_lin := wri(a_lin, 'a', 'rem    of the following tables.' ||
			'  Omit the inserts into tbldefa if you want the', 1);
		a_lin := wri(a_lin, 'a', 'rem    program to calculate the' ||
			' average row size based upon the "Avg size"', 1);
		a_lin := wri(a_lin, 'a', 'rem    values in the following' ||
			' tbldefc table definitions for each column)', 1);
	else
		a_lin := wri(a_lin, 'a', 'rem    of the following tables)', 1);
	end if;
	a_lin := wri(a_lin, 'a', 'rem', 1);
	a_lin := wri(a_lin, 'c', 'rem', 1);
	a_lin := wri(a_lin, 'c', 'rem ********************** Column' ||
		' definitions ***********************', 1);
	a_lin := wri(a_lin, 'c', 'rem TABLE_NAME, COLUMN_NAME,', 1);
	a_lin := wri(a_lin, 'c', 'rem   DATATYPE (nx=NUMBER' ||
		' (x=number of digits), vx=VARCHAR2 (x=number of', 1);
	a_lin := wri(a_lin, 'c', 'rem   characters), cx=CHAR' ||
		' (x=number of characters), d=DATE, l=LONG),', 1);
	a_lin := wri(a_lin, 'c', 'rem   Avg size (if VARCHAR2 or' ||
		' LONG) or average number of digits (if NUMBER),', 1);
	a_lin := wri(a_lin, 'c', 'rem   Number of decimal digits' ||
		' (if NUMBER)', 1);
	a_lin := wri(a_lin, 'c', 'rem', 1);
	if &make_snapshots = 0 then
		a_lin := wri(a_lin, 'f', 'rem', 1);
		a_lin := wri(a_lin, 'f', 'rem ********************** Default' ||
			' definitions ***********************', 1);
		a_lin := wri(a_lin, 'f', 'rem TABLE_NAME, COLUMN_NAME,' ||
			' DEFAULT value', 1);
		a_lin := wri(a_lin, 'f', 'rem', 1);
		a_lin := wri(a_lin, 'x', 'rem', 1);
		a_lin := wri(a_lin, 'x', 'rem **********************' ||
			' Constraint definitions ***********************', 1);
		a_lin := wri(a_lin, 'x', 'rem TABLE_NAME, COLUMN_NAME,' ||
			' CONSTRAINT_DEF (any column constraint text to be', 1);
		a_lin := wri(a_lin, 'x',
			'rem   included in the SQL "CREATE TABLE" statement)',
			1);
		a_lin := wri(a_lin, 'x', 'rem', 1);
		a_lin := wri(a_lin, 'i', 'rem', 1);
		a_lin := wri(a_lin, 'i', 'rem ********************** Index' ||
			' definitions ***********************', 1);
		a_lin := wri(a_lin, 'i', 'rem TABLE_NAME, Index name (or ' ||
			&q || &q || ' if IND_<tablename>_nn is to be used;' ||
			' nn is', 1);
		a_lin := wri(a_lin, 'i', 'rem   the two-digit Index' ||
			' sequence number; Primary key will be 01),', 1);
		a_lin := wri(a_lin, 'i',
			'rem   COLUMN_NAME, Index sequence number,', 1);
		a_lin := wri(a_lin, 'i', 'rem   Index Type (p=Primary key,' ||
			' u=Unique key, b=Bitmap, i=Nonunique index),', 1);
		a_lin := wri(a_lin, 'i',
			'rem   Position number of field in a concatenated' ||
			' index', 1);
		a_lin := wri(a_lin, 'i', 'rem', 1);
	else
		a_lin := wri(a_lin, 'i', 'rem', 1);
		a_lin := wri(a_lin, 'i', 'rem ****************** Snapshot' ||
			' Index definitions ******************', 1);
		a_lin := wri(a_lin, 'i', 'rem SNAPSHOT_NAME, ' ||
			&q || &q || ', ' || &q || 'M_ROW$$' || &q ||
			', 1, ' || &q || 'i' || &q || ', 1', 1);
		a_lin := wri(a_lin, 'i', 'rem', 1);
		a_lin := wri(a_lin, 's', 'rem', 1);
		a_lin := wri(a_lin, 's', 'rem ********** Database Link used' ||
			' on the remote  **********', 1);
		a_lin := wri(a_lin, 's', 'rem ********** system to access' ||
			' the master table **********', 1);
		a_lin := wri(a_lin, 's', 'rem **********      (Example:  ' ||
			'PROD.WORLD)       **********', 1);
		a_lin := wri(a_lin, 's', 'rem', 1);
		a_lin := wri(a_lin, 's', 'insert into tbldefk values(', 0);
		a_lin := wri(a_lin, 's', &q ||
			'INSERT NAME OF DATABASE LINK HERE' || &q || ');', 1);
		a_lin := wri(a_lin, 's', 'rem', 1);
		a_lin := wri(a_lin, 's', 'rem Note:  THE PRESENCE OF ANY' ||
			' ROWS IN TBLDEFK WILL CAUSE TBLSIZE TO CREATE', 1);
		a_lin := wri(a_lin, 's', 'rem        ONLY SNAPSHOT LOGS AND' ||
			' SNAPSHOTS, INSTEAD OF ITS NORMAL TABLES,', 1);
		a_lin := wri(a_lin, 's',
			'rem        INDEXES, CONSTRAINTS, ETC.', 1);
		a_lin := wri(a_lin, 's', 'rem', 1);
		a_lin := wri(a_lin, 's', 'rem Note:  YOU WILL HAVE TO' ||
			' MANUALLY EDIT THE SNAPSHOT REFRESH CLAUSE AND THE',
			1);
		a_lin := wri(a_lin, 's', 'rem        SNAPSHOT SUBQUERY' ||
			' CLAUSE TO CONFORM TO YOUR SITE' || &q ||
			'S REQUIREMENTS.', 1);
	end if;
	open tab_cursor;
	loop
		fetch tab_cursor into
			lv_owner,
			lv_table_name,
			lv_pct_free,
			lv_pct_used,
			lv_tablespace_name;
		exit when tab_cursor%notfound;
		num_tables := num_tables + 1;
		/* Write insert statements into tbldeft */
		a_lin := wri(a_lin, 't', 'insert into tbldeft values(', 0);
		a_lin := wri(a_lin, 't', &q || lv_owner || &q || ', ', 0);
		a_lin := wri(a_lin, 't', &q || lv_table_name || &q || ', ', 0);
		a_lin := wri(a_lin, 't', &q || lv_tablespace_name || &q || ', ',
			0);
		found_index := 0;
		open tab_ind_cursor (lv_owner, lv_table_name);
		loop
			fetch tab_ind_cursor into ind_tablespace_name;
			exit when tab_ind_cursor%NOTFOUND;
			found_index := found_index + 1;
		end loop;
		close tab_ind_cursor;
		if found_index = 0 or ind_tablespace_name = lv_tablespace_name
		then
			if length(lv_tablespace_name) <= 26 then
				a_lin := wri(a_lin, 't', &q ||
					lv_tablespace_name || '_NDX' || &q ||
					', ', 0);
			else
				a_lin := wri(a_lin, 't', &q ||
					substr(lv_tablespace_name, 1, 26) ||
					'_NDX' || &q || ', ', 0);
			end if;
		elsif found_index = 1 then
			a_lin := wri(a_lin, 't', &q || ind_tablespace_name ||
				&q || ', ', 0);
		else
			a_lin := wri(a_lin, 't', &q || ind_tablespace_name ||
				&q || ', ', 0);
			dbms_output.put_line(
				'>> Warning:  Indexes for the ' ||
				lv_table_name || ' table are stored in');
			dbms_output.put_line(
				'>>           more than one tablespace.');
		end if;
		a_lin := wri(a_lin, 't', to_char(lv_pct_free) || ', ', 0);
		a_lin := wri(a_lin, 't', to_char(lv_pct_used) || ', ', 0);
		if &use_current_size = 1 or &make_snapshots = 1 then
			row_counts(lv_owner, lv_table_name, row_cnt,
				avg_row_size);
			a_lin := wri(a_lin, 't', to_char(row_cnt) || ', ' ||
				&default_growth || ');', 1);
			if avg_row_size <> 0 then
				/* Write insert statements into tbldefa */
				a_lin := wri(a_lin, 'a',
					'insert into tbldefa values(', 0);
				a_lin := wri(a_lin, 'a', &q || lv_table_name ||
					&q || ', ', 0);
				a_lin := wri(a_lin, 'a',
					to_char(round(avg_row_size,0)) || ');',
					1);
			end if;
		else
			a_lin := wri(a_lin, 't', &default_initial || ', ' ||
				&default_growth || ');', 1);
		end if;
		open col_cursor(lv_owner, lv_table_name);
		loop
			fetch col_cursor into
				lv_owner,
				lv_column_name,
				lv_data_type,
				lv_data_length,
				lv_data_precision,
				lv_data_scale,
				lv_default_length,
				lv_nullable,
				lv_data_default,
				lv_column_id;
			exit when col_cursor%notfound;
			/* Write insert statements into tbldefc */
			a_lin := wri(a_lin, 'c',
				'insert into tbldefc values(', 0);
			a_lin := wri(a_lin, 'c', &q || lv_table_name ||
				&q || ', ', 0);
			a_lin := wri(a_lin, 'c', &q || lv_column_name ||
				&q || ', ', 0);
			if lv_data_type = 'CHAR' then
				a_lin := wri(a_lin, 'c', &q || 'c' ||
					to_char(lv_data_length) || &q ||
					', 0, 0);', 1);
			elsif lv_data_type = 'VARCHAR2' then
				a_lin := wri(a_lin, 'c', &q || 'v' ||
					to_char(lv_data_length) || &q ||
					', ', 0);
				a_lin := wri(a_lin, 'c',
					to_char(lv_data_length) ||
					', 0);', 1);
			elsif lv_data_type = 'DATE' then
				a_lin := wri(a_lin, 'c', &q || 'd' ||
					&q || ', 0, 0);', 1);
			elsif lv_data_type = 'LONG' then
				a_lin := wri(a_lin, 'c', &q || 'l' ||
					&q || ', 0, 0);', 1);
			elsif lv_data_type = 'NUMBER' then
				if nvl(lv_data_precision, 0) != 0 then
					if nvl(lv_data_scale, 0) = 0
					then
						a_lin := wri(a_lin, 'c',
							&q || 'n' || to_char(
							lv_data_precision) ||
							&q || ', ' || to_char(
							lv_data_precision) ||
							', 0);', 1);
					else
						a_lin := wri(a_lin, 'c',
							&q || 'n' || to_char(
							lv_data_precision) ||
							&q || ', ' || to_char(
							lv_data_precision) ||
							', ' || to_char(
							lv_data_scale)
							|| ');', 1);
					end if;
				else
					a_lin := wri(a_lin, 'c', &q ||
						'n' || &q || ', 38, 0);', 1);
				end if;
			else
				raise bad_data_type;
			end if;
			if &make_snapshots = 0 then
				if lv_default_length != 0 then
					if lv_default_length < 76 then
						/* Write insert statements */
						/* into tbldefdef */
						a_lin := wri(a_lin, 'f',
							'insert into' ||
							' tbldefdef values(',
							0);
						a_lin := wri(a_lin, 'f', &q ||
							lv_owner || &q || ', ',
							0);
						a_lin := wri(a_lin, 'f', &q ||
							lv_table_name || &q ||
							', ', 0);
						a_lin := wri(a_lin, 'f', &q ||
							lv_column_name || &q ||
							', ', 0);
						if instr(lv_data_default,
							chr(39)) = 0 and
							lv_data_type <> 'DATE'
							or lv_data_type = 'CHAR'
							or lv_data_type =
							'VARCHAR2'
						then
							a_lin := wri(a_lin, 'f',
								lv_data_default,
								0);
						else
							if instr(
								lv_data_default,
								chr(39)) = 0
							then
								lv_data_default
								 := replace(
								 lv_data_default
								 , ' ');
								lv_data_default
								 := replace(
								 lv_data_default
								 , chr(9));
							end if;
							a_lin := wri(a_lin, 'f',
								&q ||
								replace(
								lv_data_default,
								'''', '''''')
								|| &q, 0);
						end if;
						a_lin := wri(a_lin, 'f', ');',
							1);
					else
						dbms_output.put_line(
							'Skipping default' ||
							' clause on column ' ||
							lv_column_name);
						dbms_output.put_line(
							'  on table ' ||
							lv_table_name);
						dbms_output.put_line(
							'  since length is ' ||
							to_char(
							lv_default_length));
					end if;
				end if;
				if lv_nullable = 'N' then
					/* Write insert statements into */
					/* tbldefcon */
					a_lin := wri(a_lin, 'x',
						'insert into tbldefcon values(',
						0);
					a_lin := wri(a_lin, 'x', &q ||
						lv_table_name || &q || ', ', 0);
					a_lin := wri(a_lin, 'x', &q ||
						lv_column_name || &q || ', ',
						0);
					a_lin := wri(a_lin, 'x', &q ||
						'not null' || &q || ');', 1);
				end if;
			end if;
		end loop;
		close col_cursor;
		if &make_snapshots = 1 then
			/* Write insert statements into tbldefi */
			a_lin := wri(a_lin, 'i', 'insert into tbldefi values(',
				0);
			a_lin := wri(a_lin, 'i', &q || lv_table_name || &q ||
				', ', 0);
			a_lin := wri(a_lin, 'i', &q || &q || ', ' || &q ||
				'M_ROW$$' || &q || ', 1, ' || &q || 'i' || &q ||
				', 1);', 1);
		end if;
	end loop;
	close tab_cursor;
	if &make_snapshots = 0 then
		prev_table_name := '@';
		open ind_cursor;
		loop
			fetch ind_cursor into
				lv_uniqueness,
				lv_owner,
				lv_index_name,
				lv_table_name,
				primary_key;
			exit when ind_cursor%NOTFOUND;
			if prev_table_name = lv_table_name then
				ind_seq_no := ind_seq_no + 1;
			else
				prev_table_name := lv_table_name;
				ind_seq_no := 1;
			end if;
			if primary_key = 1 then
				lv_uniqueness := 'PRIMARY';
			end if;
			/* Write insert statements into tbldefi */
			open indcol_cursor(lv_owner, lv_index_name);
			loop
				fetch indcol_cursor into
					lv_column_name,
					lv_column_position;
				exit when indcol_cursor%notfound;
				a_lin := wri(a_lin, 'i',
					'insert into tbldefi values(', 0);
				a_lin := wri(a_lin, 'i', &q || lv_table_name ||
					&q || ', ', 0);
				a_lin := wri(a_lin, 'i', &q || lv_index_name ||
					&q || ', ', 0);
				a_lin := wri(a_lin, 'i', &q || lv_column_name ||
					&q || ', ', 0);
				a_lin := wri(a_lin, 'i', to_char(ind_seq_no) ||
					', ', 0);
				if lv_uniqueness = 'PRIMARY' then
					a_lin := wri(a_lin, 'i', &q || 'p' ||
						&q || ', ', 0);
				elsif lv_uniqueness = 'UNIQUE' then
					a_lin := wri(a_lin, 'i', &q || 'u' ||
						&q || ', ', 0);
				elsif lv_uniqueness = 'BITMAP' then
					a_lin := wri(a_lin, 'i', &q || 'b' ||
						&q || ', ', 0);
				else
					a_lin := wri(a_lin, 'i', &q || 'i' ||
						&q || ', ', 0);
				end if;
				a_lin := wri(a_lin, 'i',
					to_char(lv_column_position) || ');', 1);
			end loop;
			close indcol_cursor;
		end loop;
		close ind_cursor;
	end if;
	display_time('Done with ' || to_char(num_tables) || ' tables at ');
	commit;
exception
	when no_blocksize then
		rollback;
		raise_application_error(-20000,
			'Can not extract DB_BLOCK_SIZE - Aborting...');
	when dbms_sql_error then
		rollback;
		raise_application_error(-20000,
			'Unexpected DBMS_SQL.PARSE error ' ||
			to_char(error_code) || ' while executing ' ||
			chr(10) || sqltxt || chr(10) ||
			'Aborting...');
	when bad_data_type then
		rollback;
		raise_application_error(-20000,
			'Unsupported data type found for table ' ||
			lv_table_name || ', ' || lv_column_name || ':' ||
			chr(10) || lv_data_type || chr(10) || 'Aborting...');
	when others then
		rollback;
		raise_application_error(-20000,
			'Unexpected error on ' || lv_table_name ||
			', ' || lv_column_name || ':' || chr(10) ||
			sqlerrm || chr(10) || 'Aborting...');
end;
/

set termout off
set heading off
spool inserts.sql
select 'rem inserts.sql' from dual;
select 'rem' from dual;
select 'rem ***** tblsize.sql INSERT statements for database ' || name
	from v$database;
select 'rem ***** for schema &&schema' from dual;
select 'rem' from dual;
select text from tablc_temp where code = 'b' order by lineno;
select text from tablc_temp where code = 't' order by lineno;
select text from tablc_temp where code = 'a' order by lineno;
select text from tablc_temp where code = 'c' order by lineno;
select text from tablc_temp where code = 'f' order by lineno;
select text from tablc_temp where code = 'x' order by lineno;
select text from tablc_temp where code = 'i' order by lineno;
select text from tablc_temp where code = 's' order by lineno;
spool off
drop table tablc_temp;
set termout on
select 'Created inserts.sql...' from dual;
set termout off
exit

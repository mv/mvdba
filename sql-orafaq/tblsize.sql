rem $DBA/tblsize.sql
rem
rem Creates table/index sizing report and DDL file for the specified tables,
rem indexes, and tablespaces (or snapshots and snapshot logs).
rem
rem Requires the dbms_output PL/SQL package to be available.
rem
rem Requires sufficient free space in this user's default tablespace for the
rem temporary tables that will be created.
rem
rem <<<<<<<<<<<<<<<<<<< MODIFICATION HISTORY >>>>>>>>>>>>>>>>>>>
rem 09/28/98 Brian Lomasky	Handle snapshot rowid avg sizes.
rem 09/16/98 Brian Lomasky	Remove extra owner parameter from
rem				  default_cursor.
rem 01/08/98 Brian Lomasky	Fix calculation of data files > 1gig.  Ensure
rem				  tables and indexes are a minimum of 10K bytes.
rem				  Use 900Meg instead of 1000Meg for multiple
rem				  data files.  Limit extents to 900Meg.
rem 12/17/97 Brian Lomasky	Add restriction warning about sufficient free
rem				  space in the default tablespace.  Add support
rem				  for default values containing apostrophes.
rem 11/21/97 Brian Lomasky	Added support for snapshot file creation.
rem 09/09/97 Brian Lomasky	Add 20% overhead for tablespace overhead.
rem 08/29/97 Brian Lomasky	Check for typos in the datatype size.  Include
rem				  listing of tables and sizes by tablespace.
rem 08/28/97 Brian Lomasky	Include DB_BLOCK_SIZE overhead for raw partition
rem				  datafiles.  Limit extent size to max of 95% of
rem				  the average free space, divided by the number
rem				  of tables in the tablespace.  Drop any
rem				  existing constraints.
rem 08/27/97 Brian Lomasky	Include Avg Row Size support (from tblsizec.sql)
rem 08/25/97 Brian Lomasky	Include LONG datatype support.
rem 08/22/97 Brian Lomasky	Include 1M overhead for raw partition datafiles.
rem 08/20/97 Brian Lomasky	Fix byte size calculations for NUMBER datatypes.
rem				  Fix for minimum row size.  Parameterize the
rem				  limiting of extents to fit into an existing
rem				  tablespace.  Display appropriate description.
rem 08/15/97 Brian Lomasky	Additional report of tables and indexes, by
rem				  size.  Change all Kbytes to bytes.  Create
rem				  tablespace creation script for datafiles.
rem 08/14/97 Brian Lomasky	Added Index tablespace, PCTFREE, and PCTUSED to
rem				  table definitions.  Added new column default
rem				  definitions.  Added index name to index
rem				  definitions.  Convert extra large column KB.
rem 08/13/97 Brian Lomasky	Execute any constraints.sql script at tblddl
rem				  end.  Fix column definition description for
rem				  CHAR datatypes.
rem 07/23/97 Brian Lomasky	Limit initial/next extents to 50% of the bytes
rem				  comprising the smallest data file in a
rem				  tablespace.
rem 06/18/97 Brian Lomasky	Print all constraint info on report.  Do not
rem				  change case of constraint data.
rem 06/16/97 Brian Lomasky	Increase size of print fields.
rem 06/06/97 Brian Lomasky	Add CHAR datatype.
rem 06/06/97 Brian Lomasky	Fix if no data files exist.  Add Growth per
rem				  Month to Summary Usage report.  Add summary
rem				  totals.
rem 06/04/97 Brian Lomasky	Include tablespace data file sizes.  Modify
rem				  keyword cases.  Print tablespace usage
rem				  summary.
rem 05/13/97 Brian Lomasky	Execute any triggers.sql script at tblddl end.
rem 03/31/97 Brian Lomasky	Set INITIAL and NEXT for bitmap indexes to .02
rem				  times the KB of the columns making up the
rem				  index.  Include average size for all columns.
rem				  Conditionally create table/index/synonym DDL.
rem 03/27/97 Brian Lomasky	Include owner.  Recalculate initial/next,
rem				  limited to the tablespaces's avg free space.
rem				  Create public synonyms.
rem 03/26/97 Brian Lomasky	Modify initial/next calculations.  Use Kbytes
rem				  instead of Mbytes.
rem 03/20/97 Brian Lomasky	Original
rem
set echo off
set feedback off
set heading off
set pagesize 9999
set verify off
set termout off
set verify off
def q=chr(39)
drop table tbldefb;
drop table tbldefa;
drop table tbldeft;
drop table tbldefc;
drop table tbldefi;
drop table tbldefcon;
drop table tbldefdef;
drop table tbldefk;
drop table tblsize_temp;
drop table tblsize_summ_temp;
drop table tblsize_totals;
set serveroutput on size 100000
set termout on
create table tbldefb (
	db_block_size		number
	);
create table tbldeft (
	owner			varchar2(30),
	table_name		varchar2(30),
	tablespace_name		varchar2(30),
	index_tablespace_name	varchar2(30),
	pct_free		number,
	pct_used		number,
	num_rows		number,
	rows_month		number
	);
create table tbldefa (
	table_name		varchar2(30),
	avg_row_size		number
	);
create table tbldefc (
	table_name		varchar2(30),
	column_name		varchar2(30),
	datatype		varchar2(5),
	avg_size		number,
	decimals		number
	);
create table tbldefdef (
	table_name		varchar2(30),
	column_name		varchar2(30),
	default_value		varchar2(80)
	);
create table tbldefcon (
	table_name		varchar2(30),
	column_name		varchar2(30),
	constraint_def		varchar2(30)
	);
create table tbldefi (
	table_name		varchar2(30),
	index_name		varchar2(30),
	column_name		varchar2(30),
	seq_no			number,
	indextype		varchar2(1),
	col_position		number
	);
create table tbldefk (
	db_link			varchar2(30)
	);
create table tblsize_temp (
	code			varchar2(1),
	lineno			number,
	text			varchar2(80)
	);
create table tblsize_summ_temp (
	tablespace_name		varchar2(30),
	bytes			number,
	grow_bytes		number
	);
create table tblsize_totals (
	obj_type		varchar2(1),
	obj_name		char(30),
	obj_size		number
	);

rem ********************** Database-wide definitions **************************
def initrans_table=1		/* INITRANS value to be used for table */
def initrans_index=2		/* INITRANS value to be used for index */
def ddl_table=1			/* 1=Include DDL definitions for tables/snaps */
def ddl_index=1			/* 1=Include DDL definitions for indexes */
def ddl_synonym=1		/* 1=Include DDL definitions for synonyms */
def ddl_tablespace=1		/* 1=Include DDL definitions for tablespaces */
def ddl_raw=0			/* 1=Data files will be on raw devices */

rem **** ----------------------------------------------------------------- ****
rem **** If limit_extents is set to 1, the INITIAL and NEXT extent clauses ****
rem **** will be constrained so that:                                      ****
rem ****   1) Each extent is no more than 95% of the avg contiguous bytes  ****
rem ****      in the tablespace (so that there is a reasonable chance that ****
rem ****      the table can actually be created in an existing tablespace) ****
rem ****   2) Each extent is no more than 50% of the smallest number of    ****
rem ****      bytes in each datafile comprising the tablespace (so that    ****
rem ****      the table can always grow to at least two extents within a   ****
rem ****      single datafile)                                             ****
rem **** (Of course, this only applies if the specified tablespace name    ****
rem ****  already exists.  If it does not, then these limits are not       ****
rem ****  enforced)                                                        ****
rem **** Note:  Even with these constraints, if you are trying to create   ****
rem ****        table(s) in an already-fragmented tablespace, you may      ****
rem ****        still encounter allocation failures due to the inability   ****
rem ****        of this program to exactly determine where Oracle will     ****
rem ****        place the newly-created extents of the tables.  If this    ****
rem ****        occurs, simply edit the tblddl.sql file and reduce the     ****
rem ****        initial extent values until they are less than the largest ****
rem ****        contiguous free bytes that are available in the tablespace ****
rem **** ----------------------------------------------------------------- ****
rem **** If limit_extents is set to 0, the INITIAL and NEXT extent clauses ****
rem **** will be calculated in order to contain all of the specified rows  ****
rem **** in a single extent, regardless of whether or not any existing     ****
rem **** tablespace has enough free space within it to support that size.  ****
rem **** ----------------------------------------------------------------- ****
def limit_extents=0

rem
rem ******************* DB_BLOCK_SIZE definition *******************
rem Database block size (in bytes)
rem
insert into tbldefb values(8192);

rem
rem
rem ********************** Table definitions **********************************
rem Owner, TABLE_NAME, TABLESPACE_NAME, Tablespace name for this table's
rem   indexes (or '' if <tablespace_name>_NDX is to be used), PCTFREE, PCTUSED
rem   max # of rows to size table for, number of rows added per month
rem   (Note that snapshot logs are sized for an average of 1000 rows)
rem
insert into tbldeft values('ops$oracle', 'emp', 'emp', '', 10, 40, 500, 25);

rem
rem ******************** Avg Row Size definitions *********************
rem TABLE_NAME, Average Row Size
rem   (This overrides the program's calculations of the avg row size for each
rem    of the following tables.  Omit the inserts into tbldefa if you want the
rem    program to calculate the average row size based upon the "Avg size"
rem    values in the following tbldefc table definitions for each column)
rem
insert into tbldefa values('emp', 100);

rem
rem ********************** Column definitions *********************************
rem TABLE_NAME, COLUMN_NAME,
rem   DATATYPE (nx=NUMBER (x=number of digits), vx=VARCHAR2 (x=number of
rem     characters), cx=CHAR (x=number of characters), d=DATE, l=LONG),
rem   Avg size (if VARCHAR2 or LONG) or average number of digits (if NUMBER),
rem   Number of decimal digits (if NUMBER)
rem
insert into tbldefc values('emp', 'employee_id', 'n5', 5, 0);
insert into tbldefc values('emp', 'employee_name', 'v35', 15, 0);
insert into tbldefc values('emp', 'employee_address', 'v60', 50, 0);
insert into tbldefc values('emp', 'salary', 'n8', 6, 2);

rem ********************** Constraint definitions *****************************
rem TABLE_NAME, COLUMN_NAME, CONSTRAINT_DEF (any column constraint text to be
rem   included in the SQL "CREATE TABLE" statement)
rem
insert into tbldefcon values('emp', 'employee_id', 'not null');

rem
rem ********************** Default definitions ********************************
rem TABLE_NAME, COLUMN_NAME, Column's DEFAULT value (case-sensitive)
rem
insert into tbldefdef values('emp', 'employee_name', 'BOZO');

rem
rem ********************** Index definitions **********************************
rem TABLE_NAME, Index name (or '' if IND_<tablename>_<nn> is to be used; nn
rem   is the two-digit Index sequence number; Primary key will be 01),
rem   COLUMN_NAME, Index sequence number,
rem   Index Type (p=Primary key, u=Unique key, b=Bitmap, i=Nonunique index),
rem   Position number of field in a concatenated index
rem
insert into tbldefi values('emp', 'emp_pk', 'employee_id', 1, 'p', 1);
insert into tbldefi values('emp', 'emp_nam_add', 'employee_name', 2, 'i', 1);
insert into tbldefi values('emp', 'emp_nam_add', 'employee_address', 2, 'i', 2);

rem ************************ Database Link definition *************************
rem ********** Database Link used on the remote  **********
rem ********** system to access the master table **********
rem **********      (Example:  PROD.WORLD)       **********
rem
rem insert into tbldefk values('PROD.WORLD');
rem
rem Note:  THE PRESENCE OF ANY ROWS IN TBLDEFK WILL CAUSE TBLSIZE TO CREATE
rem        ONLY SNAPSHOT LOGS AND SNAPSHOTS, INSTEAD OF ITS NORMAL TABLES,
rem        INDEXES, CONSTRAINTS, ETC.  THE ONLY INDICES ALLOWED IN TBLDEFI ARE
rem        THE NON-UNIQUE INDEXES ON THE M_ROW$$ COLUMN.
rem
rem Note:  YOU WILL HAVE TO MANUALLY EDIT THE SNAPSHOT REFRESH CLAUSE AND THE
rem        SNAPSHOT SUBQUERY CLAUSE TO CONFORM TO YOUR SITE'S REQUIREMENTS.

set termout off
column tmp_tbldefa new_value count_tbldefa
select count(*) tmp_tbldefa from tbldefa;
set termout on

declare
	cursor db_block_size_cursor is
		select db_block_size
		from tbldefb;
	cursor init_cursor is
		select to_char(sysdate, 'MM/DD/YY')
		from v$database;
	cursor link_cursor is
		select db_link from tbldefk;
	cursor table_tablespace_cursor is
		select upper(tablespace_name), upper(table_name), num_rows,
			rows_month, obj_size
		from tbldeft, tblsize_totals
		where obj_type = 'T' and rtrim(obj_name) = upper(table_name)
		order by 1, 2;
	cursor table_cursor is
		select upper(owner), upper(table_name), upper(tablespace_name),
			upper(index_tablespace_name),
			pct_free, pct_used, num_rows, rows_month,
			greatest(num_rows, rows_month)
		from tbldeft
		order by 1, 2;
	cursor table_count_cursor (my_tablespace in varchar2) is
		select count(*)
		from tbldeft
		where upper(tablespace_name) = my_tablespace;
	cursor avg_row_size_cursor (my_tbl in varchar2) is
		select avg_row_size
		from tbldefa
		where lower(table_name) = lower(my_tbl);
	cursor column_cursor (my_table in varchar2) is
		select upper(column_name), upper(datatype), avg_size, decimals
		from tbldefc
		where lower(table_name) = lower(my_table);
	cursor constraint_cursor (my_table in varchar2, my_col in varchar2) is
		select constraint_def
		from tbldefcon
		where lower(table_name) = lower(my_table) and
		lower(column_name) = lower(my_col);
	cursor default_cursor (my_table in varchar2, my_col in varchar2) is
		select default_value
		from tbldefdef
		where lower(table_name) = lower(my_table) and
		lower(column_name) = lower(my_col);
	cursor index_cursor (my_table in varchar2) is
		select upper(index_name), seq_no, upper(indextype),
			col_position, upper(column_name)
		from tbldefi
		where lower(table_name) = lower(my_table)
		order by 1, 2, 3;
	cursor index_col_cursor (my_table in varchar2, my_col in varchar2) is
		select upper(datatype), avg_size
		from tbldefc
		where lower(table_name) = lower(my_table) and
		lower(column_name) = lower(my_col);
	cursor data_cursor (my_tablespace in varchar2) is
		select nvl(sum(bytes), 0)
		from sys.dba_data_files
		where tablespace_name = my_tablespace;
	cursor used_cursor (my_tablespace in varchar2) is
		select bytes
		from sys.dba_segments
		where tablespace_name = my_tablespace;
	cursor free_cursor (my_tablespace in varchar2) is
		select floor(avg(bytes) * 1024 * .95), max(bytes)
		from sys.dba_free_space
		where tablespace_name = my_tablespace;
	cursor file_cursor (my_tablespace in varchar2) is
		select nvl(min(bytes), 0)
		from sys.dba_data_files
		where tablespace_name = my_tablespace;
	cursor size_totals_cursor (my_type in varchar2) is
		select obj_name, obj_size
		from tblsize_totals
		where obj_type = my_type
		order by obj_size desc;
	cursor tablespace_cursor is
		select tablespace_name, sum(bytes), sum(grow_bytes)
		from tblsize_summ_temp
		group by tablespace_name;
	lv_today		varchar2(8);
	lv_db_block_size	tbldefb.db_block_size%TYPE;
	lv_db_link		tbldefk.db_link%TYPE;
	lv_owner		tbldeft.owner%TYPE;
	lv_table_name		tbldeft.table_name%TYPE;
	prev_tablespace_name	tbldeft.tablespace_name%TYPE;
	lv_tablespace_name	tbldeft.tablespace_name%TYPE;
	lv_indx_tablespace_name	tbldeft.index_tablespace_name%TYPE;
	lv_pct_free		tbldeft.pct_free%TYPE;
	lv_pct_used		tbldeft.pct_used%TYPE;
	lv_num_rows		tbldeft.num_rows%TYPE;
	lv_calc_rows		tbldeft.num_rows%TYPE;
	lv_rows_month		tbldeft.rows_month%TYPE;
	lv_avg_row_size		tbldefa.avg_row_size%TYPE;
	lv_column_name		tbldefc.column_name%TYPE;
	lv_datatype		tbldefc.datatype%TYPE;
	lv_avg_size		tbldefc.avg_size%TYPE;
	lv_decimals		tbldefc.decimals%TYPE;
	lv_default_value	tbldefdef.default_value%TYPE;
	lv_constraint_def	tbldefcon.constraint_def%TYPE;
	lv_index_name		tbldefi.index_name%TYPE;
	lv_seq_no		tbldefi.seq_no%TYPE;
	lv_indextype		tbldefi.indextype%TYPE;
	lv_col_position		tbldefi.col_position%TYPE;
	lv_col_name		tbldefi.column_name%TYPE;
	prev_seq_no		tbldefi.seq_no%TYPE;
	lv_avg_contig		sys.dba_free_space.bytes%TYPE;
	lv_obj_name		tblsize_totals.obj_name%TYPE;
	lv_obj_size		tblsize_totals.obj_size%TYPE;
	lv_bytes		number;
	lv_sum_bytes		number;
	lv_max_bytes		number;
	lv_actual_used		number;
	lv_avail_bytes		number;
	growth_per_month	number;
	print_sum_bytes		char(7);
	print_data_bytes	char(5);
	print_max_bytes		char(7);
	print_bytes		char(7);
	print_actual_used	char(7);
	print_avail_bytes	char(7);
	print_pct_avail		char(5);
	print_growth		char(5);
	print_max_months	char(6);
	col_id			number;
	owner_name		tbldeft.owner%TYPE;
	table_name		char(30);
	col_name		char(30);
	data_type		char(14);
	var_data_type		varchar2(14);
	avg_size		char(9);
	print_default		boolean;
	initial_extent_size	varchar2(16);
	next_extent_size	varchar2(16);
	snap_log_bytes		number;
	snap_log_initial_extent_size	varchar2(16);
	snap_log_next_extent_size	varchar2(16);
	num_cols_gt_128		number; /* Count of fields > 128 bytes */
	num_cols_gt_250		number; /* Count of fields > 250 bytes */
	num_cols_lt_129		number; /* Count of fields < 129 bytes */
	num_cols_lt_251		number; /* Count of fields < 251 bytes */
	ads			number; /* Available data space per block */
	total_avg_len		number; /* Sum of average column lengths */
	total_avg_ndx_len	number; /* Sum of average indx column lengths */
	total_db_size		number;
	total_db_table_size	number;
	total_db_index_size	number;
	total_index_bytes	number;
	index_name		char(30);
	index_type		char(11);
	var_index_type		varchar2(11);
	lv_lineno		number;
	a_lin			varchar2(80);
	d_lin			varchar2(80);
	m_lin			varchar2(80);
	lv_count_tables		number;
	n			number;
	x			number;
	l			number;
	tmp_siz			number;
	extnt_limit		varchar2(30);
	extent_val		number;
	block_header		number(6);
	rows_per_block		number(13);
	rowsize			number;
	initial_size		varchar2(16);
	tablespace_path		varchar2(80);
	datafile_suffix		varchar2(30);
	last_data_file_size	number;
	overhead		number;
	data_file_size		number;
	no_db_block_size	exception;
	bad_datatype		exception;
	bad_indextype		exception;
	bad_avg_size		exception;
	missing_avg_size	exception;
	missing_avg_index_size	exception;

	/* Limit extent size so it can fit in a 900Meg data file */
	function extent_limit(x_val in number)
		return varchar2 is
	begin
		if x_val > 900000 then
			return '900M';
		else
			if x_val > 5000 then
				return to_char(ceil(x_val / 1024)) || 'M';
			else
				if x_val > 10 then
					return to_char(ceil(x_val)) || 'K';
				else
					/* Nothing smaller than 10K */
					return '10K';
				end if;
			end if;
		end if;
	end extent_limit;

	function k_m_char(x_tablespace in varchar2, x_val in number)
		return varchar2 is
	begin
		extent_val := floor(x_val);
		if &limit_extents = 1 then
			/* Limit the extent value to 95% of the avg */
			/* contiguous bytes in the tablespace, divided by */
			/* the number of tables in the tablespace */
			open table_count_cursor (x_tablespace);
			fetch table_count_cursor into lv_count_tables;
			if table_count_cursor%NOTFOUND then
				lv_count_tables := 1;
			end if;
			if lv_count_tables = 0 then
				lv_count_tables := 1;
			end if;
			close table_count_cursor;
			open free_cursor (x_tablespace);
			fetch free_cursor into lv_avg_contig, lv_max_bytes;
			if free_cursor%FOUND then
				lv_avg_contig := floor(lv_avg_contig /
					lv_count_tables);
				if extent_val > lv_avg_contig then
					extent_val := lv_avg_contig;
				end if;
			end if;
			close free_cursor;
			/* Limit the extent value to 50% of the smallest */
			/* number of bytes in each datafile comprising the */
			/* tablespace */
			open file_cursor (x_tablespace);
			fetch file_cursor into lv_max_bytes;
			if file_cursor%FOUND then
				if extent_val > lv_max_bytes / 2 then
					extent_val := lv_max_bytes / 2;
				end if;
			end if;
			close file_cursor;
		end if;
		/* Limit extent size so it can fit in a 900Meg data file */
		extnt_limit := extent_limit(extent_val);
		return extnt_limit;
	end k_m_char;

	function wri(x_cod in varchar2, x_lin in varchar2, x_str in varchar2,
		x_force in number)
		return varchar2 is
	begin
		if length(x_lin) + length(x_str) > 79 then
			lv_lineno := lv_lineno + 1;
			insert into tblsize_temp values (x_cod, lv_lineno,
				x_lin);
			if x_force = 0 then
				if substr(x_str, 1, 1) = ' ' then
					return x_str;
				else
					return ' ' || x_str;
				end if;
			else
				lv_lineno := lv_lineno + 1;
				if substr(x_str, 1, 1) = ' ' then
					insert into tblsize_temp values
						(x_cod, lv_lineno, x_str);
				else
					insert into tblsize_temp values
						(x_cod, lv_lineno,
						' ' || x_str);
				end if;
				return '';
			end if;
		else
			if x_force = 0 then
				return x_lin||x_str;
			else
				lv_lineno := lv_lineno + 1;
				insert into tblsize_temp values (
					x_cod, lv_lineno, x_lin || x_str);
				return '';
			end if;
		end if;
	end wri;

	function calc_indx_kb(x_rows in number) return number is
	begin
		if var_index_type = 'Bitmap' then
			/* Return .02 times the size of the columns making */
			/* up the bitmap index (minimum of 10K) */
			tmp_siz := ceil(.02 * total_avg_ndx_len * x_rows /
				1024);
			if tmp_siz < 10 then
				tmp_siz := 10;
			end if;
			return tmp_siz;
		end if;
		/* Calculate partial size for the block header as per Step 1 */
		block_header := 113 + 23 * &initrans_index;
		/* Calculate available data space per data block per Step 2 */
		ads := (lv_db_block_size - block_header) *
			(1 - lv_pct_free / 100);
		/* Calculate average index row size as per Step 4 */
		rowsize := 8 + num_cols_lt_129 + num_cols_gt_128 * 3 +
			total_avg_ndx_len;
		/* Calculate the number of Kbytes for the index per Step 5 */
		tmp_siz := ceil((lv_db_block_size * 1.05 * x_rows * rowsize /
			((floor(ads / rowsize)) * rowsize)) / 1024);
		if tmp_siz < 10 then
			tmp_siz := 10;
		end if;
		return tmp_siz;
	end calc_indx_kb;

	function calc_tabl_kb(x_rows in number) return number is
	begin
		/* Calculate partial size for the block header as per Step 1 */
		block_header := 57 + (23 * &initrans_table);
		if lv_avg_row_size = -1 then
			/* Calculate average row size as per Step 4 */
			rowsize := greatest(3 + num_cols_lt_251 +
				num_cols_gt_250 * 3 + total_avg_len, 9);
		else
			rowsize := greatest(lv_avg_row_size, 9);
		end if;
		/* Part of Step 1, Step 2, and Step 5 are combined to arrive */
		/* at the average number of rows that can fit in a data block */
		rows_per_block := (lv_db_block_size - block_header - 4 -
			((lv_db_block_size - block_header) * lv_pct_free /
			100)) / (2 + rowsize);
		/* Total Kbytes as per Step 6 */
		tmp_siz := ceil((lv_db_block_size * x_rows / rows_per_block) /
			1024);
		if tmp_siz < 10 then
			tmp_siz := 10;
		end if;
		return tmp_siz;
	end calc_tabl_kb;

	function format5(n_size in number) return varchar2 is
	begin
		if n_size = 0 then
			return '     ';
		elsif n_size < 1024 then
			return ' ' || substr(to_char(n_size, '9990'), 2);
		elsif n_size < 1048576 then
			return substr(to_char(n_size / 1024, '9990'), 2) || 'K';
		elsif n_size < 1073741824 then
			return substr(to_char(n_size / 1048576, '9990'), 2) ||
				'M';
		else
			return substr(to_char(n_size / 1073741824, '9990'),
				2) || 'G';
		end if;
	end format5;

	function format7(n_size in number) return varchar2 is
	begin
		if n_size = 0 then
			return '       ';
		elsif n_size < 999424 then
			return substr(to_char(n_size, '999,990'), 2);
		elsif n_size < 102389760 then
			return substr(to_char(n_size / 1024, '99,990'), 2) ||
				'K';
		elsif n_size < 104847114240 then
			return substr(to_char(n_size / 1048576, '99,990'), 2) ||
				'M';
		else
			return substr(to_char(n_size / 1073741824, '99,990'),
				2) || 'G';
		end if;
	end format7;

	function format7t(n_size in number) return varchar2 is
	begin
		if n_size >= 104152956928 then
			return to_char(n_size / 1073741824, '99990') || 'G';
		elsif n_size >= 101711872 then
			return to_char(n_size / 1048576, '99990') || 'M';
		elsif n_size >= 99328 then
			return to_char(n_size / 1024, '99990') || 'K';
		elsif n_size >= -1024 then
			return ' ' || to_char(n_size, '99990');
		elsif n_size >= -101711871 then
			return to_char(n_size / 1024, '99990') || 'K';
		elsif n_size >= -104152956927 then
			return to_char(n_size / 1048576, '99990') || 'M';
		else
			return to_char(n_size / 1073741824, '99990') || 'G';
		end if;
	end format7t;

	function format9(n_size in number) return varchar2 is
	begin
		if n_size = 0 then
			return '         ';
		elsif n_size < 99328 then
			return ' ' || to_char(n_size, '999,990');
		elsif n_size < 101711872 then
			return to_char(n_size / 1024, '999,990') || 'K';
		elsif n_size < 104152956928 then
			return to_char(n_size / 1048576, '999,990') || 'M';
		else
			return to_char(n_size / 1073741824, '999,990') || 'G';
		end if;
	end format9;

	function format11(n_size in number) return varchar2 is
	begin
		if n_size = 0 then
			return '           ';
		elsif n_size < 99328 then
			return ' ' || to_char(n_size, '9,999,990');
		elsif n_size < 101711872 then
			return to_char(n_size / 1024, '9,999,990') || 'K';
		elsif n_size < 104152956928 then
			return to_char(n_size / 1048576, '9,999,990') || 'M';
		else
			return to_char(n_size / 1073741824, '9,999,990') || 'G';
		end if;
	end format11;
begin
	lv_avg_row_size := -1;
	dbms_output.put_line(' ');
	if &limit_extents = 0 then
		dbms_output.put_line('> Note:  limit_extents is set to 0.' ||
			'  The INITIAL and NEXT extent clauses will');
		dbms_output.put_line('>        be calculated in order to' ||
			' contain all of the specified rows in a');
		dbms_output.put_line('>        single extent, regardless of' ||
			' whether or not any existing tablespace');
		dbms_output.put_line('>        has enough free space within' ||
			' it to support that size.');
	else
		dbms_output.put_line('> Note:  limit_extents is set to 1.' ||
			'  The INITIAL and NEXT extent clauses will');
		dbms_output.put_line('>        be constrained so that:');
		dbms_output.put_line('>          1) Each extent is no more' ||
			' than 95% of the avg contiguous bytes');
		dbms_output.put_line('>             in the tablespace (so' ||
			' that there is a reasonable chance that');
		dbms_output.put_line('>             the table can actually' ||
			' be created in an existing tablespace)');
		dbms_output.put_line('>          2) Each extent is no more' ||
			' than 50% of the smallest number of');
		dbms_output.put_line('>             bytes in each datafile' ||
			' comprising the tablespace (so that');
		dbms_output.put_line('>             the table can always' ||
			' grow to at least two extents within a');
		dbms_output.put_line('>             single datafile)');
		dbms_output.put_line('>        (Of course, this only' ||
			' applies if the specified tablespace name');
		dbms_output.put_line('>         already exists.  If it does' ||
			' not, then these limits are not enforced)');
	end if;
	dbms_output.put_line(' ');
	a_lin := '';
	d_lin := '';
	m_lin := '';
	lv_lineno := 0;
	open init_cursor;
	fetch init_cursor into lv_today;
	if init_cursor%NOTFOUND then
		lv_today := '??/??/??';
	end if;
	close init_cursor;
	open db_block_size_cursor;
	fetch db_block_size_cursor into lv_db_block_size;
	if db_block_size_cursor%NOTFOUND then
		raise no_db_block_size;
	end if;
	close db_block_size_cursor;
	open link_cursor;
	fetch link_cursor into lv_db_link;
	if link_cursor%NOTFOUND then
		lv_db_link := ' ';
	end if;
	close link_cursor;
	if lv_db_link = ' ' then
		a_lin := wri('R', a_lin, '                         ' ||
			'Table and Index Sizings Report                 ' ||
			lv_today, 1);
	else
		a_lin := wri('R', a_lin, '                    Snaps' ||
			'hot Table and Index Sizings Report             ' ||
			lv_today, 1);
	end if;
	d_lin := wri('D', d_lin, 'rem tblddl.sql', 1);
	d_lin := wri('D', d_lin, 'rem', 1);
	d_lin := wri('D', d_lin, 'rem Created ' || lv_today ||
		' by tblsize.sql', 1);
	if &ddl_table = 0 then
		d_lin := wri('D', d_lin, 'rem Skipping DDL for tables...', 1);
	end if;
	if &ddl_index = 0 then
		d_lin := wri('D', d_lin, 'rem Skipping DDL for indexes...', 1);
	end if;
	if &ddl_synonym = 0 then
		d_lin := wri('D', d_lin, 'rem Skipping DDL for synonyms...', 1);
	end if;
	d_lin := wri('D', d_lin, 'rem', 1);
	d_lin := wri('D', d_lin, 'set echo off', 1);
	d_lin := wri('D', d_lin, 'set feedback off', 1);
	d_lin := wri('D', d_lin, 'set verify off', 1);
	d_lin := wri('D', d_lin, 'spool tblddl.lst', 1);
	if lv_db_link <> ' ' then
		m_lin := wri('M', m_lin, 'rem tblsnap.sql', 1);
		m_lin := wri('M', m_lin, 'rem', 1);
		m_lin := wri('M', m_lin, 'rem Created ' || lv_today ||
			' by tblsize.sql', 1);
		m_lin := wri('M', m_lin, 'rem', 1);
		m_lin := wri('M', m_lin, 'set echo off', 1);
		m_lin := wri('M', m_lin, 'set feedback off', 1);
		m_lin := wri('M', m_lin, 'set verify off', 1);
		m_lin := wri('M', m_lin, 'spool tblsnap.lst', 1);
	end if;
	/* Tablespaces */
	d_lin := wri('S', d_lin, 'rem tblspddl.sql', 1);
	d_lin := wri('S', d_lin, 'rem', 1);
	d_lin := wri('S', d_lin,
		'rem DDL template file for datafile tablespaces', 1);
	d_lin := wri('S', d_lin, 'rem (Note that this does not include the' ||
		' usual Oracle tablespaces,', 1);
	d_lin := wri('S', d_lin, 'rem  such as SYSTEM, etc)', 1);
	d_lin := wri('S', d_lin, 'rem', 1);
	d_lin := wri('S', d_lin, 'rem Created ' || lv_today ||
		' by tblsize.sql', 1);
	if &ddl_tablespace = 0 then
		d_lin := wri('S', d_lin, 'rem Skipping DDL for tablespaces...',
			1);
	else
		d_lin := wri('S', d_lin, 'rem', 1);
		d_lin := wri('S', d_lin,
			'rem ***** YOU MUST MANUALLY EDIT THIS FILE FOR *****',
			1);
		d_lin := wri('S', d_lin,
			'rem ***** THE DESIRED PATHS AND FILENAMES! *****', 1);
	end if;
	d_lin := wri('S', d_lin, 'rem', 1);
	d_lin := wri('S', d_lin, 'set echo off', 1);
	d_lin := wri('S', d_lin, 'set feedback off', 1);
	d_lin := wri('S', d_lin, 'set verify off', 1);
	d_lin := wri('S', d_lin, 'spool tblspddl.lst', 1);
	--
	-- FETCH EACH TABLE'S DEFINITION
	--
	total_db_size := 0;
	total_db_table_size := 0;
	total_db_index_size := 0;
	open table_cursor;
	loop
		fetch table_cursor into
			lv_owner,
			lv_table_name,
			lv_tablespace_name,
			lv_indx_tablespace_name,
			lv_pct_free,
			lv_pct_used,
			lv_num_rows,
			lv_rows_month,
			lv_calc_rows;
		exit when table_cursor%NOTFOUND;
		if lv_indx_tablespace_name is null then
			/* Use same tablespace name as the table, with "_NDX" */
			/* appended to the name */
			if length(lv_tablespace_name) <= 26 then
				lv_indx_tablespace_name := lv_tablespace_name ||
					'_NDX';
			else
				lv_indx_tablespace_name :=
					substr(lv_tablespace_name, 1, 26) ||
					'_NDX';
			end if;
		end if;
		owner_name := lv_owner;
		table_name := lv_table_name;
		a_lin := wri('R', a_lin, '', 1);
		a_lin := wri('R', a_lin, '##################################' ||
			'############################################', 1);
		a_lin := wri('R', a_lin, 'Table: ' || owner_name || '.' ||
			table_name, 0);
		a_lin := wri('R', a_lin, ' Tablespace: ', 0);
		a_lin := wri('R', a_lin, lv_tablespace_name, 1);
		a_lin := wri('R', a_lin, '      Total of' ||
			to_char(lv_num_rows, '9,999,999,990') ||
			' rows        ' || to_char(lv_rows_month,
			'9,999,999,990') || ' rows added per month', 1);
		a_lin := wri('R', a_lin, '      PCTFREE:' ||
			to_char(lv_pct_free, '990') || '  PCTUSED:' ||
			to_char(lv_pct_used, '990'), 1);
		print_max_bytes := '0';
		open free_cursor (lv_tablespace_name);
		fetch free_cursor into lv_avg_contig, lv_max_bytes;
		if free_cursor%FOUND then
			if lv_max_bytes > 1048576 then
				print_max_bytes := to_char(floor(lv_max_bytes /
					1048576)) || 'M';
			elsif lv_max_bytes > 1024 then
				print_max_bytes := to_char(floor(
					lv_max_bytes / 1024)) || 'K';
			else
				print_max_bytes := to_char(lv_max_bytes);
			end if;
		end if;
		close free_cursor;
		open data_cursor (lv_tablespace_name);
		fetch data_cursor into lv_sum_bytes;
		if data_cursor%FOUND then
			if lv_sum_bytes > 1048576 then
				print_sum_bytes := to_char(floor(lv_sum_bytes /
					1048576)) || 'M';
			elsif lv_sum_bytes > 1024 then
				print_sum_bytes := to_char(floor(
					lv_sum_bytes / 1024)) || 'K';
			else
				print_sum_bytes := to_char(lv_sum_bytes);
			end if;
			a_lin := wri('R', a_lin, '          Tablespace size: '
				|| print_sum_bytes ||
				'     Tablespace max contiguous bytes: ' ||
				print_max_bytes, 1);
		end if;
		close data_cursor;
		a_lin := wri('R', a_lin, '', 1);
		a_lin := wri('R', a_lin, '                               ' ||
			'                           Column', 1);
		a_lin := wri('R', a_lin, 'Column Name                    ' ||
			'Datatype       Avg Size     Bytes Constraint', 1);
		a_lin := wri('R', a_lin, '------------------------------ ' ||
			'-------------- -------- --------- ----------', 1);
		if &ddl_table = 1 then
			/* Write DDL for table or snapshot data */
			d_lin := wri('D', d_lin, '', 1);
			d_lin := wri('D', d_lin,
				'rem *******************************', 1);
			d_lin := wri('D', d_lin, '', 1);
			d_lin := wri('D', d_lin, 'set term off', 1);
			if lv_db_link = ' ' then
				d_lin := wri('D', d_lin, 'drop table ', 0);
				d_lin := wri('D', d_lin, owner_name || '.' ||
					lv_table_name, 0);
				d_lin := wri('D', d_lin,
					' cascade constraints;', 1);
				d_lin := wri('D', d_lin, 'set term on', 1);
				d_lin := wri('D', d_lin, 'create table ', 0);
				d_lin := wri('D', d_lin, owner_name || '.' ||
					lv_table_name, 0);
				d_lin := wri('D', d_lin, ' (', 0);
			else
				d_lin := wri('D', d_lin, 'drop snapshot ', 0);
				d_lin := wri('D', d_lin, owner_name ||
					'.' || lv_table_name || ';', 1);
				d_lin := wri('D', d_lin, 'set term on', 1);
				d_lin := wri('D', d_lin, 'create snapshot ', 0);
				d_lin := wri('D', d_lin, owner_name || '.' ||
					lv_table_name, 0);
				m_lin := wri('M', m_lin, '', 1);
				m_lin := wri('M', m_lin,
					'rem *******************************',
					1);
				m_lin := wri('M', m_lin, '', 1);
				m_lin := wri('M', m_lin, 'set term off', 1);
				m_lin := wri('M', m_lin,
					'drop snapshot log on ', 0);
				m_lin := wri('M', m_lin, owner_name ||
					'.' || lv_table_name || ';', 1);
				m_lin := wri('M', m_lin, 'set term on', 1);
				m_lin := wri('M', m_lin,
					'create snapshot log on ', 0);
				m_lin := wri('M', m_lin, owner_name || '.' ||
					lv_table_name, 0);
			end if;
		end if;
		if &count_tbldefa <> 0 then
			--
			-- SEE IF AN AVG ROW SIZE WAS FOUND
			--
			open avg_row_size_cursor (lv_table_name);
			fetch avg_row_size_cursor into lv_avg_row_size;
			if avg_row_size_cursor%NOTFOUND then
				lv_avg_row_size := -1;
			else
				if lv_avg_row_size = 0 then
					lv_avg_row_size := -1;
				end if;
			end if;
			close avg_row_size_cursor;
		end if;
		--
		-- FETCH EACH COLUMN'S DEFINITION FOR THIS TABLE/SNAPSHOT
		--
		num_cols_gt_250 := 0;
		num_cols_lt_251 := 0;
		col_id := 0;
		total_avg_len := 0;
		open column_cursor (lv_table_name);
		loop
			fetch column_cursor into
				lv_column_name,
				lv_datatype,
				lv_avg_size,
				lv_decimals;
			exit when column_cursor%NOTFOUND;
			col_id := col_id + 1;
			col_name := lv_column_name;
			avg_size := '         ';
			if lv_datatype = 'N' then
				var_data_type := 'NUMBER';
				if lv_avg_size = 0 then
					raise missing_avg_size;
				end if;
				if lv_avg_size > 38 then
					raise bad_avg_size;
				end if;
				lv_avg_size := ceil(lv_avg_size / 2) + 1;
				avg_size := to_char(lv_avg_size, '999,990');
			elsif lv_datatype = 'D' then
				var_data_type := 'DATE';
				lv_avg_size := 7;
				avg_size := to_char(lv_avg_size, '999,990');
			elsif lv_datatype = 'L' then
				var_data_type := 'LONG';
				avg_size := to_char(lv_avg_size, '999,990');
			elsif substr(lv_datatype, 1, 1) = 'N' then
				if instr(substr(lv_datatype, 2), '.') <> 0 then
					raise bad_datatype;
				end if;
				if lv_decimals = 0 then
					var_data_type := 'NUMBER(' ||
						substr(lv_datatype, 2) || ')';
				else
					var_data_type := 'NUMBER(' ||
						substr(lv_datatype, 2) || ','
						|| to_char(lv_decimals) || ')';
				end if;
				if lv_avg_size = 0 then
					raise missing_avg_size;
				end if;
				if lv_avg_size > 38 then
					raise bad_avg_size;
				end if;
				lv_avg_size := ceil(lv_avg_size / 2) + 1;
				avg_size := to_char(lv_avg_size, '999,990');
			elsif substr(lv_datatype, 1, 1) = 'V' then
				if instr(substr(lv_datatype, 2), '.') <> 0 then
					raise bad_datatype;
				end if;
				var_data_type := 'VARCHAR2(' ||
					substr(lv_datatype, 2) || ')';
				if lv_avg_size != 0 then
					avg_size := to_char(lv_avg_size,
						'999,990');
				else
					raise missing_avg_size;
				end if;
			elsif substr(lv_datatype, 1, 1) = 'C' then
				if instr(substr(lv_datatype, 2), '.') <> 0 then
					raise bad_datatype;
				end if;
				var_data_type := 'CHAR(' ||
					substr(lv_datatype, 2) || ')';
				lv_avg_size :=
					to_number(substr(lv_datatype, 2));
				avg_size := to_char(lv_avg_size, '999,990');
			else
				raise bad_datatype;
			end if;
			data_type := var_data_type;
			/* Calculate the sum of average sizes of all */
			/* columns for the table as per Step 3 */
			total_avg_len := total_avg_len + lv_avg_size;
			if lv_avg_size > 250 then
				num_cols_gt_250 := num_cols_gt_250 + 1;
			else
				num_cols_lt_251 := num_cols_lt_251 + 1;
			end if;
			if &ddl_table = 1 then
				if lv_db_link = ' ' then
					/* Write DDL for column data */
					if col_id <> 1 then
						d_lin := wri('D', d_lin, ',',
							0);
					end if;
					d_lin := wri('D', d_lin,
						chr(34) || lv_column_name ||
						chr(34), 0);
					d_lin := wri('D', d_lin, ' ' ||
						lower(var_data_type), 0);
				end if;
			end if;
			if lv_db_link = ' ' then
				--
				-- FETCH ANY DEFAULT VALUES FOR THIS COLUMN
				--
				print_default := FALSE;
				open default_cursor (lv_table_name,
					lv_column_name);
				fetch default_cursor into lv_default_value;
				if default_cursor%FOUND then
					print_default := TRUE;
					if &ddl_table = 1 then
						/* Write DDL for column's */
						/* defaults */
						d_lin := wri('D', d_lin,
							' DEFAULT ', 0);
						if substr(lv_datatype, 1, 1) =
							'V' or substr(
							lv_datatype, 1, 1) = 'C'
						then
							d_lin := wri('D', d_lin,
								chr(39), 0);
						end if;
						d_lin := wri('D', d_lin,
							replace(
							lv_default_value, '''',
							''''''), 0);
						if substr(lv_datatype, 1, 1) =
							'V' or substr(
							lv_datatype, 1, 1) = 'C'
						then
							d_lin := wri('D', d_lin,
								chr(39), 0);
						end if;
					end if;
				end if;
				close default_cursor;
				--
				-- FETCH ANY CONSTRAINTS FOR THIS COLUMN'S
				-- DEFINITION
				--
				n := 0;
				open constraint_cursor (lv_table_name,
					lv_column_name);
				loop
					fetch constraint_cursor into
						lv_constraint_def;
					exit when constraint_cursor%NOTFOUND;
					l := length(lv_constraint_def);
					x := 1;
					while x <= l
					loop
						if x + 9 > l then
							tmp_siz := l - x + 1;
						else
							tmp_siz := 10;
						end if;
						if n = 0 then
							a_lin := wri('R', a_lin,
								col_name ||
								' ' ||
								data_type ||
								' ' ||
								avg_size ||
								'  ' ||
								format7(
								lv_avg_size *
								lv_calc_rows) ||
								' ' || substr(
							      lv_constraint_def,
								x, tmp_siz), 1);
							n := 1;
						else
							a_lin := wri('R', a_lin,
								'           ' ||
								'        ' ||
								'           ' ||
								'        ' ||
								'           ' ||
								'        ' ||
								'       ' ||
								substr(
							      lv_constraint_def,
								x, tmp_siz), 1);
						end if;
						x := x + 10;
					end loop;
					if &ddl_table = 1 then
						/* Write DDL for column's */
						/* constraints */
						d_lin := wri('D', d_lin, ' ' ||
							lv_constraint_def, 0);
					end if;
				end loop;
				close constraint_cursor;
				if n = 0 then
					a_lin := wri('R', a_lin, col_name || ' ' ||
						data_type || ' ' || avg_size ||
						'  ' ||
						format7(
						lv_avg_size * lv_calc_rows), 1);
				end if;
			else
				a_lin := wri('R', a_lin, col_name || ' ' ||
					data_type || ' ' || avg_size || '  ' ||
					format7(lv_avg_size * lv_calc_rows), 1);
			end if;
			if lv_db_link = ' ' then
				if print_default then
					if length(lv_default_value) <= 48 then
						a_lin := wri('R', a_lin,
							'                ' ||
							'Default value: ' ||
							lv_default_value, 1);
					else
						a_lin := wri('R', a_lin,
							'               ' ||
							'           ' ||
							'Default value on' ||
							' next line:', 1);
						a_lin := wri('R', a_lin,
							lpad(lv_default_value,
							length(
							lv_default_value) +
							(80 - length(
							lv_default_value))
							/ 2), 1);
					end if;
				end if;
			end if;
		end loop;
		close column_cursor;
		if lv_db_link <> ' ' then
			/* Snapshot tables have an appended ROWID */
			col_name := 'M_ROW$$';
			var_data_type := 'VARCHAR2(18)';
			data_type := var_data_type;
			lv_avg_size := 18;
			avg_size := to_char(lv_avg_size, '999,990');
			total_avg_len := total_avg_len + 18;
			num_cols_lt_251 := num_cols_lt_251 + 1;
			a_lin := wri('R', a_lin, col_name || ' ' ||
				data_type || ' ' || avg_size || '  ' ||
				format7(lv_avg_size * lv_calc_rows), 1);
		end if;
		n := calc_tabl_kb(lv_calc_rows);
		total_db_table_size := total_db_table_size + n;
		total_db_size := total_db_size + n;
		if lv_db_link = ' ' then
			a_lin := wri('R', a_lin,
				'   Total bytes for column and bytes for table:'
				|| to_char(rowsize, '999,990') || ' ' ||
				format9(n * 1024) || ' (incl overhead)', 1);
		else
			a_lin := wri('R', a_lin,
				'          Total bytes for column and snapshot:'
				|| to_char(rowsize, '999,990') || ' ' ||
				format9(n * 1024) || ' (incl overhead)', 1);
		end if;
		/* Store byte size of this table for summary report */
		insert into tblsize_totals values('T', lv_table_name, n * 1024);
		x := calc_tabl_kb(lv_rows_month);
		insert into tblsize_summ_temp values (lv_tablespace_name,
			n * 1024, x * 1024);
		if &ddl_table = 1 then
			/* Write DDL for remainder of table/snap definition */
			if lv_db_link = ' ' then
				d_lin := wri('D', d_lin, ')', 1);
			else
				m_lin := wri('M', m_lin, ' tablespace ' ||
					lv_tablespace_name, 0);
				m_lin := wri('M', m_lin,
					' initrans &initrans_table', 0);
				m_lin := wri('M', m_lin, ' pctfree 0', 0);
				m_lin := wri('M', m_lin, ' pctused 100', 0);
				m_lin := wri('M', m_lin, ' storage (', 0);
				total_avg_len := 26;
				num_cols_gt_250 := 0;
				num_cols_lt_251 := 3;
				lv_avg_row_size := 26;
				/* Assume avg of 1000 rows per snapshot log */
				snap_log_bytes := calc_tabl_kb(1000);
				a_lin := wri('R', a_lin,
					'                 Total bytes for' ||
					' snapshot log:' || to_char(rowsize,
					'999,990') || ' ' ||
					format9(snap_log_bytes * 1024) ||
					' (incl overhead)', 1);
				snap_log_initial_extent_size := 
					extent_limit(snap_log_bytes);
				snap_log_next_extent_size :=
					extent_limit(snap_log_bytes * .6);
				m_lin := wri('M', m_lin, 'initial ' ||
					snap_log_initial_extent_size, 0);
				m_lin := wri('M', m_lin, ' next ' ||
					snap_log_next_extent_size, 0);
				m_lin := wri('M', m_lin, ' minextents 1', 0);
				m_lin := wri('M', m_lin, ' maxextents 99', 0);
				m_lin := wri('M', m_lin, ' pctincrease 0', 0);
				m_lin := wri('M', m_lin, ');', 1);
			end if;
			d_lin := wri('D', d_lin, ' tablespace ' ||
				lv_tablespace_name, 0);
			d_lin := wri('D', d_lin, ' initrans &initrans_table',
				0);
			d_lin := wri('D', d_lin, ' pctfree ' ||
				to_char(lv_pct_free), 0);
			d_lin := wri('D', d_lin, ' pctused ' ||
				to_char(lv_pct_used), 0);
			d_lin := wri('D', d_lin, ' storage (', 0);
			initial_extent_size := k_m_char(lv_tablespace_name, n);
			next_extent_size := k_m_char(lv_tablespace_name,
				n * .6);
			d_lin := wri('D', d_lin, 'initial ' ||
				initial_extent_size, 0);
			d_lin := wri('D', d_lin, ' next ' || next_extent_size,
				0);
			d_lin := wri('D', d_lin, ' minextents 1', 0);
			d_lin := wri('D', d_lin, ' maxextents 99', 0);
			d_lin := wri('D', d_lin, ' pctincrease 0', 0);
			if lv_db_link = ' ' then
				d_lin := wri('D', d_lin, ');', 1);
				d_lin := wri('D', d_lin, '', 1);
			else
				d_lin := wri('D', d_lin, ')', 1);
				d_lin := wri('D', d_lin, ' using index', 0);
			end if;
		end if;
		if lv_db_link = ' ' then
			if &ddl_synonym = 1 then
				d_lin := wri('D', d_lin, 'set term off', 1);
				d_lin := wri('D', d_lin, 'drop public synonym ',
					0);
				d_lin := wri('D', d_lin, lv_table_name || ';',
					1);
				d_lin := wri('D', d_lin, 'set term on', 1);
				d_lin := wri('D', d_lin,
					'create public synonym ', 0);
				d_lin := wri('D', d_lin, lv_table_name ||
					' for ', 0);
				d_lin := wri('D', d_lin, owner_name || '.' ||
					lv_table_name, 0);
				d_lin := wri('D', d_lin, ';', 1);
			end if;
		end if;
		--
		-- Calculate Available and Contiguous Bytes for the Index
		-- Tablespace
		--
		print_max_bytes := '0';
		open free_cursor (lv_indx_tablespace_name);
		fetch free_cursor into lv_avg_contig, lv_max_bytes;
		if free_cursor%FOUND then
			if lv_max_bytes > 1048576 then
				print_max_bytes := to_char(floor(lv_max_bytes /
					1048576)) || 'M';
			elsif lv_max_bytes > 1024 then
				print_max_bytes := to_char(floor(
					lv_max_bytes / 1024)) || 'K';
			else
				print_max_bytes := to_char(lv_max_bytes);
			end if;
		end if;
		close free_cursor;
		print_sum_bytes := ' ';
		open data_cursor (lv_indx_tablespace_name);
		fetch data_cursor into lv_sum_bytes;
		if data_cursor%FOUND then
			if lv_sum_bytes > 1048576 then
				print_sum_bytes := to_char(floor(lv_sum_bytes /
					1048576)) || 'M';
			elsif lv_sum_bytes > 1024 then
				print_sum_bytes := to_char(floor(
					lv_sum_bytes / 1024)) || 'K';
			else
				print_sum_bytes := to_char(lv_sum_bytes);
			end if;
		end if;
		close data_cursor;
		--
		-- FETCH EACH INDEX DEFINITION FOR THIS TABLE/SNAPSHOT
		--
		total_index_bytes := 0;
		x := 0;
		prev_seq_no := -1;
		open index_cursor (lv_table_name);
		loop
			fetch index_cursor into
				lv_index_name,
				lv_seq_no,
				lv_indextype,
				lv_col_position,
				lv_col_name;
			exit when index_cursor%NOTFOUND;
			col_name := lv_col_name;
			if prev_seq_no != lv_seq_no then
				if prev_seq_no = -1 then
					a_lin := wri('R', a_lin, '', 1);
					if lv_db_link = ' ' then
						a_lin := wri('R', a_lin,
							'              ' ||
							'INDEXES TO BE' ||
							' CREATED ON TABLE: ' ||
							lv_table_name, 1);
					else
						a_lin := wri('R', a_lin,
							'           ' ||
							'INDEXES TO BE' ||
							' CREATED ON' ||
							' SNAPSHOT: ' ||
							lv_table_name, 1);
					end if;
					a_lin := wri('R', a_lin,
						'                           ' ||
						'    In Tablespace: ' ||
						lv_indx_tablespace_name, 1);
					a_lin := wri('R', a_lin,
						'                           ' ||
						'  Tablespace size: ' ||
						print_sum_bytes ||
						' Max contig bytes: ' ||
						print_max_bytes, 1);
					a_lin := wri('R', a_lin, '', 1);
					a_lin := wri('R', a_lin,
						'    Index Name             ' ||
						'              Index Type' ||
						'                 Bytes', 1);
					a_lin := wri('R', a_lin,
						'    -----------------------' ||
						'------------- ----------' ||
						'-                -----', 1);
				else
					n := calc_indx_kb(lv_calc_rows);
					x := x + calc_indx_kb(lv_rows_month);
					total_index_bytes := total_index_bytes +
						n * 1024;
					total_db_index_size :=
						total_db_index_size + n * 1024;
					total_db_size := total_db_size + n;
					a_lin := wri('R', a_lin, '    ' ||
						index_name || '       ' ||
						index_type || '          ' ||
						format11(n * 1024), 1);
					if &ddl_index = 1 then
						/* Write DDL for remainder of */
						/* index definition */
						d_lin := wri('D', d_lin, ')',
							0);
						if var_index_type =
							'Primary Key'
						then
							d_lin := wri('D', d_lin,
								' using index',
								0);
						end if;
						d_lin := wri('D', d_lin,
							' tablespace ' ||
							lv_indx_tablespace_name,
							0);
						d_lin := wri('D', d_lin,
							' initrans ' ||
							'&initrans_index', 0);
						d_lin := wri('D', d_lin,
							' pctfree ' ||
							to_char(lv_pct_free),
							0);
						initial_extent_size :=
							k_m_char(
							lv_indx_tablespace_name,
							n);
						if var_index_type = 'Bitmap'
						then
							next_extent_size :=
								k_m_char(
							lv_indx_tablespace_name,
								n);
						else
							next_extent_size :=
								k_m_char(
							lv_indx_tablespace_name,
								n * .6);
						end if;
						d_lin := wri('D', d_lin,
							' storage (initial ' ||
							initial_extent_size, 0);
						d_lin := wri('D', d_lin,
							' next ' ||
							next_extent_size, 0);
						d_lin := wri('D', d_lin,
							' pctincrease 0', 0);
						d_lin := wri('D', d_lin, ');',
							1);
					end if;
					a_lin := wri('R', a_lin, '', 1);
				end if;
				if lv_indextype = 'P' then
					var_index_type := 'Primary Key';
				elsif lv_indextype = 'U' then
					var_index_type := 'Unique';
				elsif lv_indextype = 'I' then
					var_index_type := 'Non-Unique';
				elsif lv_indextype = 'B' then
					var_index_type := 'Bitmap';
				else
					raise bad_indextype;
				end if;
				index_type := var_index_type;
				index_name := lv_index_name;
				if lv_index_name is null then
					if lv_db_link = ' ' then
						lv_index_name := 'IND_' ||
							substr(lv_table_name,
							1, 23) || '_' ||
							substr(to_char(
							lv_seq_no, '00'), 2);
					else
						index_name := 'I_SNAP$_' ||
							substr(lv_table_name,
							1, 20);
					end if;
				end if;
				if &ddl_index = 1 and lv_db_link = ' ' then
					/* Write DDL for index definitions */
					d_lin := wri('D', d_lin, '', 1);
					if &ddl_table = 0 then
						d_lin := wri('D', d_lin,
							'set term off', 1);
						if var_index_type =
							'Primary Key'
						then
							d_lin := wri('D', d_lin,
								'alter table ',
								0);
							d_lin := wri('D', d_lin,
								owner_name ||
								'.' ||
								lv_table_name,
								0);
							d_lin := wri('D', d_lin,
								' drop primary'
								|| ' key;', 1);
						else
							d_lin := wri('D', d_lin,
								'drop index ' ||
								owner_name ||
								'.' ||
								lv_index_name
								|| ';', 1);
						end if;
						d_lin := wri('D', d_lin,
							'set term on', 1);
					end if;
					if var_index_type = 'Unique' then
						d_lin := wri('D', d_lin,
							'create unique index ',
							0);
						d_lin := wri('D', d_lin,
							owner_name || '.' ||
							lv_index_name, 0);
						d_lin := wri('D', d_lin,
							' on ', 0);
						d_lin := wri('D', d_lin,
							owner_name || '.' ||
							lv_table_name, 0);
						d_lin := wri('D', d_lin, ' (',
							0);
					elsif var_index_type = 'Primary Key'
					then
						d_lin := wri('D', d_lin,
							'alter table ', 0);
						d_lin := wri('D', d_lin,
							owner_name || '.' ||
							lv_table_name, 0);
						d_lin := wri('D', d_lin,
							' add constraint ', 0);
						d_lin := wri('D', d_lin,
							lv_index_name, 0);
						d_lin := wri('D', d_lin,
							' primary key (', 0);
					elsif var_index_type = 'Bitmap' then
						d_lin := wri('D', d_lin,
							'create bitmap index ',
							0);
						d_lin := wri('D', d_lin,
							owner_name || '.' ||
							lv_index_name, 0);
						d_lin := wri('D', d_lin,
							' on ', 0);
						d_lin := wri('D', d_lin,
							owner_name || '.' ||
							lv_table_name, 0);
						d_lin := wri('D', d_lin, ' (',
							0);
					else
						d_lin := wri('D', d_lin,
							'create index ', 0);
						d_lin := wri('D', d_lin,
							owner_name || '.' ||
							lv_index_name, 0);
						d_lin := wri('D', d_lin,
							' on ', 0);
						d_lin := wri('D', d_lin,
							owner_name || '.' ||
							lv_table_name, 0);
						d_lin := wri('D', d_lin, ' (',
							0);
					end if;
					/* Init the sum of the columns */
					/* comprising the index */
					total_avg_ndx_len := 0;
					num_cols_gt_128 := 0;
					num_cols_lt_129 := 0;
				end if;
				prev_seq_no := lv_seq_no;
			end if;
			if lv_db_link = ' ' then
				open index_col_cursor (lv_table_name,
					lv_col_name);
				fetch index_col_cursor into
					lv_datatype, lv_avg_size;
				if index_col_cursor%NOTFOUND then
					-- Handle snapshot rowid avg size
					if lv_col_name = 'M_ROW$$' then
						lv_datatype := 'V18';
						lv_avg_size := 18;
					else
						raise missing_avg_index_size;
					end if;
				end if;
				close index_col_cursor;
				if lv_datatype = 'N' then
					if lv_avg_size = 0 then
						raise missing_avg_index_size;
					end if;
					lv_avg_size := ceil(lv_avg_size / 2) +
						1;
				elsif lv_datatype = 'D' then
					lv_avg_size := 7;
				elsif substr(lv_datatype, 1, 1) = 'N' then
					if lv_avg_size = 0 then
						raise missing_avg_index_size;
					end if;
					lv_avg_size := ceil(lv_avg_size / 2) +
						1;
				elsif substr(lv_datatype, 1, 1) = 'V' then
					if lv_avg_size = 0 then
						raise missing_avg_index_size;
					end if;
				elsif substr(lv_datatype, 1, 1) = 'C' then
					lv_avg_size := to_number(substr(
						lv_datatype, 2));
				else
					raise bad_datatype;
				end if;
				/* Accumulate the sum of average sizes of all */
				/* columns for the index as per Step 3 */
				total_avg_ndx_len := total_avg_ndx_len +
					lv_avg_size;
				if lv_avg_size > 128 then
					num_cols_gt_128 := num_cols_gt_128 + 1;
				else
					num_cols_lt_129 := num_cols_lt_129 + 1;
				end if;
				if &ddl_index = 1 then
					/* Write DDL for index's column data */
					if lv_col_position != 1 then
						d_lin := wri('D', d_lin, ',',
							0);
					end if;
					d_lin := wri('D', d_lin, chr(34) ||
						lv_col_name || chr(34), 0);
				end if;
			else
				lv_datatype := 'V18';
				lv_avg_size := 18;
				/* Accumulate the sum of average sizes of all */
				/* columns for the index as per Step 3 */
				total_avg_ndx_len := 18;
				num_cols_gt_128 := 0;
				num_cols_lt_129 := 1;
			end if;
			a_lin := wri('R', a_lin, '      Column: ' ||
				col_name || '                  ' ||
				format11(lv_avg_size * lv_calc_rows), 1);
		end loop;
		close index_cursor;
		if prev_seq_no != -1 then
			n := calc_indx_kb(lv_calc_rows);
			x := x + calc_indx_kb(lv_rows_month);
			total_index_bytes := total_index_bytes + n * 1024;
			total_db_index_size := total_db_index_size + n * 1024;
			total_db_size := total_db_size + n;
			a_lin := wri('R', a_lin, '    ' || index_name ||
				'       ' || index_type || '          ' ||
				format11(n * 1024), 1);
			if &ddl_index = 1 then
				/* Write DDL for remainder of index */
				/* definition */
				if lv_db_link = ' ' then
					d_lin := wri('D', d_lin, ')', 0);
					if var_index_type = 'Primary Key' then
						d_lin := wri('D', d_lin,
							' using index', 0);
					end if;
				end if;
				d_lin := wri('D', d_lin, ' tablespace ' ||
					lv_indx_tablespace_name, 0);
				d_lin := wri('D', d_lin,
					' initrans &initrans_index', 0);
				d_lin := wri('D', d_lin, ' pctfree ' ||
					to_char(lv_pct_free), 1);
				initial_extent_size := k_m_char(
					lv_indx_tablespace_name, n);
				if var_index_type = 'Bitmap' then
					next_extent_size := k_m_char(
						lv_indx_tablespace_name,
						n);
				else
					next_extent_size := k_m_char(
						lv_indx_tablespace_name,
						n * .6);
				end if;
				d_lin := wri('D', d_lin,
					' storage (initial ' ||
					initial_extent_size, 0);
				d_lin := wri('D', d_lin, ' next ' ||
					next_extent_size, 0);
				d_lin := wri('D', d_lin, ' minextents 1', 0);
				d_lin := wri('D', d_lin, ' maxextents 99', 0);
				d_lin := wri('D', d_lin,
					' pctincrease 0', 0);
				if lv_db_link = ' ' then
					d_lin := wri('D', d_lin, ');', 1);
				else
					d_lin := wri('D', d_lin, ')', 1);
					/* Default Snapshot REFRESH clause: */
					d_lin := wri('D', d_lin,
						' refresh fast start with' ||
						' (trunc(sysdate)) next' ||
						' (trunc(sysdate+1) + 23/24)',
						1);
					/* Default Snapshot subquery clause: */
					d_lin := wri('D', d_lin,
						' as select * from ', 0);
					d_lin := wri('D', d_lin, owner_name ||
						'.' || lv_table_name, 0);
					d_lin := wri('D', d_lin, '@' ||
						lv_db_link || ';', 1);
					d_lin := wri('D', d_lin, '', 1);
				end if;
			end if;
			a_lin := wri('R', a_lin, '', 1);
			if lv_db_link = ' ' then
				a_lin := wri('R', a_lin,
					'        Total bytes for this' ||
					' table''s' ||
					' indexes (incl overhead): ' ||
					format11(total_index_bytes), 1);
			else
				a_lin := wri('R', a_lin,
					'     Total bytes for this' ||
					' snapshot''s' ||
					' indexes (incl overhead): ' ||
					format11(total_index_bytes), 1);
			end if;
			/* Store byte size of this table's indexes for */
			/* summary report */
			insert into tblsize_totals values('I', lv_table_name,
				total_index_bytes);
			insert into tblsize_summ_temp values
				(lv_indx_tablespace_name, total_index_bytes,
				x * 1024);
			a_lin := wri('R', a_lin, '', 1);
		end if;
	end loop;
	close table_cursor;
	a_lin := wri('R', a_lin, '', 1);
	a_lin := wri('R', a_lin, '------------------------------------' ||
		'------------------------------------', 1);
	a_lin := wri('R', a_lin, '', 1);
	if lv_db_link = ' ' then
		a_lin := wri('R', a_lin, '    Grand Total bytes for this' ||
			' database''s tables:   ' ||
			format11(total_db_table_size * 1024), 1);
	else
		a_lin := wri('R', a_lin, ' Grand Total bytes for this' ||
			' database''s snapshots:   ' ||
			format11(total_db_table_size * 1024), 1);
	end if;
	a_lin := wri('R', a_lin, '', 1);
	a_lin := wri('R', a_lin, '    Grand Total bytes for this' ||
		' database''s indexes:  ' || format11(total_db_index_size), 1);
	a_lin := wri('R', a_lin, '', 1);
	a_lin := wri('R', a_lin, '              GRAND TOTAL BYTES' ||
		' FOR THIS DATABASE:  ' || format11(total_db_size * 1024), 1);
	a_lin := wri('R', a_lin, '', 1);
	a_lin := wri('R', a_lin, '', 1);
	/* Print report of tables, in decreasing order by size */
	if lv_db_link = ' ' then
		a_lin := wri('R', a_lin,
			'                              Sizes of all Tables', 1);
		a_lin := wri('R', a_lin,
			'                              ===================', 1);
		a_lin := wri('R', a_lin, '', 1);
		a_lin := wri('R', a_lin, '                  Table Name' ||
			'                      Byte Size', 1);
		a_lin := wri('R', a_lin, '                  ----------' ||
			'--------------------  ---------', 1);
	else
		a_lin := wri('R', a_lin,
			'                             Sizes of all Snapshots',
			1);
		a_lin := wri('R', a_lin,
			'                             ======================',
			1);
		a_lin := wri('R', a_lin, '', 1);
		a_lin := wri('R', a_lin, '                  Snapshot Name' ||
			'                   Byte Size', 1);
		a_lin := wri('R', a_lin, '                  -------------' ||
			'-----------------  ---------', 1);
	end if;
	open size_totals_cursor ('T');
	loop
		fetch size_totals_cursor into
			lv_obj_name,
			lv_obj_size;
		exit when size_totals_cursor%NOTFOUND;
		a_lin := wri('R', a_lin, '                  ' || lv_obj_name ||
			format11(lv_obj_size), 1);
	end loop;
	close size_totals_cursor;
	/* Print report of indexes, in decreasing order by size */
	a_lin := wri('R', a_lin, '', 1);
	a_lin := wri('R', a_lin, '', 1);
	if lv_db_link = ' ' then
		a_lin := wri('R', a_lin, '                   Total size of' ||
			' all Indexes on each Table', 1);
		a_lin := wri('R', a_lin, '                   =============' ||
			'==========================', 1);
	else
		a_lin := wri('R', a_lin, '                Total size of' ||
			' all Indexes on each Snapshot', 1);
		a_lin := wri('R', a_lin, '                =============' ||
			'=============================', 1);
	end if;
	a_lin := wri('R', a_lin, '', 1);
	if lv_db_link = ' ' then
		a_lin := wri('R', a_lin, '                  Table Name' ||
			'                      Byte Size', 1);
		a_lin := wri('R', a_lin, '                  ----------' ||
			'--------------------  ---------', 1);
	else
		a_lin := wri('R', a_lin, '                  Snapshot Name' ||
			'                   Byte Size', 1);
		a_lin := wri('R', a_lin, '                  -------------' ||
			'-----------------  ---------', 1);
	end if;
	open size_totals_cursor ('I');
	loop
		fetch size_totals_cursor into
			lv_obj_name,
			lv_obj_size;
		exit when size_totals_cursor%NOTFOUND;
		a_lin := wri('R', a_lin, '                  ' || lv_obj_name ||
			format11(lv_obj_size), 1);
	end loop;
	close size_totals_cursor;
	prev_tablespace_name := '@';
	a_lin := wri('R', a_lin, '', 1);
	a_lin := wri('R', a_lin,
		'                              Usage by Tablespace', 1);
	a_lin := wri('R', a_lin,
		'                              ===================', 1);
	a_lin := wri('R', a_lin, '', 1);
	if lv_db_link = ' ' then
		a_lin := wri('R', a_lin, '     Table Name            ' ||
			'            Num Rows  Rows/Month       Bytes', 1);
	else
		a_lin := wri('R', a_lin, '     Snapshot Name         ' ||
			'            Num Rows  Rows/Month       Bytes', 1);
	end if;
	a_lin := wri('R', a_lin, '     ----------------------' ||
		'-------- ----------- ----------- -----------', 1);
	open table_tablespace_cursor;
	loop
		fetch table_tablespace_cursor into
			lv_tablespace_name,
			lv_table_name,
			lv_num_rows,
			lv_rows_month,
			lv_obj_size;
		exit when table_tablespace_cursor%NOTFOUND;
		table_name := lv_table_name;
		if prev_tablespace_name <> lv_tablespace_name then
			a_lin := wri('R', a_lin, 'Tablespace: ' ||
				lv_tablespace_name, 1);
			prev_tablespace_name := lv_tablespace_name;
		end if;
		a_lin := wri('R', a_lin, '     ' || table_name || ' ' ||
			format11(lv_num_rows) || ' ' ||
			format11(lv_rows_month) || ' ' ||
			format11(lv_obj_size), 1);
	end loop;
	close table_tablespace_cursor;
	a_lin := wri('R', a_lin, '', 1);
	a_lin := wri('R', a_lin,
		'                            Tablespace Summary Usage', 1);
	a_lin := wri('R', a_lin,
		'                            ========================', 1);
	a_lin := wri('R', a_lin, '', 1);
	a_lin := wri('R', a_lin, '                               Data ' ||
		' Planned Actual Planned Planned Growth', 1);
	a_lin := wri('R', a_lin, '                               File ' ||
		'  Bytes   Bytes  Avail    Pct    per   Max', 1);
	a_lin := wri('R', a_lin, 'Tablespace Name                Bytes' ||
		'  Used    Used   Bytes   Avail  Month Months', 1);
	a_lin := wri('R', a_lin, '------------------------------ -----' ||
		' ------- ------ ------- ------- ----- ------', 1);
	/* Create tablespace summary */
	total_db_size := 0;
	total_db_table_size := 0;
	total_db_index_size := 0;
	open tablespace_cursor;
	loop
		fetch tablespace_cursor into
			lv_tablespace_name,
			lv_bytes,
			growth_per_month;
		exit when tablespace_cursor%NOTFOUND;
		lv_sum_bytes := 0;
		print_data_bytes := ' ';
		open data_cursor (lv_tablespace_name);
		fetch data_cursor into lv_sum_bytes;
		if data_cursor%FOUND then
			print_data_bytes := format5(lv_sum_bytes);
		end if;
		close data_cursor;
		lv_actual_used := 0;
		print_actual_used := ' ';
		open used_cursor (lv_tablespace_name);
		fetch used_cursor into lv_actual_used;
		if used_cursor%FOUND then
			print_actual_used := format7(lv_actual_used);
		end if;
		close used_cursor;
		table_name := lv_tablespace_name;
		print_bytes := format7(lv_bytes);
		lv_avail_bytes := lv_sum_bytes - lv_bytes;
		print_avail_bytes := format7t(lv_avail_bytes);
		print_growth := format5(growth_per_month);
		if lv_sum_bytes = 0 then
			print_pct_avail := ' 100%';
		else
			print_pct_avail := to_char(100 * lv_avail_bytes /
				lv_sum_bytes, '990') || '%';
		end if;
		if growth_per_month = 0 then
			print_max_months := ' ';
		else
			n := (lv_sum_bytes - lv_actual_used) / growth_per_month;
			if n > 99999 then
				print_max_months := ' never';
			else
				if n < 1 then
					print_max_months := ' *NOW*';
				else
					print_max_months := to_char(n, '99990');
				end if;
			end if;
		end if;
		total_db_size := total_db_size + lv_sum_bytes;
		total_db_table_size := total_db_table_size + lv_bytes;
		total_db_index_size := total_db_index_size + lv_actual_used;
		a_lin := wri('R', a_lin, table_name || ' ' ||
			print_data_bytes || ' ' || print_bytes ||
			print_actual_used || ' ' || print_avail_bytes ||
			'  ' || print_pct_avail || '  ' || print_growth ||
			' ' || print_max_months, 1);
		/* Write tablespace DDL file */
		if &ddl_tablespace = 1 then
			/* Calculate tablespace total byte size and path */
			/* (Include 1M + DB_BLOCK_SIZE overhead if raw */
			/*  partitions) */
			if &ddl_raw = 1 then
				overhead := 1048576 + lv_db_block_size;
				data_file_size := 1048576000 - overhead;
				tablespace_path := '/dev/vx/rdsk/ORA_VOL/';
				datafile_suffix := '_APPL';
			else
				overhead := 0;
				data_file_size := 943718400;
				tablespace_path := '/u01/oradata/ORASID/';
				datafile_suffix := '';
			end if;
			/* Calculate number of 900MB (999MB if raw) data */
			/* files to be created */
			n := floor(lv_bytes * 1.2 / data_file_size);
			if n = 0 then
				n := 1;
			end if;
			last_data_file_size := floor(lv_bytes * 1.2) + overhead;
			if n <> 1 then
				last_data_file_size := trunc(lv_bytes * 1.2 -
					n * data_file_size) + overhead;
				lv_bytes := data_file_size;
				n := n + 1;
			end if;
			/* Write DDL for table data */
			d_lin := wri('S', d_lin, 'rem', 1);
			d_lin := wri('S', d_lin, 'rem ---------------------' ||
				'--------------------------------------------',
				1);
			d_lin := wri('S', d_lin, 'rem', 1);
			d_lin := wri('S', d_lin, 'create tablespace ' ||
				lv_tablespace_name || ' datafile', 1);
			for i in 1..n
			loop
				if i = n then
					lv_bytes := last_data_file_size;
				end if;
				/* Calculate extent sizes in Mbytes or */
				/* Kbytes, if possible */
				if mod(lv_bytes, 1048576) = 0 or
					lv_bytes > 10238976
				then
					initial_size :=
						to_char(floor((lv_bytes +
						1048575) / 1048576)) || 'M';
				elsif mod(lv_bytes, 1024) = 0 or lv_bytes > 9999
				then
					initial_size :=
						to_char(floor((lv_bytes + 1023)
						/ 1024)) || 'K';
				else
					initial_size := to_char(lv_bytes);
				end if;
				if i = n then
					d_lin := wri('S', d_lin, '    ' || &q ||
						tablespace_path ||
						lv_tablespace_name || '_' ||
						to_char(i) || datafile_suffix ||
						&q, 0);
					d_lin := wri('S', d_lin,
						' size ' || initial_size, 0);
					d_lin := wri('S', d_lin,
						' default storage', 1);
				else
					d_lin := wri('S', d_lin, '    ' || &q ||
						tablespace_path ||
						lv_tablespace_name || '_' ||
						to_char(i) || datafile_suffix ||
						&q, 0);
					d_lin := wri('S', d_lin,
						' size ' || initial_size || ',',
						1);
				end if;
			end loop;
			d_lin := wri('S', d_lin, '    (initial 10k next 10k' ||
				' pctincrease 1 minextents 1 maxextents 100);',
				1);
		end if;
	end loop;
	close tablespace_cursor;
	/* Print Summary Totals */
	print_data_bytes := format5(total_db_size);
	print_bytes := format7t(total_db_table_size);
	print_actual_used := format7t(total_db_index_size);
	lv_avail_bytes := total_db_size - total_db_table_size;
	print_avail_bytes := format7t(lv_avail_bytes);
	a_lin := wri('R', a_lin, '            TOTALS:            -----' ||
		' ------- ------ -------', 1);
	table_name := ' ';
	a_lin := wri('R', a_lin, table_name || ' ' ||
		print_data_bytes || ' ' || print_bytes ||
		print_actual_used || ' ' || print_avail_bytes, 1);
	commit;
	d_lin := wri('D', d_lin, '', 1);
	if lv_db_link = ' ' then
		d_lin := wri('D', d_lin, 'prompt Ignore any errors from' ||
			' non-existent triggers.sql', 1);
		d_lin := wri('D', d_lin, '@triggers', 1);
		d_lin := wri('D', d_lin, '', 1);
		d_lin := wri('D', d_lin, 'prompt Ignore any errors from' ||
			' non-existent constraints.sql', 1);
		d_lin := wri('D', d_lin, '@constraints', 1);
		d_lin := wri('D', d_lin, '', 1);
	else
		m_lin := wri('M', m_lin, '', 1);
		m_lin := wri('M', m_lin, 'spool off', 1);
		m_lin := wri('M', m_lin, 'exit', 1);
	end if;
	d_lin := wri('D', d_lin, 'spool off', 1);
	d_lin := wri('D', d_lin, 'exit', 1);
	d_lin := wri('S', d_lin, '', 1);
	d_lin := wri('S', d_lin, 'spool off', 1);
	d_lin := wri('S', d_lin, 'exit', 1);
exception
	when no_db_block_size then
		rollback;
		raise_application_error(-20000,
			'Error - No DB_BLOCK_SIZE found in tbldefb -' ||
			' Aborting...');
	when bad_datatype then
		rollback;
		raise_application_error(-20000,
			'Error - Unexpected datatype of ' || lv_datatype ||
			' found for column ' || lv_column_name || ' in table '
			|| lv_table_name);
	when bad_indextype then
		rollback;
		raise_application_error(-20000,
			'Error - Unexpected index type of ' || lv_indextype ||
			' found for column ' || lv_col_name || ' in table ' ||
			lv_table_name);
	when bad_avg_size then
		rollback;
		raise_application_error(-20000,
			'Error - Bad avg_size found for column ' ||
			lv_column_name || ' in table ' || lv_table_name);
	when missing_avg_size then
		rollback;
		raise_application_error(-20000,
			'Error - No avg_size found for column ' ||
			lv_column_name || ' in table ' || lv_table_name);
	when missing_avg_index_size then
		rollback;
		raise_application_error(-20000,
			'Error - No avg_size found for index column ' ||
			lv_col_name || ' in table ' || lv_table_name);
end;
/
rem
rem Create report
rem
set linesize 80
set termout off
set concat +
spool tblsize.lst
set concat .
select text from tblsize_temp where code = 'R' order by lineno;
spool off
rem
rem Create DDL scripts
rem
set concat +
spool tblddl.sql
set concat .
select text from tblsize_temp where code = 'D' order by lineno;
spool off
set concat +
spool tblsnap.sql
set concat .
select text from tblsize_temp where code = 'M' order by lineno;
spool off
set concat +
spool tblspddl.sql
set concat .
select text from tblsize_temp where code = 'S' order by lineno;
spool off
drop table tblsize_totals;
drop table tblsize_summ_temp;
drop table tblsize_temp;
drop table tbldefb;
drop table tbldeft;
drop table tbldefa;
drop table tbldefc;
drop table tbldefdef;
drop table tbldefcon;
drop table tbldefi;
drop table tbldefk;
set termout on
prompt
prompt Created tblsize.lst report for your viewing pleasure...
prompt Created tblddl.sql containing the DDL to create the database objects...
prompt Created tblsnap.sql containing the DDL to create the snapshot logs...
prompt Created tblspddl.sql containing the DDL to create the tablespaces...
prompt
exit

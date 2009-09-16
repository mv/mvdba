rem $dba/privsdc.sql
rem
rem Called by $dba/privs.sql to print the Direct and Public Column Grants for
rem the specified user or role
rem
rem Input:  &1 = A user or role name (including PUBLIC)
rem
rem Last Change 09/17/97 by Brian Lomasky
rem
set echo off
set feedback off
set heading off
set pagesize 0
set termout off
set verify off
column name new_value _name
select name from v$database;
set heading on
set termout on
set pagesize 9999
spool privs2.lis

create table priv_temp (
	gte VARCHAR2(30),
	tb_owner VARCHAR2(30),
	tb_name VARCHAR2(30),
	priv VARCHAR2(4),
	gtbl VARCHAR2(4)
	);

declare
	cursor priv_cursor is	select grantee, owner, table_name, privilege,
					grantable
				from sys.dba_col_privs
				where owner != 'SYS' and owner != 'SYSTEM' and
				(grantee = UPPER('&1') or grantee = 'PUBLIC')
				order by grantee, owner, table_name;

	lv_gte			sys.dba_col_privs.grantee%TYPE;
	lv_owner		sys.dba_col_privs.owner%TYPE;
	lv_table_name		sys.dba_col_privs.table_name%TYPE;
	lv_privilege		sys.dba_col_privs.privilege%TYPE;
	lv_grantable		sys.dba_col_privs.grantable%TYPE;
	last_gte		sys.dba_col_privs.grantee%TYPE;
	last_owner		sys.dba_col_privs.owner%TYPE;
	last_table_name		sys.dba_col_privs.table_name%TYPE;
	last_priv		VARCHAR2(4);
	last_gtbl		VARCHAR2(4);
	lv_first_rec		BOOLEAN;
	lv_string		VARCHAR2(80);

	procedure write_out(p_gte varchar2, p_owner varchar2, p_name varchar2,
		p_priv varchar2, p_gtbl varchar2) is
		begin
			insert into priv_temp values (p_gte, p_owner, p_name,
				p_priv, p_gtbl);
		end;

begin
	last_gte := '@';
	open priv_cursor;
	loop
		fetch priv_cursor into lv_gte, lv_owner, lv_table_name,
			lv_privilege, lv_grantable;
		exit when priv_cursor%notfound;
		if lv_gte != last_gte or lv_owner != last_owner or lv_table_name
			!= last_table_name
		then
			if last_gte != '@' then
				write_out(last_gte, last_owner, last_table_name,
					last_priv, last_gtbl);
			end if;
			last_gte := lv_gte;
			last_owner := lv_owner;
			last_table_name := lv_table_name;
			last_priv := '    ';
			last_gtbl := 'nnnn';
		end if;
		if lv_privilege = 'DELETE' then
			last_priv := 'D' || substr(last_priv,2,3);
			if lv_grantable = 'YES' then
				last_gtbl := 'Y' || substr(last_gtbl,2,3);
			end if;
		elsif lv_privilege = 'INSERT' then
			last_priv := substr(last_priv,1,1) || 'I' ||
				substr(last_priv,3,2);
			if lv_grantable = 'YES' then
				last_gtbl := substr(last_gtbl,1,1) ||
					'Y' || substr(last_gtbl,3,2);
			end if;
		elsif lv_privilege = 'SELECT' then
			last_priv := substr(last_priv,1,2) || 'S' ||
				substr(last_priv,4,1);
			if lv_grantable = 'YES' then
				last_gtbl := substr(last_gtbl,1,2) ||
					'Y' || substr(last_gtbl,4,1);
			end if;
		elsif lv_privilege = 'UPDATE' then
			last_priv := substr(last_priv,1,3) || 'U';
			if lv_grantable = 'YES' then
				last_gtbl := substr(last_gtbl,1,3) || 'Y';
			end if;
		end if;
	end loop;
	if last_gte != '@' then
		write_out(last_gte, last_owner, last_table_name, last_priv,
			last_gtbl);
	end if;
	close priv_cursor;
end;
/
set termout off
column tb_owner format a13 heading "Owner"
column tb_name format a28 heading "Table Name"
column priv format a12 heading "Privilege"
column adm format a5 heading "Admin"
ttitle 'Direct column grants to &1 in '_NAME skip 2
select tb_owner owner, tb_name table_name, priv privilege, gtbl adm
	from priv_temp
	where gte = UPPER('&1') and UPPER('&1') <> 'PUBLIC'
	order by 1, 2;
ttitle 'Direct column grants to PUBLIC in '_NAME skip 2
select tb_owner owner, tb_name table_name, priv privilege, gtbl adm
	from priv_temp
	where gte = 'PUBLIC'
	order by 1, 2;
spool off
drop table priv_temp;
exit

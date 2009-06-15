CREATE OR REPLACE PACKAGE sqla$ AS
/* $Header: sqlapkgs.sql 238684.1 2003/12/01 12:00:00 pkm ship $ */

PROCEDURE truncate_repo;

PROCEDURE purge_repo
( p_days_to_keep    IN  NUMBER
 );

PROCEDURE env
( x_platform        OUT VARCHAR2,
  x_database        OUT VARCHAR2,
  x_instance        OUT VARCHAR2,
  x_startup_time    OUT VARCHAR2,
  x_rdbms_release   OUT VARCHAR2,
  x_cpu_count       OUT VARCHAR2
 );

PROCEDURE collect
( p_snap_id         IN  NUMBER
 );

PROCEDURE explain_plan
( p_snap_id         IN  NUMBER
 );

PROCEDURE sql_plan
( p_snap_id         IN  NUMBER
 );

PROCEDURE tables_indexes
( p_snap_id         IN  NUMBER
 );

PROCEDURE snapshot_top
( p_snap_id         IN  NUMBER,
  p_top             IN  NUMBER
 );

PROCEDURE snapshot
( p_top             IN  NUMBER DEFAULT 10
 );

PROCEDURE range
( p_range_id        IN  NUMBER,
  p_snap_id_from    IN  NUMBER,
  p_snap_id_to      IN  NUMBER,
  p_process_type    IN  VARCHAR2,
  p_top             IN  NUMBER
 );

PROCEDURE put_line
( p_line            IN  VARCHAR2
 );

PROCEDURE put_just_stars;

PROCEDURE put_stars;

PROCEDURE put_cursor
( p_top_range       IN  NUMBER,
  p_snap_id         IN  NUMBER,
  p_top_snap        IN  NUMBER
 );

PROCEDURE put_cursors_snap
( p_snap_id         IN  NUMBER
 );

PROCEDURE put_cursors_range
( p_range_id        IN  NUMBER
 );

END sqla$;
/

PRO
PRO SQLA$ Package has been created
PRO

SHOW ERRORS PACKAGE sqla$;
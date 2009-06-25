#
# Creating a catalog
#
#

sqlplus / as sysdba <<SQL

    create user rman identified by rman
    default tablespace USERS
    quota unlimited on USERS
    ;

    grant recovery_catalog_owner to rman;

SQL

rman catalog rman/rman <<RMAN
    create catalog;
RMAN


#
# Registering a database
#

rman target / catalog rman/rman <<RMAN
    register database;
RMAN


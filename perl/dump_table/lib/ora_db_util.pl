# $Id: ora_db_util.pl 6 2006-09-10 15:35:16Z marcus $
#
# My ORACLE sub-routines
#

sub conn_db
{
    my $usr = shift;
    my $psw = shift;
    my $sid = shift;

    print "\n\n    Connecting: $usr [ at ] $sid .... ";

    # error Checking
    my %attr = ( PrintError => 1
               , RaiseError => 1
               );
    # Connect
    $dbh = DBI->connect("dbi:Oracle:$sid","$usr" ,"$psw" , \%attr )
                or die "\nCannot connect : ", $DBI::errstr, "\n" ;

    print "ok\n\n";
    return $dbh;
}

sub get_columns
{
    # Return table columns in a list

    my $owner = shift;
    my $tab   = shift;
    my $sql = <<"    SQL";
    /* $0 */
    SELECT LOWER(column_name) column_name
      FROM all_tab_columns
     WHERE owner      = :1
       AND table_name = :2
     ORDER BY column_id
    SQL

    my $sth=$dbh->prepare ($sql);
    $sth->bind_param( 1, uc($owner) );
    $sth->bind_param( 2, uc($tab)   );
    $sth->execute;

    my ($colname, @cols);
    while ( $colname = $sth->fetchrow_array )
    {
        push @cols, $colname;
    }

    die "No columns found for $owner.$tab .\n\n" unless defined @cols;

    return @cols;
}

sub get_tables
{
    # Return table names in a list

    my $owner = shift;
    my $sql = <<"    SQL";
    /* $0 */
    SELECT LOWER(table_name) table_name
      FROM all_tables
     WHERE owner      = :1
     ORDER BY table_name
    SQL

    my $sth=$dbh->prepare ($sql);
    $sth->bind_param( 1, uc($owner) );
    $sth->execute;

    my ($tabname, @tabs);
    while ( $tabname = $sth->fetchrow_array )
    {
        push @tabs, $tabname;
    }

    die "No tables found for $owner.\n\n" unless defined @tabs;

    return @tabs;
}

return 1;

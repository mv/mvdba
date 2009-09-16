#!perl
# $Id: idind.pl 18320 2007-08-07 13:58:24Z marcus.ferreira $
#
# Marcus Vinicius Ferreira      ferreira.mv[  at  ]gmail.com  Jan/2007
#
# ident of database objects

die <<Thanatos unless (@ARGV);

    Usage: $0 <script.sql>

Thanatos

my (%obj, %tab);
my $CONN='apps/apps@dev6';

foreach my $file (sort @ARGV) {
    next unless -T $file;
    printf "\nfile: %-35s\n", $file;

    open my $fh, "<", $file or die "Cannot open $file: $!";
    my $code = do { local $/; <$fh> };
    close $fh;

    my ($oname, $tname);
    while( pos $code < length $code) {
        if( $code =~ /CREATE \s+ (?:UNIQUE \s+)? (?:BITMAP \s+)? INDEX \s+ # UNIQUE|BITMAP INDEX
                     (?:\w+[.])?                        # schema
                     (\w+)          \s+                 # index_name    # $1
                     ON             \s+
                     (?:\w+[.])?                        # schema
                     (\w+)          \s+                 # table_name    # $2
                     /gcxims
        ){
            #printf "match: [%s] [%s] [%s] [%s]\n\n", $1, $2, $3, $4;
            ($oname, $tname) = map {uc $_} ($1, $2);
            if( $oname ) { printf "      ind: %-35s", "[$oname]"; $obj{$oname}++; }
            if( $tname ) { print " table: [$tname]\n";        $tab{$tname}++; }
        }
        else { last; }
    }
    print "\n";
}

my @where;
my @obj = map{ uc $_ } sort keys %obj;
my @tab = map{ uc $_ } sort keys %tab;

if( scalar @obj > 1 ) { $where[0] = join "', '", @obj; $where[0] = "in ('". $where[0] . "')"; }
                 else { $where[0] = " = '$obj[0]' "; }
if( scalar @tab > 1 ) { $where[1] = join "', '", @tab; $where[1] = "in ('". $where[1] . "')"; }
                 else { $where[1] = " = '$tab[0]' "; }

# $where[2] = q{ (text LIKE '%\\$Header%' OR text LIKE '%\\$Id%') };
my $sql = qq {
    set trimspool on
    set linesize 1000
    set feedback off

    column index_owner format a12
    column table_owner format a12
    column index_name  format a32
    column table_name  format a30
    column column_name format a30

    SELECT table_owner
         , table_name
         , index_owner
         , index_name
         , column_name
      FROM all_ind_columns
         , dual
     WHERE 1=1
     --AND index_name $where[0]
       AND table_name $where[1]
     --AND            $where[2]
     ORDER BY 1,2,3,4,column_position
         ;
};

# print $sql;
if( $where[0] =~ m/''/ || $where[1] =~ m/''/ ) {
    print "\nNo index found in file.\n";
    exit;
};

my @result = `sqlplus -s $CONN<<SQL
    $sql
SQL`;

foreach my $line (@result) {
    foreach my $obj (@obj) {
        $line =~ s/ ($obj) />> $1/x;
    }
    print $line ;
}

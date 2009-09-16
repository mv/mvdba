#!perl
# $Id: idsrc.pl 19713 2007-11-09 20:48:04Z marcus.ferreira $
#
# Marcus Vinicius Ferreira      ferreira.mv[  at  ]gmail.com  Jan/2007
#
# ident of database objects

die <<Thanatos unless (@ARGV);

    Usage: $0 <script.sql>

Thanatos

my (%obj, %typ);
my $CONN='apps/apps@hom';

foreach my $file (sort @ARGV) {
    next unless -T $file;
    printf "file: %-35s", $file;

    open my $fh, "<", $file or die "Cannot open $file: $!";
    my $code = do { local $/; <$fh> };
    close $fh;

    $code =~ /CREATE \s+
             (?:OR \s+ REPLACE)? \s+
             (PACKAGE|PROCEDURE|FUNCTION|VIEW|TRIGGER) \s+  # $1
             (BODY)? \s*                                    # $2
             (?:\w+[.])?    # schema
             (\w+)          # object                        # $3
             /xims ;
    my ($otype, $pkb, $oname) = map {uc $_} ($1, $2, $3);
    if( $oname ) { printf "db: %-35s", "[$oname]"; $obj{$oname}++; }
    if( $pkb )   { $otype = "$otype $pkb";  }
    if( $otype ) { print " type: [$otype]";        $typ{$otype}++; }
    print "\n";
}

my @where;
my @obj = map{ uc $_ } sort keys %obj;
my @typ = sort keys %typ;

if( scalar @obj > 1 ) { $where[0] = join "', '", @obj; $where[0] = "in ('". $where[0] . "')"; }
                 else { $where[0] = " = '$obj[0]' "; }
if( scalar @typ > 1 ) { $where[1] = join "', '", @typ; $where[1] = "in ('". $where[1] . "')"; }
                 else { $where[1] = " = '$typ[0]' "; }

$where[2] = q{ (text LIKE '%\\$Header%' OR text LIKE '%\\$Id%') };
my $sql = qq {
    set trimspool on
    set pagesize 0
    set linesize 1000
    set feedback off

    SELECT -- s.owner||'.'||RPAD(s.name,31,' ')||CHR(10)||LPAD(LOWER(s.type),15,' ')||' '||s.text as line
           -- s.owner||'.'||RPAD(s.name,31,' ')||CHR(10)||' '||s.text as line
           -- s.text||CHR(10)   as line
           s.text
      FROM all_source    s
         , all_objects   o
     WHERE name $where[0]
       AND type $where[1]
       AND      $where[2]
       AND s.name  = o.object_name
       AND s.type  = o.object_type
       AND s.owner = o.owner
     ORDER by 1
         ;
    SELECT object_name, object_type, status
      FROM all_objects
     WHERE object_name $where[0]
     ORDER by 1
         ;
};

$sql .= qq {
    set long 200
    column TEXT format a300

    SELECT text
      FROM all_views
     WHERE view_name $where[0]
         ;

} if $typ{'VIEW'};

# print $sql;

my @result=`sqlplus -s $CONN<<SQL
    $sql
SQL`;

print "\n\n";
foreach my $line (@result) {
    print $line if $line =~ /\$Header|\$Id/;
    print $line if $line =~ /valid/i;
}

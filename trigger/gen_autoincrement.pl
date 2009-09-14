#!perl
# $Id: gen_autoincrement.pl 14019 2007-04-21 19:18:19Z marcus.ferreira $
#
# Create sequence/trigger that implements an autoincrement field
#
# Marcus Vinicius Ferreira  Abr/2007        ferreira.mv[  at  ] gmail.com
#
#

use strict;

my @tab = qw/   adp_cli
                adp_file
                adp_gap
                adp_mail
                adp_mail_tmplt
                adp_obj
                adp_patch
                adp_patch_elements
                adp_prj
                adp_user /;

foreach my $t (@tab) {
    my $file = "${t}.trg.sql" ;
    my $seq  = "${t}_seq";
    print get_seq($seq);
    print get_text($t, $seq);
}

exit 0;

sub get_seq {
    my $seq = shift;
    return "\nCREATE SEQUENCE $seq ; \n\n";

}

sub get_text {
    my $tab = shift;
    my $seq = shift;
    return <<"EOF";
CREATE OR REPLACE TRIGGER ${tab}_id
                   BEFORE INSERT
                       ON $tab
                      FOR EACH ROW
DECLARE
    -- \$Id\$
    id NUMBER;
BEGIN
    IF :NEW.id IS NULL
    THEN
        SELECT ${seq}.NEXTVAL
          INTO id
          FROM DUAL;
        --
        :NEW.id := id;
    END IF;
    --
END ${tab}_id;
/

EOF
}


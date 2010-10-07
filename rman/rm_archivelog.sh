

rman <<RMAN
    connect target /

    allocate channel for maintenance type SBT_TAPE send 'NSR_ENV=(NSR_SERVER=marv.abrdigital.com.br, NSR_CLIENT=laranjalpta-vip.abrdigital.com.br)';

    DELETE NOPROMPT ARCHIVELOG ALL BACKED UP 1 TIMES TO SBT_TAPE ;
    CROSSCHECK BACKUP;
    LIST EXPIRED BACKUP;
    DELETE NOPROMPT EXPIRED BACKUP;

    EXIT

RMAN




FILE=live_stream_id_10.csv 
 SQL='select * from stream_entries where stream_id=10 ;'

HOST=127.0.0.1

mysql -u devteam -p -h $HOST bbs_production \
    -B -e $SQL > $FILE

perl -pi -e 's/^/"/ ; s/$/"/ ; s/\t/","/g ; '    $FILE


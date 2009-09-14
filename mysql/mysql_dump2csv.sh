
FILE=live_stream_id_10.csv 
 SQL='select * from stream_entries where stream_id=10 ;'

HOST=172.16.20.20
HOST=127.0.0.1

mysql -u devteam -pbbs -h $HOST bbs_prod_01 \
    -B -e $SQL > $FILE

perl -pi -e 's/^/"/ ; s/$/"/ ; s/\t/","/g ; '    $FILE


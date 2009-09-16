set linesize 200

select decode(state, 0, 'FREE'
                   , 1, decode( lrba_seq
                             , 0,'AVAILABLE'
                             , 'BEING USED')
                   , 3, 'BEING USED'
                   , state)           "BLOCK STATUS"
     , count(*)
  from x$bh
 group by decode(state, 0, 'FREE'
                      , 1, decode( lrba_seq
                                 , 0,'AVAILABLE'
                                 , 'BEING USED')
                      , 3, 'BEING USED'
                      , state)
/


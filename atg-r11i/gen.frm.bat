for %i in (h:\rhataya\*.fmb)
do

f45gen32 %i userid=prod/scteste2@orcl script=yes batch=yes window_state=Minimize
r25con32    userid=eduardolt/edu@issan STYPE=rdffile SOURCE=RCONV56A.RDF DTYPE=rexfile BATCH=yes logfile=LOGRDF.TXT


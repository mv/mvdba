
FILE='bbs-user_blog_owner_cparty_2009-04.csv'

HOST=10.2.112.94
DB=bbs_development
USER=devteam
PASS=

HOST=10.2.112.94
DB=bbs_production
USER=bbs
PASS=

SQL="
     SELECT DISTINCT u.id,u.firstname,u.lastname,u.email,u.login,u.created_at
       FROM users u
       LEFT JOIN blogs b    ON u.id = b.user_id
            JOIN profiles p ON u.id = p.user_id
      WHERE u.verified = 1  -- user ok
        AND u.deleted  = 0  -- nao deletado
        AND u.created_at BETWEEN '2009-01-19' AND '2009-01-25' -- criado no cparty
        AND b.status   = 0     -- blog ok
        AND b.verified > 10000 -- blog reclamado
        AND p.newsletter = 1   -- ok para receber emails
      ;"

if mysql -u $USER -p${PASS} -h $HOST $DB -B -e "$SQL"   > $FILE
then
    perl -pi -e 's/^/"/ ; s/$/"/ ; s/\t/","/g ; '    $FILE
fi



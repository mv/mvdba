CREATE OR REPLACE PROCEDURE send_mail   ( p_to          IN VARCHAR2
                                        , p_from        IN VARCHAR2
                                        , p_message     IN VARCHAR2
                                        ) AS
------------------------------------------------------------------------
-- $Id: send_mail.prc.sql 6 2006-09-10 15:35:16Z marcus $
--
-- Example: sending mail via PL/SQL
--
    --
    mailhost    VARCHAR2(15) := '10.228.1.75' ;
    conn        UTL_SMTP.CONNECTION ;           -- connection handle
BEGIN

    conn := UTL_SMTP.OPEN_CONNECTION( mailhost, 25 ) ;

    UTL_SMTP.HELO(conn, mailhost);
    UTL_SMTP.MAIL(conn, p_to    );
    UTL_SMTP.RCPT(conn, p_from  );

    UTL_SMTP.OPEN_DATA (conn) ;
    UTL_SMTP.WRITE_DATA(conn, p_message ) ;
    UTL_SMTP.CLOSE_DATA(conn) ;

    UTL_SMTP.QUIT(conn);

END send_mail;
/

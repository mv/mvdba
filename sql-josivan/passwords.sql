/*

 passwords

 sob o schema SYS rodar o script utlpwdmg.sql

 dentro deste script existe a funcao VERIFY_FUNCTION e nao permite que as novas passwords
 violem as seguintes regras:
 
 1-a password nao pode ser nula
 2-a password nao pode ser igual ao utilizador
 3-o comprimento da password nao pode ser inferior a 4 caracteres
 4-independentemente das maiusculas e minusculas a password nao pode ser uma das seguintes palavras: welcome, database,account,user, password,oracle,computer,ou abcd
 5-a password tem de conter pelo menos um caracter alfanumerico, um caracter numerico e um caracter de pontuacao ( ! " # $ & ( ) ´ ` * + , - / : ; < = > ? _ )
 6-a password nova tem de diferir da password antiga em pelo menos 3 caracteres


*/

pode ser criado um perfil para gestao de passwords 

create profile gesta_usuario limit
password_reuse_time  unlimited
password_reuse_max    5
password_life_time   90
failed_login_attempts 3
password_grace_time   5
password_lock_time    1
/


parametros
----------

password_reuse_time   - indica o numero de dias que eh necessario passar ate que uma password possa ser utilizada novamente
password_reuse_max    - indica o numero de vezes que uma password pode ser reutilizada
password_life_time    - numero de dias de validade da password
password_grace_time   - numero de dias de tolerancia apos expirar a password o usuario tem para alterar a password
failed_login_attempts - numero maximo de tentativas que um usuario dispoe para indicar a password
password_lock_time    - numero de dias que a password ficara bloqueada ate a password expirar
password_verify_function <nome_funcao> - funcao de consistencias das 6 regras acima 

.bloquear uma conta

  ALTER USER <nome_usuario> account lock;


.desbloquear uma conta

  ALTER USER <nome_usuario> account unlock;


.forca a password expirar

  ALTER USER <nome_usuario> password expire;

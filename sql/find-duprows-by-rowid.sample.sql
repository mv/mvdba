SELECT id_layout
     , id_contd
     , cod_contd
     , descr_contd
  FROM prd_conteudo_estrutura A
 WHERE ROWID > (SELECT MIN(ROWID)
                  FROM prd_conteudo_estrutura B
                 WHERE A.cod_contd = B.cod_contd
                   AND A.id_layout = B.id_layout
                )
ORDER BY 1,3;

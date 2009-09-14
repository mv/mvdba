clear
echo ""
echo ""
echo ""
echo ""
echo "          ----------------------------------------------"
echo "                  A Aplicacao DEV6 sera Eliminada!!!    "
echo "          ----------------------------------------------"
echo ""
echo ""
echo "  -------------------------------------------------------------"
echo "    Caso esteja arrependido da merda que acabou de dar inicio, "
echo "             voce tem 5 minutos para matar o PID \"`ps -fe    | \
                                                grep -i autocloneap | \
                                                tr -s " "           | \
                                                cut -d " " -f2      | \
                                                grep -v grep        | \
                                                head -n1`\"".
echo "  -------------------------------------------------------------"
echo ""
echo ""
echo ""

sleep 15

cd /u01/app/dev6
rm -rf /u01/app/dev/dev6* 

tar -xvzf /u02/backup/APPS/ebsdb/apps_ebsdbora_2007_04_04.tar
tar -xvzf /u02/backup/APPS/ebsdb/apps_ebsdbcomn_2007_04_04.tar
tar -xvzf /u02/backup/APPS/ebsdb/apps_ebsdbappl_2007_04_04.tar

mv u01/app/ebsdb/ebsdbora dev6ora
mv u01/app/ebsdb/ebsdbcomn dev6comn
mv u01/app/ebsdb/ebsdbappl dev6appl


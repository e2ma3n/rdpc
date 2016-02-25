#! /bin/bash
# Programming and idea by : E2MA3N [Iman Homayouni]
# Gitbub : https://github.com/e2ma3n
# Email : e2ma3n@Gmail.com
# Website : http://OSLearn.ir
# License : GPL v3.0
# rdpc v3.0 - core [RDP Management Console]
#--------------------------------------------------------#

# check root privilege
[ "`whoami`" != "root" ] && echo -e '[-] Please use root user or sudo' && exit 1


# data base location , Don not change this form
database_en="/opt/rdpc_v3/rdpc.database.en"


# print header on terminal
reset
echo '[+] ------------------------------------------------------------------- [+]'
echo -e "[+] Programming and idea by : \e[1mE2MA3N [Iman Homayouni]\e[0m"
echo '[+] License : GPL v3.0'
echo -e '[+] rdpc v3.0 \n'


# check encrypted database
if [ ! -f $database_en ] ; then
	echo -e "[-] Error: $database_en not found"
	echo '[+] ------------------------------------------------------------------- [+]'
	exit 1
fi


# decrypt database
echo -en "[+] Enter password: " ; read -s pass
database_de=`openssl aes-256-cbc -pass pass:$pass -d -a -in $database_en 2> /dev/null`
if [ "$?" != "0" ] ; then
	echo -e "\n[-] Error: Database can not encrypted."
	echo '[+] ------------------------------------------------------------------- [+]'
	exit 1
else
	echo
fi


# print servers informations on terminal
echo -e "\n 0) Edite Database"
var0=`echo "$database_de" | wc -l`
var0=`expr $var0 - 11`
for (( i=1 ; i <= $var0 ; i++ )) ; do
echo -ne " $i) " ; echo "$database_de" | tail -n $i | head -n 1 | cut -d " " -f 1,2 | tr " " @
done


# edite database
function edit_db {
	echo "$database_de" > /opt/rdpc_v3/sshc.database.de
	nano /opt/rdpc_v3/sshc.database.de
	echo -en "[+] encrypt new database, Please type your password: " ; read -s pass
	openssl aes-256-cbc -pass pass:$pass -a -salt -in /opt/rdpc_v3/sshc.database.de -out $database_en
	rm -f /opt/rdpc_v3/sshc.database.de &> /dev/null
	echo -e "\n[+] Done, New database saved and encrypted"
	echo '[+] ------------------------------------------------------------------- [+]'
	exit 0
}


# select server for continue
while :; do
echo -en '\e[0m\n[+] Select your server/option or type quit for exit: ' ; read var1

if [ "$var1" = "0" ] ; then
	edit_db
fi

if [ "$var1" -le "$var0" ] 2> /dev/null ; then
	break
elif [ "$var1" = "quit" ] ; then
	echo "[+] Bye Bye"
	echo '[+] ------------------------------------------------------------------- [+]'
	exit 1
else
	echo "[-] Error: bad input"
	echo '[+] ------------------------------------------------------------------- [+]'
	exit 1
fi
done


# status, checking up or down
ping -c 1 `echo "$database_de" | tail -n $var1 | head -n 1 | cut -d " " -f 2` &> /dev/null
if [ "$?" = "0" ] ; then
	echo -ne "\n You selected: \e[92m" ; echo "$database_de" | tail -n $var1 | head -n 1 | cut -d " " -f 2
else
	echo -ne "\n You selected: \e[91m" ; echo "$database_de" | tail -n $var1 | head -n 1 | cut -d " " -f 2
fi


# read data from database
username=`echo "$database_de" | tail -n $var1 | head -n 1 | cut -d " " -f 1`
ip=`echo "$database_de" | tail -n $var1 | head -n 1 | cut -d " " -f 2`
port=`echo "$database_de" | tail -n $var1 | head -n 1 | cut -d " " -f 3`
password=`echo "$database_de" | tail -n $var1 | head -n 1 | cut -d " " -f 4`

echo -e "\e[0m\n 0) 800x600"
echo -e " 1) 1024x768"
echo -e " 2) 1366x768"
echo -e " 3) Fullscreen\n"
echo -en "[+] Choice your resolution or type quit for exit: " ; read var2
echo '[+] ------------------------------------------------------------------- [+]'


# Connection to server
case $var2 in
	quit) exit 1 ;;
	0) rdesktop -g 800x600 $ip:$port -u "$username" -p "$password" &> /dev/null & ;;
	1) rdesktop -g 1024x768 $ip:$port -u "$username" -p "$password" &> /dev/null & ;;
	2) rdesktop -g 1366x768 $ip:$port -u "$username" -p "$password" &> /dev/null & ;;
	3) rdesktop $ip:$port -u "$username" -p "$password" -f &> /dev/null & ;;
	*) echo "[+] Bad input" ; exit 1 ;;
esac

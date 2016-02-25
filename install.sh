#! /bin/bash
# Programming and idea by : E2MA3N [Iman Homayouni]
# Gitbub : https://github.com/e2ma3n
# Email : e2ma3n@Gmail.com
# Website : http://OSLearn.ir
# License : GPL v3.0
# rdpc v3.0 - installer [RDP Management Console]
# -------------------------------------------------------- #

# check root privilege
[ "`whoami`" != "root" ] && echo -e '[-] Please use root user or sudo' && exit 1


# help function
function help_f {
	echo "Usage: "
	echo "	sudo ./install.sh -i [install program]"
	echo "	sudo ./install.sh -u [help to uninstall program]"
	echo "	sudo ./install.sh -c [check dependencies]"
}


# install program on system
function install_f {
	[ ! -d /opt/rdpc_v3/ ] && mkdir -p /opt/rdpc_v3/ && echo "[+] Directory created" || echo "[-] Error: /opt/rdpc_v3/ exist"
	sleep 1
	[ ! -f /opt/rdpc_v3/rdpc.sh ] && cp rdpc.sh /opt/rdpc_v3/ && chmod 755 /opt/rdpc_v3/rdpc.sh && echo "[+] rdpc.sh copied" || echo "[-] Error: /opt/rdpc_v3/rdpc.sh exist"
	sleep 1
	[ ! -f /opt/rdpc_v3/rdpc.database.en ] && cp rdpc.database.en /opt/rdpc_v3/rdpc.database.en && chown root:root /opt/rdpc_v3/rdpc.database.en && chmod 700 /opt/rdpc_v3/rdpc.database.en && echo "[+] rdpc.database.en copied" || echo "[-] Error: /opt/rdpc_v3/rdpc.database.en exist"
	sleep 1
	[ -f /opt/rdpc_v3/rdpc.sh ] && ln -s /opt/rdpc_v3/rdpc.sh /usr/bin/rdpc && echo "[+] symbolic link created" || echo "[-] Error: symbolic link not created"
	sleep 1
	[ ! -f /opt/rdpc_v3/README ] && cp README /opt/rdpc_v3/README && chmod 644 /opt/rdpc_v3/README && echo "[+] README copied" || echo "[-] Error: /opt/rdpc_v3/README exist"
	sleep 1

	echo "[+] Please see README" ; sleep 0.5
	echo "[!] Warning: run program and edit your database." ; sleep 0.5
	echo "[!] Warning: defaul password is 'rdpc'" ; sleep 0.5
	echo "[!] Warning: change default password" ; sleep 0.5
	echo "[+] Done"
}


# uninstall program from system
function uninstall_f {
	echo "For uninstall program:"
	echo "	sudo rm -rf /opt/rdpc_v3"
	echo "	sudo rm -f /usr/bin/rdpc"
}


# check dependencies on system
function check_f {
	echo "[+] check dependencies on system:  "
	for program in rdesktop ping mkdir cp rm whoami ping ssh cat nano
	do
		sleep 0.5
		if [ ! -z `which $program 2> /dev/null` ] ; then
			echo -e "[+] $program found"
		else
			echo -e "[-] Error: $program not found"
		fi
	done
}


case $1 in
	-i) install_f ;;
	-u) uninstall_f ;;
	-c) check_f ;;
	*) help_f ;;
esac

#!/bin/bash
#
#
# hacksaw v1.2
# Kevin Gilstrap, bully
# https://www.linkedin.com/in/kevingilstrap
# November 5, 2015
#
# Uses a variety of open-source tools to automate initial testing on Internal and External Penetration Tests:
# 1.  Identifies open ports and services in a staged format for quicker results
# 2.  Enumerates services and identifies known exploitable vulnerabilities
# 3.  Identifies misconfigurations and known vulnerable components in web applications
# 4.  Takes screen shots of all scanned websites
# 5.  Conducts password auditing on common services for default, null, or easily guessable 
#     passwords
# 6.  Exports all nmap and metasploit outputs to an engagement directory in txt, xml, and html formats
# 7.  Creates a metasploit workspace, imports results, and exports the workspace 
#     and creds to the engagement directory.
# 8.  All outputs are parsed and returned to a master text document and html file for easy viewing.
#	
#
# Usage:
# ------
# $ sudo ./hacksaw.sh
#
#
# Dependencies:
# -------------
# firefox
# nmap
# metasploit
# xsltproc
# arp-scan
# nbtscan
# nikto (Must be globally declared. ex: sudo nikto -h)
# yasuo (Must be located in /opt/yasuo directory)
# rawr (Must be located in /opt/rawr/ directory)
# responder (Must be located in /opt/responder directory)
#
#
clear
echo "$(tput setaf 7)"
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 3)++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "$(tput setaf 1)*  $(tput setaf 7)README located: /opt/hacksaw/README"
echo "$(tput setaf 1)*  $(tput setaf 7)Maximize window for best results"
echo "$(tput setaf 3)++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "$(tput setaf 7)'Q' to exit"
echo ""
echo ""
echo "$(tput setaf 2)Engagement name (no spaces):"
echo -n "$(tput setaf 7)hacksaw>  "
read engagementname
if [ $engagementname = "Q" ]; then
exit
fi
if [ -d "generated/$engagementname" ]; then
cd "generated/$engagementname/"
else
mkdir "generated/$engagementname"
cd "generated/$engagementname/"
fi
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 2)++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
##echo "$(tput setaf 7)($(tput setaf 3)W$(tput setaf 7))eb Application Assessment" 
echo "$(tput setaf 7)($(tput setaf 3)I$(tput setaf 7))nternal Penetration Test" 
echo "($(tput setaf 3)E$(tput setaf 7))xternal Penetration Test"
echo "($(tput setaf 3)Q$(tput setaf 7))uit"
echo "$(tput setaf 2)++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Make selection:"
echo -n "$(tput setaf 7)hacksaw/$engagementname>  "
read engagementtype
if [ $engagementtype = "Q" ]; then
exit
fi
if [ $engagementtype = "I" ]; then
unset $date
date=$(date +%m-%d-%y_%H:%M:%S)
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 2)Enter the network CIDR (ex: 192.168.1.0/24): "
echo -n "$(tput setaf 7)hacksaw/$engagementname/IPT>  "
read networkrange

clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 2)Enter the domain name (ex: LAB.LOCAL): "
echo -n "$(tput setaf 7)hacksaw/$engagementname/IPT>  "
read domain
service postgresql start

clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Conducting ARP Scan..."
echo ""
echo "$(tput setaf 3)"
arp-scan $networkrange >> IPT-$engagementname-arpscan-$date.out
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Conducting NBT Scan..."
echo ""
echo "$(tput setaf 3)"
nbtscan $networkrange >> IPT-$engagementname-nbtscan-$date.out
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Printing DNS servers from DHCP..."
echo ""
echo "$(tput setaf 3)"
cat /etc/resolv.conf >> IPT-$engagementname-resolv_conf-$date.out
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Performing broadcast discovery..."
echo ""
echo "$(tput setaf 3)"
nmap --script broadcast-listener --script broadcast-dhcp-discover --script broadcast-dns-service-discovery --script broadcast-netbios-master-browser --script broadcast-wpad-discover --script broadcast-ping -oX IPT-$engagementname-nmap-broadcast.xml -oN IPT-$engagementname-nmap-broadcast.txt
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Finding Domain Controllers..."
echo ""
echo "$(tput setaf 3)"
nslookup -type=srv _ldap._tcp.dc._msdcs.$domain >> IPT-$engagementname-domain-controllers-$date.out
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Creating a host list..."
echo ""
echo "$(tput setaf 3)"
nmap -sn -PS -n $networkrange | grep 'Nmap scan' >> IPT-$engagementname-host.temp
cat  IPT-$engagementname-host.temp | awk '{print $5}' >> IPT-$engagementname-host.list
rm -f IPT-$engagementname-host.temp
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Identifying low hanging fruit...SMB..."
echo ""
echo "$(tput setaf 3)"
nmap -v -sT -sU -Pn -n -T5 -p 445,137 --open --script smb-check-vulns --script-args=unsafe=1 --script smb-mbenum --script smb-enum-shares --script smb-enum-domains --script smb-enum-groups  --script smb-brute -iL IPT-$engagementname-host.list -oX IPT-$engagementname-nmap-LowHangingFruit-445-SMB.xml -oN IPT-$engagementname-nmap-LowHangingFruit-445-SMB.txt
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Importing results into metasploit workspace and running modules"
echo ""
echo "$(tput setaf 3)"
msfconsole -o IPT-$engagementname-msfconsole-WindowsGuestAccountAccess-$date.txt -x "workspace -a $engagementname;db_import IPT-$engagementname-nmap-LowHangingFruit-445-SMB.xml;use auxiliary/scanner/smb/smb_lookupsid;services -u -p 445 -R;set SMBUser Guest;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Identifying low hanging fruit...DNS..."
echo ""
echo "$(tput setaf 3)"
nmap -v -sT -sU -Pn -n -T5 -p 53 --open --script dns-srv-enum --script dns-brute --script dns-random-txid --script dns-update -iL IPT-$engagementname-host.list -oX IPT-$engagementname-nmap-LowHangingFruit-53-dns.xml -oN IPT-$engagementname-nmap-LowHangingFruit-53-DNS.txt
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Importing results into metasploit workspace and running modules"
echo ""
echo "$(tput setaf 3)"
msfconsole -x "workspace $engagementname;db_import IPT-$engagementname-nmap-LowHangingFruit-53-dns.xml;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Identifying low hanging fruit...FTP..."
echo ""
echo "$(tput setaf 3)"
nmap -v -sT -Pn -n -T5 -p 21 --open --script ftp-proftpd-backdoor --script ftp-vsftpd-backdoor --script ftp-vuln-cve2010-4221 --script ftp-libopie --script ftp-anon --script ftp-brute -iL IPT-$engagementname-host.list -oX IPT-$engagementname-nmap-LowHangingFruit-21-FTP.xml -oN IPT-$engagementname-nmap-LowHangingFruit-21-FTP.txt
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Importing results into metasploit workspace and running modules"
echo ""
echo "$(tput setaf 3)"
msfconsole -o IPT-$engagementname-msfconsole-FTP_anonymous-$date.txt -x "workspace $engagementname;db_import IPT-$engagementname-nmap-LowHangingFruit-21-FTP.xml;use auxiliary/scanner/ftp/anonymous;services -u -p 21 -R;set THREADS 10;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Identifying low hanging fruit...MySQL..."
echo ""
echo "$(tput setaf 3)"
nmap -v -sT -Pn -n -T5 -p 3306 --open --script mysql-empty-password --script mysql-brute --script mysql-databases --script mysql-enum --script mysql-users --script mysql-vuln-cve2012-2122 -iL IPT-$engagementname-host.list -oX IPT-$engagementname-nmap-LowHangingFruit-3306-MySQL.xml -oN IPT-$engagementname-nmap-LowHangingFruit-3306-MySQL.txt
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Importing results into metasploit workspace and running modules"
echo ""
echo "$(tput setaf 3)"
msfconsole -o IPT-$engagementname-msfconsole-MYSQL-$date.txt -x "workspace $engagementname;db_import IPT-$engagementname-nmap-LowHangingFruit-3306-MySQL.xml;use auxiliary/scanner/mysql/mysql_version;services -u -p 3306 -R;run;exit -y"
msfconsole -o IPT-$engagementname-msfconsole-MYSQL-$date.txt -x "workspace $engagementname;use auxiliary/scanner/mysql/mysql_authbypass_hashdump;services -u -p 3306 -R;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Identifying low hanging fruit...MSSQL..."
echo ""
echo "$(tput setaf 3)"
nmap -v -sT -Pn -n -T5 -p 1433 --open --script broadcast-ms-sql-discover --script ms-sql-empty-password --script ms-sql-brute ms-sql-xp-cmdshell -iL IPT-$engagementname-host.list -oX IPT-$engagementname-nmap-LowHangingFruit-1433-MSSQL.xml -oN IPT-$engagementname-nmap-LowHangingFruit-1433-MSSQL.txt
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Importing results into metasploit workspace and running modules"
echo ""
echo "$(tput setaf 3)"
msfconsole -o IPT-$engagementname-msfconsole-MSSQL-$date.txt -x "workspace $engagementname;db_import IPT-$engagementname-nmap-LowHangingFruit-1433-MSSQL.xml;use auxiliary/scanner/mssql/mssql_ping;set RHOSTS $networkrange;set THREADS 5;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Identifying low hanging fruit...VNC..."
echo ""
echo "$(tput setaf 3)"
nmap -v -sT -Pn -n -T5 -p 5900 --open --script realvnc-auth-bypass --script vnc-brute --script vnc-info -iL IPT-$engagementname-host.list -oX IPT-$engagementname-nmap-LowHangingFruit-5900-VNC.xml -oN IPT-$engagementname-nmap-LowHangingFruit-5900-VNC.txt
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Importing results into metasploit workspace and running modules"
echo ""
echo "$(tput setaf 3)"
msfconsole -o IPT-$engagementname-msfconsole-VNC_no_auth-$date.txt -x "workspace $engagementname;db_import IPT-$engagementname-nmap-LowHangingFruit-5900-VNC.xml;use auxiliary/scanner/vnc/vnc_none_auth;services -u -p 5900 -R;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Identifying low hanging fruit...SMTP..."
echo ""
echo "$(tput setaf 3)"
nmap -v -sT -Pn -n -T5 -p 25,2525 --open --script smtp-open-relay --script smtp-enum-users --script smtp-brute -iL IPT-$engagementname-host.list -oX IPT-$engagementname-nmap-LowHangingFruit-25-SMTP.xml -oN IPT-$engagementname-nmap-LowHangingFruit-25-SMTP.txt
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Importing results into metasploit workspace and running modules"
echo ""
echo "$(tput setaf 3)"
msfconsole -o IPT-$engagementname-msfconsole-SMTP_open_relay-$date.txt -x "workspace $engagementname;db_import IPT-$engagementname-nmap-LowHangingFruit-25-SMTP.xml;use auxiliary/scanner/smtp/smtp_relay;services -p 25,2525 -u -R;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Identifying low hanging fruit...X11..."
echo ""
echo "$(tput setaf 3)"
nmap -v -sT -Pn -n -T5 -p 6000 --open --script x11-access -iL IPT-$engagementname-host.list -oX IPT-$engagementname-nmap-LowHangingFruit-6000-X11.xml -oN IPT-$engagementname-nmap-LowHangingFruit-6000-X11.txt
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Importing results into metasploit workspace and running modules"
echo ""
echo "$(tput setaf 3)"
msfconsole -o IPT-$engagementname-msfconsole-X11_open_access-$date.txt -x "workspace $engagementname;db_import IPT-$engagementname-nmap-LowHangingFruit-6000-X11.xml;use auxiliary/scanner/x11/open_x11;services -p 6000 -R;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Identifying web servers and places to logon..."
echo ""
echo "$(tput setaf 3)"
nmap -v -sT -sV -Pn -n -T5 -p 80,8080,8081,443,8443,8843 --open --script http-auth-finder --script-args=http-auth-finder.maxdepth=-1 --script http-brute --script http-form-brute --script http-proxy-brute --script http-wordpress-brute --script http-vuln-cve2009-3960 --script http-vuln-cve2010-0738 --script http-vuln-cve2010-2861 --script http-vuln-cve2011-3192 --script http-vuln-cve2011-3368 --script http-vuln-cve2012-1823 --script http-vuln-cve2013-0156 --script http-iis-webdav-vuln --script http-shellshock -iL IPT-$engagementname-host.list -oX IPT-$engagementname-nmap-WebServers-HTTP-HTTPS.xml -oN IPT-$engagementname-nmap-WebServers-HTTP-HTTPS.txt
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Importing results into metasploit workspace and running modules"
echo ""
echo "$(tput setaf 3)"
msfconsole -x "workspace $engagementname;db_import IPT-$engagementname-nmap-WebServers-HTTP-HTTPS.xml;exit"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Searching for vulnerable components in web apps..."
echo ""
echo "$(tput setaf 3)"
cd /opt/yasuo
./yasuo.rb -f /opt/hacksaw/generated/$engagementname/IPT-$engagementname-nmap-WebServers-HTTP-HTTPS.xml >> /opt/hacksaw/generated/$engagementname/IPT-$engagementname-WebServers-VulnerableComponents.txt
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Taking screen shots of identified sites..."
echo ""
echo "$(tput setaf 3)"
cd /opt/rawr/
./rawr.py -d /opt/hacksaw/generated/$engagementname/ -f /opt/hacksaw/generated/$engagementname/IPT-$engagementname-nmap-WebServers-HTTP-HTTPS.xml
cd /opt/hacksaw/generated/$engagementname/
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Looking for misconfigurations in web apps..."
echo ""
echo "$(tput setaf 3)"
nikto -h IPT-$engagementname-host.list -Display V -F htm -output IPT-$engagementname-nikto-80-config_issues.html
nikto -p 443 -ssl -h IPT-$engagementname-host.list -Display V -F htm -output IPT-$engagementname-nikto-443-config_issues.html
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Identifying additional places to logon..."
echo ""
echo "$(tput setaf 3)"
cd /opt/hacksaw/generated/$engagementname/
nmap -v -Pn -sT -n -T5 -p 22,23,587,69,123,135,137-139,512-514,990,1521,3389,5432-5433,12345,27017,49152,U:69,U:161,U:500 --open --script ike-version --script telnet-brute --script oracle-brute --script oracle-enum-users --script pgsql-brute --script rexec-brute --script rlogin-brute --script snmp-brute --script mongodb-brute --script netbus-brute --script netbus-auth-bypass --script msrpc-enum -iL IPT-$engagementname-host.list -oX IPT-$engagementname-nmap-PlacestoLogon.xml -oN IPT-$engagementname-nmap-PlacestoLogon.txt
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Importing results into metasploit workspace and running modules"
echo ""
echo "$(tput setaf 3)"
msfconsole -x "workspace $engagementname;db_import IPT-$engagementname-nmap-PlacestoLogon.xml;exit"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Looking for available DCERPC services over TCP..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o IPT-$engagementname-msfconsole-tcp_dcerpc_auditor-$date.txt -x "workspace $engagementname;use auxiliary/scanner/dcerpc/tcp_dcerpc_auditor;services -u -p 135 -R;set THREADS 5;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Looking for jboss vulnerabilities..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o IPT-$engagementname-msfconsole-jboss_vulnscan-$date.txt -x "workspace $engagementname;use auxiliary/scanner/http/jboss_vulnscan;set RHOSTS $networkrange;set THREADS 5;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Looking for default credentials...VNC..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o IPT-$engagementname-msfconsole-vnc_defaults_creds-$date.txt -x "workspace $engagementname;use auxiliary/scanner/vnc/vnc_login;services -p 5900 -R;set PASS_FILE /opt/hacksaw/wordlists/vnc_passwords.txt;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Looking for default credentials...Tomcat Manager..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o IPT-$engagementname-msfconsole-tomcat_mgr_defauls_creds-$date.txt -x "workspace $engagementname;use auxiliary/scanner/http/tomcat_mgr_login;services -p 8080 -R;set USERPASS_FILE /opt/hacksaw/wordlists/tomcat_mgr_default_userpass.txt;run;services -p 8081 -R;set RPORT 8081;run;services -p 80 -R;set RPORT 80;run;services -p 443 -R;set RPORT 443;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Looking for default credentials...Telnet..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o IPT-$engagementname-msfconsole-telnet_default_creds-$date.txt -x "workspace $engagementname;use auxiliary/scanner/telnet/telnet_login;services -p 23 -R;set BLANK_PASSWORDS true;set STOP_ON_SUCCESS true;set VERBOSE true;set USER_AS_PASS true;set DB_ALL_CREDS true;set DB_ALL_PASS true;set DB_ALL_USERS true;set USERPASS_FILE /opt/hacksaw/wordlists/root_userpass.txt;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Looking for default credentials...SSH..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o IPT-$engagementname-msfconsole-ssh_default_creds-$date.txt -x "workspace $engagementname;use auxiliary/scanner/ssh/ssh_login;services -p 22 -R;set BLANK_PASSWORDS true;set STOP_ON_SUCCESS true;set VERBOSE true;set USER_AS_PASS true;set DB_ALL_CREDS true; set DB_ALL_PASS true; set DB_ALL_USERS true;set BRUTEFORCE_SPEED 5;set USERPASS_FILE /opt/hacksaw/wordlists/root_userpass.txt;run;set USERPASS_FILE /opt/hacksaw/wordlists/default_userpass_for_services_unhash.txt;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Looking for default credentials...RSH..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o IPT-$engagementname-msfconsole-rsh_login-$date.txt -x "workspace $engagementname;use auxiliary/scanner/rservices/rsh_login;services -p 514 -u -R;set BLANK_PASSWORDS true;set DB_ALL_CREDS true;set SDB_ALL_PASS true;set DB_ALL_USERS true;set VERBOSE true;set THREADS 10;set PASS_FILE /opt/hacksaw/wordlists/unix_passwords.txt;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Looking for default credentials...Rexec..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o IPT-$engagementname-msfconsole-rexec_login-$date.txt -x "workspace $engagementname;use auxiliary/scanner/rservices/rexec_login;services -p 512 -u -R;set BLANK_PASSWORDS true;set DB_ALL_CREDS true;set SDB_ALL_PASS true;set DB_ALL_USERS true;set VERBOSE true;set THREADS 10;set USERASS_FILE /opt/hacksaw/wordlists/root_userpass.txt;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Looking for default credentials...Rlogin..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o IPT-$engagementname-msfconsole-rlogin_login-$date.txt -x "workspace $engagementname;use auxiliary/scanner/rservices/rlogin_login;services -p 513 -u -R;set BLANK_PASSWORDS true;set DB_ALL_CREDS true;set SDB_ALL_PASS true;set DB_ALL_USERS true;set VERBOSE true;set THREADS 10;set PASS_FILE /opt/hacksaw/wordlists/unix_passwords.txt;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Looking for default credentials...MSSQL..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o IPT-$engagementname-msfconsole-mssql_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/mssql/mssql_login;services -p 1433 -u -R;set PASS_FILE /opt/hacksaw/wordlists/common.txt;set STOP_ON_SUCCESS true;set VERBOSE true;set BLANK_PASSWORDS true;set DB_ALL_CREDS true; set DB_ALL_PASS true;set DB_ALL_USERS true;run;exit -y"
msfconsole -o IPT-$engagementname-msfconsole-mssql_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/mssql/mssql_hashdump;services -u -p 1433 -R;run;exit -y"
msfconsole -o IPT-$engagementname-msfconsole-mssql_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/mssql/mssql_schemadump;services -u -p 1433 -R;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Looking for default credentials...MySQL..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o IPT-$engagementname-msfconsole-mysql_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/mysql/mysql_login;services -p 3306 -u -R;set USERPASS_FILE /opt/hacksaw/wordlists/root_userpass.txt;set STOP_ON_SUCCESS true;set VERBOSE true;set BLANK_PASSWORDS true;set DB_ALL_CREDS true; set DB_ALL_PASS true;set DB_ALL_USERS true;run;exit -y"
msfconsole -o IPT-$engagementname-msfconsole-mysql_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/mysql/mysql_hashdump;services -u -p 3306 -R;run;exit -y"
msfconsole -o IPT-$engagementname-msfconsole-mysql_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/mysql/mysql_schemadump;services -u -p 3306 -R;run; exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Looking for default credentials...PostgreSQL..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o IPT-$engagementname-msfconsole-postgresql_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/postgres/postgres_login;services -p 5432 -u -R;set USERPASS_FILE /opt/hacksaw/wordlists/postgres_default_userpass.txt;set STOP_ON_SUCCESS true;set VERBOSE true;set BLANK_PASSWORDS true;set DB_ALL_CREDS true; set DB_ALL_PASS true;set DB_ALL_USERS true;run;exit -y"
msfconsole -o IPT-$engagementname-msfconsole-postgresql_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/postgres/postgres_hashdump;services -u -p 5432 -R;run;exit -y"
msfconsole -o IPT-$engagementname-msfconsole-postgresql_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/postgres/postgres_schemadump;services -u -p 5432 -R;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Looking for default credentials...Oracle..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o IPT-$engagementname-msfconsole-oracle_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/oracle/oracle_login;services -u -p 1521 -R;set RPORTS 1521;set STOP_ON_SUCCESS true;set DB_ALL_CREDS true;set DB_ALL_PASS true;set DB_ALL_USERS true;set BLANK_PASSWORDS true;run;exit -y"
msfconsole -o IPT-$engagementname-msfconsole-oracle_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/oracle/sid_brute;services -u -p 1521 -R;set DB_ALL_CREDS true;set DB_ALL_PASS true;set DB_ALL_USERS true;run;exit -y"
msfconsole -o IPT-$engagementname-msfconsole-oracle_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/oracle/oracle_hashdump;services -u -p 1521 -R;run;exit -y"
msfconsole -o IPT-$engagementname-msfconsole-oracle_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/oracle/tnspoison_checker;services -u -p 1521 -R;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Looking for default credentials...SNMP..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o IPT-$engagementname-msfconsole-snmp_brute-$date.txt -x "workspace $engagementname;db_import IPT-$engagementname-udpscan-$date.xml;use auxiliary/scanner/snmp/snmp_login;services -p 161 -u -R;set PASS_FILE /opt/hacksaw/wordlists/snmp_default_pass.txt;set VERBOSE true;set VERSION all;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Looking for default credentials...TFTP..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o IPT-$engagementname-msfconsole-tftp_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/tftp/tftpbrute;services -p 69 -u -R;set DICTIONARY /opt/hacksaw/wordlists/tftp.txt;set THREADS 10;run;exit -y"
clear
echo "$(tput setaf 7)"
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 2)Would you like to capture hashes with Responder? (Cntrl+C to stop...be patient when stopping) y/n"
echo -n "$(tput setaf 7)hacksaw/$engagementname/IPT>  "
read responder
if [ $responder = "n" ]; then
echo "Skipping capturing hashes..."
else
sed -i -e "s/.*SessionLog =.*/SessionLog = $engagementname-Responder-Session.log/" /opt/responder/Responder.conf
sed -i -e "s/.*PoisonersLog =.*/PoisonersLog = $engagementname-Poisoners-Session.log/" /opt/responder/Responder.conf
sed -i -e "s/.*AnalyzeLog =.*/AnalyzeLog = $engagementname-Analyzer-Session.log/" /opt/responder/Responder.conf
service nmbd stop
service smbd stop
cd /opt/responder/
./Responder.py -I eth0 -wFf
cp /opt/responder/logs/$engagementname-*.log /opt/hacksaw/generated/$engagementname/
rm -rf /opt/responder/logs/$engagementname-*.log
sed -i -e "s/.*SessionLog =.*/SessionLog = Responder-Session.log/" /opt/responder/Responder.conf
sed -i -e "s/.*PoisonersLog =.*/PoisonersLog = Poisoners-Session.log/" /opt/responder/Responder.conf
sed -i -e "s/.*AnalyzeLog =.*/AnalyzeLog = Analyzer-Session.log/" /opt/responder/Responder.conf
cd /opt/hacksaw/generated/$engagementname/
fi
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Parsing results..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o IPT-$engagementname-services.txt -x "workspace $engagementname;services -u;exit"
msfconsole -o IPT-$engagementname-hosts.txt -x "workspace $engagementname;hosts -u;exit"
msfconsole -o IPT-$engagementname-loot.txt -x "workspace $engagementname;loot;exit"
msfconsole -o IPT-$engagementname-creds.txt -x "workspace $engagementname;creds;exit"
msfconsole -x "workspace $engagementname;db_export -f xml /opt/hacksaw/generated/$engagementname/IPT-$engagementname-msfconsole-DB_EXPORT.xml;exit"
xsltproc IPT-$engagementname-nmap-broadcast.xml -o IPT-$engagementname-nmap-broadcast.html
xsltproc IPT-$engagementname-nmap-LowHangingFruit-445-SMB.xml -o IPT-$engagementname-nmap-LowHangingFruit-445-SMB.html
xsltproc IPT-$engagementname-nmap-LowHangingFruit-53-dns.xml -o IPT-$engagementname-nmap-LowHangingFruit-53-dns.html
xsltproc IPT-$engagementname-nmap-LowHangingFruit-21-FTP.xml -o IPT-$engagementname-nmap-LowHangingFruit-21-FTP.html
xsltproc IPT-$engagementname-nmap-LowHangingFruit-3306-MySQL.xml -o IPT-$engagementname-nmap-LowHangingFruit-3306-MySQL.html
xsltproc IPT-$engagementname-nmap-LowHangingFruit-1433-MSSQL.xml -o IPT-$engagementname-nmap-LowHangingFruit-1433-MSSQL.html
xsltproc IPT-$engagementname-nmap-LowHangingFruit-5900-VNC.xml -o IPT-$engagementname-nmap-LowHangingFruit-5900-VNC.html
xsltproc IPT-$engagementname-nmap-LowHangingFruit-25-SMTP.xml -o IPT-$engagementname-nmap-LowHangingFruit-25-SMTP.html
xsltproc IPT-$engagementname-nmap-LowHangingFruit-6000-X11.xml -o IPT-$engagementname-nmap-LowHangingFruit-6000-X11.html
xsltproc IPT-$engagementname-nmap-WebServers-HTTP-HTTPS.xml -o IPT-$engagementname-nmap-WebServers-HTTP-HTTPS.html
xsltproc IPT-$engagementname-nmap-PlacestoLogon.xml -o IPT-$engagementname-nmap-PlacestoLogon.html
clear
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "          _____________________________________" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "         /  __   ____________________________  |" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "        /  /  | |                            | |" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "       /  /   | |                            | |" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "      /  /____j |____________________________| |" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "     (________(o)vvvvvvvvvvvvvvvvvvvvvvvvvvvv(o)" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "      by bully                      hacksaw v1.2" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                               OPEN SERVICES" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
grep -A5000 -m1 -e 'host' /opt/hacksaw/generated/$engagementname/IPT-$engagementname-services.txt >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                                   HOSTS" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
grep -A5000 -m1 -e 'Hosts' /opt/hacksaw/generated/$engagementname/IPT-$engagementname-hosts.txt >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
cat /opt/hacksaw/generated/$engagementname/IPT-$engagementname-arpscan-$date.out >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
cat /opt/hacksaw/generated/$engagementname/IPT-$engagementname-nbtscan-$date.out >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                       DNS SERVERS CONFIGURED VIA DHCP" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
cat /opt/hacksaw/generated/$engagementname/IPT-$engagementname-resolv_conf-$date.out | grep 'nameserver' >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                             DOMAIN CONTROLLERS" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
cat  IPT-$engagementname-domain-controllers-$date.out >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                             VULNERABLE WEB APPS" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
grep -A5000 -m1 -e '<<<Yasuo discovered following vulnerable applications>>>'  /opt/hacksaw/generated/$engagementname/IPT-$engagementname-WebServers-VulnerableComponents.txt >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                              METASPLOIT CREDS" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
grep -A5000 -m1 -e 'host' /opt/hacksaw/generated/$engagementname/IPT-$engagementname-creds.txt >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                              METASPLOIT LOOT" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
grep -A5000 -m1 -e 'host' /opt/hacksaw/generated/$engagementname/IPT-$engagementname-loot.txt >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                                NMAP CREDS" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
grep 'Valid' /opt/hacksaw/generated/$engagementname/IPT-$engagementname-nmap-*.txt >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
grep 'empty password' /opt/hacksaw/generated/$engagementname/IPT-$engagementname-nmap-*.txt >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
grep 'login allowed' /opt/hacksaw/generated/$engagementname/IPT-$engagementname-nmap-*.txt >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                   AVAILABLE DCERPC SERVICES OVER TCP " >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
grep 'ACCESS GRANTED' /opt/hacksaw/generated/$engagementname/IPT-$engagementname-msfconsole-tcp_dcerpc_auditor-$date.txt >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                          OUTPUT DIRECTORY/FILES" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                   Directory: /opt/hacksaw/generated/$engagementname/" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                               Hacksaw Summary:  hacksaw-$engagementname-summary.txt" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                        Metasploit Exported DBs:  IPT-$engagementname-msfconsole-DB_EXPORT.xml" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                                  IPT-$engagementname-msfconsole-DB_EXPORT.pwdump" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                 Responder Logs:  $engagementname-Responder-Session.log" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                                  $engagementname-Analyzer-Session.log" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                                  $engagementname-Poisoners-Session.log" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
ls >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "All scans and modules completed successfully.  Check all tabs for complete results." >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
cd /opt/hacksaw/
./txt2html.sh < /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt > /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.html
cd /opt/hacksaw/generated/$engagementname/
firefox -new-tab -url /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.html -new-tab -url /opt/hacksaw/generated/$engagementname/log_*/index_*.html -new-tab -url /opt/hacksaw/generated/$engagementname/IPT-$engagementname-nikto-80-config_issues.html -new-tab -url /opt/hacksaw/generated/$engagementname/IPT-$engagementname-nikto-443-config_issues.html -new-tab -url /opt/hacksaw/generated/$engagementname/IPT-$engagementname-nmap-*.html
exit
fi
if [ $engagementtype = "E" ]; then
unset $date
date=$(date +%m-%d-%y_%H:%M:%S)
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 2)Enter the path to the host file (ex: /opt/hacksaw/host.list):"
echo -n "$(tput setaf 7)hacksaw/$engagementname/EPT>  "
read networkrange
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Identifying low hanging fruit...SMB..."
echo ""
echo "$(tput setaf 3)"
nmap -v -sT -sU -Pn -T5 -p 445,137 --open --script smb-check-vulns --script-args=unsafe=1 --script smb-mbenum --script smb-enum-shares --script smb-enum-domains --script smb-enum-groups  --script smb-brute -iL $networkrange -oX EPT-$engagementname-nmap-LowHangingFruit-445-SMB.xml -oN EPT-$engagementname-nmap-LowHangingFruit-445-SMB.txt
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Importing results into metasploit workspace and running modules"
echo ""
echo "$(tput setaf 3)"
msfconsole -o EPT-$engagementname-msfconsole-WindowsGuestAccountAccess-$date.txt -x "workspace -a $engagementname;db_import EPT-$engagementname-nmap-LowHangingFruit-445-SMB.xml;use auxiliary/scanner/smb/smb_lookupsid;services -u -p 445 -R;set SMBUser Guest;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Identifying low hanging fruit...DNS..."
echo ""
echo "$(tput setaf 3)"
nmap -v -sT -sU -Pn -T5 -p 53 --open --script dns-update --script dns-srv-enum --script dns-brute --script dns-random-txid -iL $networkrange -oX EPT-$engagementname-nmap-LowHangingFruit-53-dns.xml -oN EPT-$engagementname-nmap-LowHangingFruit-53-DNS.txt
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Importing results into metasploit workspace and running modules"
echo ""
echo "$(tput setaf 3)"
msfconsole -x "workspace $engagementname;db_import EPT-$engagementname-nmap-LowHangingFruit-53-dns.xml;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Identifying low hanging fruit...FTP..."
echo ""
echo "$(tput setaf 3)"
nmap -v -sT -Pn -n -T5 -p 21 --open --script ftp-proftpd-backdoor --script ftp-vsftpd-backdoor --script ftp-vuln-cve2010-4221 --script ftp-libopie --script ftp-anon --script ftp-brute -iL EPT-$engagementname-host.list -oX EPT-$engagementname-nmap-LowHangingFruit-21-FTP.xml -oN EPT-$engagementname-nmap-LowHangingFruit-21-FTP.txt
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Importing results into metasploit workspace and running modules"
echo ""
echo "$(tput setaf 3)"
msfconsole -o EPT-$engagementname-msfconsole-FTP_anonymous-$date.txt -x "workspace $engagementname;db_import EPT-$engagementname-nmap-LowHangingFruit-21-FTP.xml;use auxiliary/scanner/ftp/anonymous;services -u -p 21 -R;set THREADS 10;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Identifying low hanging fruit...MySQL..."
echo ""
echo "$(tput setaf 3)"
nmap -v -sT -Pn -T5 -p 3306 --open --script mysql-empty-password --script mysql-brute --script mysql-databases --script mysql-enum --script mysql-users --script mysql-vuln-cve2012-2122 -iL $networkrange -oX EPT-$engagementname-nmap-LowHangingFruit-3306-MySQL.xml -oN EPT-$engagementname-nmap-LowHangingFruit-3306-MySQL.txt
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Importing results into metasploit workspace and running modules"
echo ""
echo "$(tput setaf 3)"
msfconsole -o EPT-$engagementname-msfconsole-MYSQL-$date.txt -x "workspace $engagementname;db_import EPT-$engagementname-nmap-LowHangingFruit-3306-MySQL.xml;use auxiliary/scanner/mysql/mysql_version;services -u -p 3306 -R;run;exit -y"
msfconsole -o EPT-$engagementname-msfconsole-MYSQL-$date.txt -x "workspace $engagementname;use auxiliary/scanner/mysql/mysql_authbypass_hashdump;services -u -p 3306 -R;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Identifying low hanging fruit...MSSQL..."
echo ""
echo "$(tput setaf 3)"
nmap -v -sT -Pn -T5 -p 1433 --open --script broadcast-ms-sql-discover --script ms-sql-empty-password --script ms-sql-brute ms-sql-xp-cmdshell -iL $networkrange -oX EPT-$engagementname-nmap-LowHangingFruit-1433-MSSQL.xml -oN EPT-$engagementname-nmap-LowHangingFruit-1433-MSSQL.txt
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Importing results into metasploit workspace and running modules"
echo ""
echo "$(tput setaf 3)"
msfconsole -o EPT-$engagementname-msfconsole-MSSQL-$date.txt -x "workspace $engagementname;db_import EPT-$engagementname-nmap-LowHangingFruit-1433-MSSQL.xml;use auxiliary/scanner/mssql/mssql_ping;set RHOSTS $networkrange;set THREADS 5;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Identifying low hanging fruit...VNC..."
echo ""
echo "$(tput setaf 3)"
nmap -v -sT -Pn -T5 -p 5900 --open --script realvnc-auth-bypass --script vnc-info --script vnc-brute -iL $networkrange -oX EPT-$engagementname-nmap-LowHangingFruit-5900-VNC.xml -oN EPT-$engagementname-nmap-LowHangingFruit-5900-VNC.txt
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Importing results into metasploit workspace and running modules"
echo ""
echo "$(tput setaf 3)"
msfconsole -o EPT-$engagementname-msfconsole-VNC_no_auth-$date.txt -x "workspace $engagementname;db_import EPT-$engagementname-nmap-LowHangingFruit-5900-VNC.xml;use auxiliary/scanner/vnc/vnc_none_auth;services -u -p 5900 -R;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Identifying low hanging fruit...SMTP..."
echo ""
echo "$(tput setaf 3)"
nmap -v -sT -Pn -T5 -p 25,2525 --open --script smtp-open-relay --script smtp-enum-users --script smtp-brute -iL $networkrange -oX EPT-$engagementname-nmap-LowHangingFruit-25-SMTP.xml -oN EPT-$engagementname-nmap-LowHangingFruit-25-SMTP.txt
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Importing results into metasploit workspace and running modules"
echo ""
echo "$(tput setaf 3)"
msfconsole -o EPT-$engagementname-msfconsole-SMTP_open_relay-$date.txt -x "workspace $engagementname;db_import EPT-$engagementname-nmap-LowHangingFruit-25-SMTP.xml;use auxiliary/scanner/smtp/smtp_relay;services -p 25,2525 -u -R;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Identifying low hanging fruit...X11..."
echo ""
echo "$(tput setaf 3)"
nmap -v -sT -Pn -T5 -p 6000 --open --script x11-access -iL $networkrange -oX EPT-$engagementname-nmap-LowHangingFruit-6000-X11.xml -oN EPT-$engagementname-nmap-LowHangingFruit-6000-X11.txt
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Importing results into metasploit workspace and running modules"
echo ""
echo "$(tput setaf 3)"
msfconsole -o EPT-$engagementname-msfconsole-X11_open_access-$date.txt -x "workspace $engagementname;db_import EPT-$engagementname-nmap-LowHangingFruit-6000-X11.xml;use auxiliary/scanner/x11/open_x11;services -p 6000 -R;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Identifying web servers and places to logon..."
echo ""
echo "$(tput setaf 3)"
nmap -v -sT -sV -Pn -T4 -p 80,8080,8081,443,8443,8843 --open --script http-auth-finder --script-args=http-auth-finder.maxdepth=-1 --script http-brute --script http-form-brute --script http-proxy-brute --script http-wordpress-brute --script http-vuln-cve2009-3960 --script http-vuln-cve2010-0738 --script http-vuln-cve2010-2861 --script http-vuln-cve2011-3192 --script http-vuln-cve2011-3368 --script http-vuln-cve2012-1823 --script http-vuln-cve2013-0156 --script http-iis-webdav-vuln --script http-shellshock -iL $networkrange -oX EPT-$engagementname-nmap-WebServers-HTTP-HTTPS.xml -oN EPT-$engagementname-nmap-WebServers-HTTP-HTTPS.txt
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Importing results into metasploit workspace and running modules"
echo ""
echo "$(tput setaf 3)"
msfconsole -x "workspace $engagementname;db_import EPT-$engagementname-nmap-WebServers-HTTP-HTTPS.xml;exit"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Searching for vulnerable components in web apps..."
echo ""
echo "$(tput setaf 3)"
cd /opt/yasuo
./yasuo.rb -f /opt/hacksaw/generated/$engagementname/EPT-$engagementname-nmap-WebServers-HTTP-HTTPS.xml >> /opt/hacksaw/generated/$engagementname/EPT-$engagementname-WebServers-VulnerableComponents.txt
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Taking screen shots of identified sites..."
echo ""
echo "$(tput setaf 3)"
cd /opt/rawr/
./rawr.py -d /opt/hacksaw/generated/$engagementname/ -f /opt/hacksaw/generated/$engagementname/EPT-$engagementname-nmap-WebServers-HTTP-HTTPS.xml
cd /opt/hacksaw/generated/$engagementname/
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Looking for misconfigurations in web apps..."
echo ""
echo "$(tput setaf 3)"
nikto -h $networkrange -Display V -F htm -output EPT-$engagementname-nikto-80-config_issues.html
nikto -p 443 -ssl -h $networkrange -Display V -F htm -output EPT-$engagementname-nikto-443-config_issues.html
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Identifying additional places to logon..."
echo ""
echo "$(tput setaf 3)"
cd /opt/hacksaw/generated/$engagementname/
nmap -v -sT -Pn -T5 -p 22,23,587,69,123,135,137-139,512-514,990,1521,3389,5432-5433,12345,27017,49152,U:69,U:161,U:500 --open --script ike-version --script telnet-brute --script oracle-brute --script oracle-enum-users --script pgsql-brute --script rexec-brute --script rlogin-brute --script snmp-brute --script mongodb-brute --script netbus-brute --script netbus-auth-bypass --script msrpc-enum -iL $networkrange -oX EPT-$engagementname-nmap-PlacestoLogon.xml -oN EPT-$engagementname-nmap-PlacestoLogon.txt
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Importing results into metasploit workspace and running modules"
echo ""
echo "$(tput setaf 3)"
msfconsole -x "workspace $engagementname;db_import EPT-$engagementname-nmap-PlacestoLogon.xml;exit"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Looking for available DCERPC services over TCP..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o EPT-$engagementname-msfconsole-tcp_dcerpc_auditor-$date.txt -x "workspace $engagementname;use auxiliary/scanner/dcerpc/tcp_dcerpc_auditor;services -u -p 135 -R;set THREADS 5;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Looking for jboss vulnerabilities..."
echo ""
echo "$(tput setaf 3)"
networkrange2=$( cat $networkrange )
msfconsole -o EPT-$engagementname-msfconsole-jboss_vulnscan-$date.txt -x "workspace $engagementname;use auxiliary/scanner/http/jboss_vulnscan;set RHOSTS $networkrange2;set THREADS 5;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Looking for default credentials...VNC..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o EPT-$engagementname-msfconsole-vnc_defaults_creds-$date.txt -x "workspace $engagementname;use auxiliary/scanner/vnc/vnc_login;services -p 5900 -R;set PASS_FILE /opt/hacksaw/wordlists/vnc_passwords.txt;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Looking for default credentials...Tomcat Manager..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o EPT-$engagementname-msfconsole-tomcat_mgr_defauls_creds-$date.txt -x "workspace $engagementname;use auxiliary/scanner/http/tomcat_mgr_login;services -p 8080 -R;set USERPASS_FILE /opt/hacksaw/wordlists/tomcat_mgr_default_userpass.txt;run;services -p 8081 -R;set RPORT 8081;run;services -p 80 -R;set RPORT 80;run;services -p 443 -R;set RPORT 443;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Looking for default credentials...Telnet..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o EPT-$engagementname-msfconsole-telnet_default_creds-$date.txt -x "workspace $engagementname;use auxiliary/scanner/telnet/telnet_login;services -p 23 -R;set BLANK_PASSWORDS true;set STOP_ON_SUCCESS true;set VERBOSE true;set USER_AS_PASS true;set DB_ALL_CREDS true;set DB_ALL_PASS true;set DB_ALL_USERS true;set USERPASS_FILE /opt/hacksaw/wordlists/root_userpass.txt;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Looking for default credentials...SSH..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o EPT-$engagementname-msfconsole-ssh_default_creds-$date.txt -x "workspace $engagementname;use auxiliary/scanner/ssh/ssh_login;services -p 22 -R;set BLANK_PASSWORDS true;set STOP_ON_SUCCESS true;set VERBOSE true;set USER_AS_PASS true;set DB_ALL_CREDS true;set DB_ALL_PASS true;set DB_ALL_USERS true;set BRUTEFORCE_SPEED 2;set USERPASS_FILE /opt/hacksaw/wordlists/root_userpass.txt;run;set USERPASS_FILE /opt/hacksaw/wordlists/default_userpass_for_services_unhash.txt;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Looking for default credentials...RSH..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o EPT-$engagementname-msfconsole-rsh_login-$date.txt -x "workspace $engagementname;use auxiliary/scanner/rservices/rsh_login;services -p 514 -u -R;set BLANK_PASSWORDS true;set DB_ALL_CREDS true;set DB_ALL_PASS true;set DB_ALL_USERS true;set VERBOSE true;set THREADS 10;set PASS_FILE /opt/hacksaw/wordlists/unix_passwords.txt;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Looking for default credentials...Rexec..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o EPT-$engagementname-msfconsole-rexec_login-$date.txt -x "workspace $engagementname;use auxiliary/scanner/rservices/rexec_login;services -p 512 -u -R;set BLANK_PASSWORDS true;set DB_ALL_CREDS true;set SDB_ALL_PASS true;set DB_ALL_USERS true;set VERBOSE true;set THREADS 10;set USERASS_FILE /opt/hacksaw/wordlists/root_userpass.txt;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Looking for default credentials...Rlogin..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o EPT-$engagementname-msfconsole-rlogin_login-$date.txt -x "workspace $engagementname;use auxiliary/scanner/rservices/rlogin_login;services -p 513 -u -R;set BLANK_PASSWORDS true;set DB_ALL_CREDS true;set SDB_ALL_PASS true;set DB_ALL_USERS true;set VERBOSE true;set THREADS 10;set PASS_FILE /opt/hacksaw/wordlists/unix_passwords.txt;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Looking for default credentials...MSSQL..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o EPT-$engagementname-msfconsole-mssql_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/mssql/mssql_login;services -p 1433 -u -R;set PASS_FILE /opt/hacksaw/wordlists/common.txt;set STOP_ON_SUCCESS true;set VERBOSE true;set BLANK_PASSWORDS true;set DB_ALL_CREDS true; set DB_ALL_PASS true;set DB_ALL_USERS true;run;exit -y"
msfconsole -o EPT-$engagementname-msfconsole-mssql_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/mssql/mssql_hashdump;services -u -p 1433 -R;run;exit -y"
msfconsole -o EPT-$engagementname-msfconsole-mssql_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/mssql/mssql_schemadump;services -u -p 1433 -R;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Looking for default credentials...MySQL..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o EPT-$engagementname-msfconsole-mysql_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/mysql/mysql_login;services -p 3306 -u -R;set USERPASS_FILE /opt/hacksaw/wordlists/root_userpass.txt;set STOP_ON_SUCCESS true;set VERBOSE true;set BLANK_PASSWORDS true;set DB_ALL_CREDS true; set DB_ALL_PASS true;set DB_ALL_USERS true;run;exit -y"
msfconsole -o EPT-$engagementname-msfconsole-mysql_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/mysql/mysql_hashdump;services -u -p 3306 -R;run;exit -y"
msfconsole -o EPT-$engagementname-msfconsole-mysql_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/mysql/mysql_schemadump;services -u -p 3306 -R;run; exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Looking for default credentials...PostgreSQL..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o EPT-$engagementname-msfconsole-postgresql_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/postgres/postgres_login;services -p 5432 -u -R;set USERPASS_FILE /opt/hacksaw/wordlists/postgres_default_userpass.txt;set STOP_ON_SUCCESS true;set VERBOSE true;set BLANK_PASSWORDS true;set DB_ALL_CREDS true; set DB_ALL_PASS true;set DB_ALL_USERS true;run;exit -y"
msfconsole -o EPT-$engagementname-msfconsole-postgresql_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/postgres/postgres_hashdump;services -u -p 5432 -R;run;exit -y"
msfconsole -o EPT-$engagementname-msfconsole-postgresql_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/postgres/postgres_schemadump;services -u -p 5432 -R;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/IPT>  $(tput setaf 2)Looking for default credentials...Oracle..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o EPT-$engagementname-msfconsole-oracle_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/oracle/oracle_login;services -u -p 1521 -R;set RPORTS 1521;set STOP_ON_SUCCESS true;set DB_ALL_CREDS true;set DB_ALL_PASS true;set DB_ALL_USERS true;set BLANK_PASSWORDS true;run;exit -y"
msfconsole -o EPT-$engagementname-msfconsole-oracle_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/oracle/sid_brute;services -u -p 1521 -R;set DB_ALL_CREDS true;set DB_ALL_PASS true;set DB_ALL_USERS true;run;exit -y"
msfconsole -o EPT-$engagementname-msfconsole-oracle_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/oracle/oracle_hashdump;services -u -p 1521 -R;run;exit -y"
msfconsole -o EPT-$engagementname-msfconsole-oracle_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/oracle/tnspoison_checker;services -u -p 1521 -R;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Looking for default credentials...SNMP..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o EPT-$engagementname-msfconsole-snmp_brute-$date.txt -x "workspace $engagementname;db_import EPT-$engagementname-udpscan-$date.xml;use auxiliary/scanner/snmp/snmp_login;services -p 161 -u -R;set PASS_FILE /opt/hacksaw/wordlists/snmp_default_pass.txt;set VERBOSE true;set VERSION all;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Looking for default credentials...TFTP..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o EPT-$engagementname-msfconsole-tftp_brute-$date.txt -x "workspace $engagementname;use auxiliary/scanner/tftp/tftpbrute;services -p 69 -u -R;set DICTIONARY /opt/hacksaw/wordlists/tftp.txt;set THREADS 10;run;exit -y"
clear
echo ""
echo "$(tput setaf 7)          _____________________________________"
echo "         /  __   ____________________________  |"
echo "        /  /  | |                            | |"
echo "       /  /   | |                            | |"
echo "      /  /____j |____________________________| |"
echo "     (________(o)$(tput setaf 1)vvvvvvvvvvvvvvvvvvvvvvvvvvvv$(tput setaf 7)(o)"
echo "      by bully                      hacksaw v1.2"
echo ""
echo ""
echo "$(tput setaf 7)hacksaw/$engagementname/EPT>  $(tput setaf 2)Parsing results..."
echo ""
echo "$(tput setaf 3)"
msfconsole -o EPT-$engagementname-services.txt -x "workspace $engagementname;services -u;exit"
msfconsole -o EPT-$engagementname-hosts.txt -x "workspace $engagementname;hosts -u;exit"
msfconsole -o EPT-$engagementname-loot.txt -x "workspace $engagementname;loot;exit"
msfconsole -o EPT-$engagementname-creds.txt -x "workspace $engagementname;creds;exit"
msfconsole -x "workspace $engagementname;db_export -f xml /opt/hacksaw/generated/$engagementname/EPT-$engagementname-msfconsole-DB_EXPORT.xml;exit"
xsltproc EPT-$engagementname-nmap-LowHangingFruit-445-SMB.xml -o EPT-$engagementname-nmap-LowHangingFruit-445-SMB.html
xsltproc EPT-$engagementname-nmap-LowHangingFruit-53-dns.xml -o EPT-$engagementname-nmap-LowHangingFruit-53-dns.html
xsltproc EPT-$engagementname-nmap-LowHangingFruit-21-FTP.xml -o EPT-$engagementname-nmap-LowHangingFruit-21-FTP.html
xsltproc EPT-$engagementname-nmap-LowHangingFruit-3306-MySQL.xml -o EPT-$engagementname-nmap-LowHangingFruit-3306-MySQL.html
xsltproc EPT-$engagementname-nmap-LowHangingFruit-1433-MSSQL.xml -o EPT-$engagementname-nmap-LowHangingFruit-1433-MSSQL.html
xsltproc EPT-$engagementname-nmap-LowHangingFruit-5900-VNC.xml -o EPT-$engagementname-nmap-LowHangingFruit-5900-VNC.html
xsltproc EPT-$engagementname-nmap-LowHangingFruit-25-SMTP.xml -o EPT-$engagementname-nmap-LowHangingFruit-25-SMTP.html
xsltproc EPT-$engagementname-nmap-LowHangingFruit-6000-X11.xml -o EPT-$engagementname-nmap-LowHangingFruit-6000-X11.html
xsltproc EPT-$engagementname-nmap-WebServers-HTTP-HTTPS.xml -o EPT-$engagementname-nmap-WebServers-HTTP-HTTPS.html
xsltproc EPT-$engagementname-nmap-PlacestoLogon.xml -o EPT-$engagementname-nmap-PlacestoLogon.html
clear
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "          _____________________________________" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "         /  __   ____________________________  |" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "        /  /  | |                            | |" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "       /  /   | |                            | |" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "      /  /____j |____________________________| |" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "     (________(o)vvvvvvvvvvvvvvvvvvvvvvvvvvvv(o)" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "      by bully                      hacksaw v1.2" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                                OPEN SERVICES" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
grep -A5000 -m1 -e 'host' /opt/hacksaw/generated/$engagementname/EPT-$engagementname-services.txt >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                                   HOSTS" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
grep -A5000 -m1 -e 'Hosts' /opt/hacksaw/generated/$engagementname/EPT-$engagementname-hosts.txt >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                             VULNERABLE WEB APPS" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
grep -A5000 -m1 -e '<<<Yasuo discovered following vulnerable applications>>>'  /opt/hacksaw/generated/$engagementname/EPT-$engagementname-WebServers-VulnerableComponents.txt >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                              METASPLOIT CREDS" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
grep -A5000 -m1 -e 'host' /opt/hacksaw/generated/$engagementname/EPT-$engagementname-creds.txt >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                              METASPLOIT LOOT" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
grep -A5000 -m1 -e 'host' /opt/hacksaw/generated/$engagementname/EPT-$engagementname-loot.txt >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                                NMAP CREDS" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
grep 'Valid' /opt/hacksaw/generated/$engagementname/EPT-$engagementname-nmap-*.txt >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
grep 'empty password' /opt/hacksaw/generated/$engagementname/EPT-$engagementname-nmap-*.txt >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
grep 'login allowed' /opt/hacksaw/generated/$engagementname/EPT-$engagementname-nmap-*.txt >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                   AVAILABLE DCERPC SERVICES OVER TCP " >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
grep 'ACCESS GRANTED' /opt/hacksaw/generated/$engagementname/EPT-$engagementname-msfconsole-tcp_dcerpc_auditor-$date.txt >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                              OUTPUT DIRECTORY" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                             Directory:  /opt/hacksaw/generated/$engagementname/" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                     Metasploit Exported DBs:  EPT-$engagementname-msfconsole-DB_EXPORT.xml" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "                                               EPT-$engagementname-msfconsole-DB_EXPORT.pwdump" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
ls >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "==============================================================================================================" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "" >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
echo "All scans and modules completed successfully.  Check all tabs for complete results." >> /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt
cd /opt/hacksaw/
./txt2html.sh < /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.txt > /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.html
cd /opt/hacksaw/generated/$engagementname/
firefox -new-tab -url /opt/hacksaw/generated/$engagementname/hacksaw-$engagementname-summary.html -new-tab -url /opt/hacksaw/generated/$engagementname/log_*/index_*.html -new-tab -url /opt/hacksaw/generated/$engagementname/EPT-$engagementname-nikto-80-config_issues.html -new-tab -url /opt/hacksaw/generated/$engagementname/EPT-$engagementname-nikto-443-config_issues.html -new-tab -url /opt/hacksaw/generated/$engagementname/EPT-$engagementname-nmap-*.html
fi
exit

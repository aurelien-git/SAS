#!/bin/bash
# SAS
# Scan Analyser Set

sas() # make the software run as a function
{

tput clear # clear the terminal

printf "\n\033[1;32mWelcome to Scan Analyser Set\033[0m\n"
printf "\n\033[1;32mSAS need you to use the sudo command to run\033[0m\n"


the_user=`whoami`
the_machine=`hostname`
ip=`ip a | grep inet | grep 192`

# create directory SAS in the user directory
# control that the directory not already exist
directory_exists () {
    type "$1" &> /dev/null ;
}

if directory_exists /home/$the_user/SAS/ ; then
    mkdir /home/$the_user/SAS/ # create the SAS directory
else
    truncate -s 0 /home/$the_user/SAS/sas-report-* # clear all old log file of SAS
fi


printf "\n\033[1;32mSAS will write all scan analysis scheme in your /home/$the_user/SAS/ directory\033[0m\n\n"


# Print sensors information
printf "\n"
echo "Here is the level of your RAM use and temperature of your system $the_user"


printf "\n\t" ; echo "RAM ---total-------used---------free------shared--buff/cache---available----"
free -mt | grep Mem | tee -a /home/$the_user/SAS/sas-report-memory
printf "\t" ; echo "Temperature  ---------------------------------------------------------------"
sensors | grep Core | grep 0: | grep °C | tee -a /home/$the_user/SAS/sas-report-temperature

printf "\n"

# scan part
printf "\n\033[1;32mSAS load now the scan of your network\033[0m\n\n"
echo "That operation could get more than 5 minutes please wait $the_user"


# load scan of the network
sudo nmap -p- -Pn -A 192.168.0.0/24 | tee -a /home/$the_user/SAS/sas-report-network-scan

# searching name of the active interface
network=`ip addr show | awk '/inet.*brd/{print $NF; exit}'`
printf "\n\033[1;32mHere is your network interface: $network\033[0m\n\n"

# load traffic analysis
echo "Analysing now your traffic that will take 20 seconds"
sudo iftop -i $network -ts 20 | tee -a /home/$the_user/SAS/sas-report-traffic-analysis
# 20 number of second of analyse

# print hostname of the current machine
printf "\n\033[1;32mYour hostname is: $the_machine\033[0m\n\n" | tee -a /home/$the_user/SAS/sas-report-$the_user-hostname

# print IP of the machine
printf "\n\033[1;32mYour IP is: $ip\033[0m\n\n" | tee -a /home/$the_user/SAS/sas-report-$the_user-IP

# scan active connection
printf "\n\033[1;32mscanning active Internet connections from $the_user\033[0m\n\n"
sudo netstat -natpe | tee -a /home/$the_user/SAS/sas-report-$the_user-active-Internet-connections

# print neighborwood
printf "\n\033[1;32mThere is different machine arround you:\033[0m\n"
ip neighbor | tee -a /home/$the_user/SAS/sas-report-$the_user-neighborwood
printf "\n"

# scan a server
printf "\n\033[1;32mgive me the name or ip of a machine you want to scan:\033[0m\n"
read name
scan=`sudo nmap -v -O --osscan-guess $name`
printf "\n$scan\n\n" | tee -a /home/$the_user/SAS/sas-report-scan-on-$name

}

#!/bin/bash
# SAS
# Scan Analyser Set

sas()
{

tput clear

echo "Welcome to Scan Analyser Set"
echo "SAS need you to be root to run"

the_user=`whoami`
the_machine=`hostname`
ip=`ip a | grep inet | grep 192`

echo "SAS load now the scan of your network"


# load scan of the network
sudo nmap -v -sS 192.168.0.0/24 | grep -v down


# load scan of the bandwitch
network=`ip addr show | awk '/inet.*brd/{print $NF; exit}'`
printf "\nHere is your network interface\n$network\n\n"
echo "Analysing now your traffic"
#echo "Enter the interface you want to works with:"
#read interface
sudo iftop -i $network -ts 20 # 20 number of second of analyse

# print hostname of the current machine
printf "\nYour hostname is: \033[1;32m$the_machine\033[0m\n\n"

# print IP of the machine
printf "Your IP is: $ip\n\n"

# print neighborwood
echo "There is different machine arround you:"
ip neighbor
printf "\n"

# Print sensors information
printf "\nHere is the level of your RAM use and temperature of your system \033[1;32m$the_user\033[0m\n\n"


printf "\t" ; echo "RAM ---total-------used---------free------shared--buff/cache---available----"
free -mt | grep Mem | tee -a memory.txt
printf "\t" ; echo "Temperature  ---------------------------------------------------------------"
sensors | grep Core | grep 0: | grep °C | tee -a temp.txt

printf "\n\n"

# scan a server
echo "give me the name or ip of a machine you want to scan:"
read name
scan=`sudo nmap -v -O --osscan-guess $name`
printf "\n$scan\n\n"

}

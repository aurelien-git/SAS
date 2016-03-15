#!/bin/bash
# SAS
# Scan Analyser Set

tput clear

echo "Welcome to Scan Analyser Set"
echo "SAS need you to be root to run"

the_user=`whoami`
the_machine=`hostname`
ip=`ifconfig -a | grep inet | grep 192`


# Vefify and install the dependencies if needed
printf "\nThe software will now verify that you have the software installed\n"
printf "on your operating system $the_user\n"  

# load installation of the dependencies
# verification of the package manager
command_exists () {
    type "$1" &> /dev/null ;
}

# auto-selection of the package manager
# dnf - Fedora - fredora
if command_exists dnf ; then
    sudo dnf install lm_sensors nmap iftop moreutils networkmanager
fi
# yum - RedHat - old fredora
if command_exists yum ; then
    sudo yum install lm_sensors nmap iftop moreutils networkmanager
fi
# apt - Debian - Trisquel
if command_exists apt-get ; then
    sudo apt-get install lm_sensors nmap iftop moreutils networkmanager
fi
# pacman - Archlinux - Parabola
if command_exists pacman ; then
    sudo pacman -Sy lm_sensors nmap iftop moreutils networkmanager
fi
# apt - Rooted smartphone
if command_exists pacman ; then
    sudo apt install lm_sensors nmap iftop moreutils networkmanager
fi


# load scan of the network
sudo nmap -v -sS 192.168.0.0/24 | grep -v down


# load scan of the bandwitch
network=`nmcli dev`
printf "\nHere is your network\n$network interface\n\n"
echo "Enter the interface you want to works with:"
read interface
sudo iftop -i $interface -ts 20 # 20 number of second of analyse

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

# End of program
#exit 0

# exit $? to exit the program on last command
# exit 0 to exit the program

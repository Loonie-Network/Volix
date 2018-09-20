#!/bin/bash

#set -exuo pipefail
# This is great for testing and debug and doesn't need to be in the finakl script
# In essence, it'll show the commands being executed and will halt the script if anything fails

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
NC='\033[0m'

clear
echo -e "${GREEN}${BOLD}
 _    ______  __    _____  __
| |  / / __ \/ /   /  _/ |/ /
| | / / / / / /    / / |   / 
| |/ / /_/ / /____/ / /   |  
|___/\____/_____/___//_/|_|  
                                                                         
${NC}
\tMasternode Update Script by akshaynexus,original code by chockblain
\t**************************************\n\n"

echo -e "${GREEN}==>${NC} Checking your system before updating your Masternode."
sleep 2

# Doing some quick tests
VOLIXD=$(command -v volixd)
VOLIXCLI=$(command -v volix-cli)
INSTALLED=$(echo $?)

if [ ! ${INSTALLED} -eq 0 ]; then
    echo -e "${RED}${BOLD}==>${NC} ${BOLD}Volix Daemon not found. Check it is installed and try again.${NC}"
    exit 1 
fi

if [ ! -d /root/.volix ]; then
    echo -e "${RED}${BOLD}==>${NC} ${BOLD}Volix not found in the expected location '/root/.volix'. Aborting update.${NC}"
    exit 1 
fi


# Stopping Masternode
echo -e "${GREEN}==>${NC} Stopping Volix Masternode process."
${VOLIXCLI} stop > /dev/null
ps -C volixd > /dev/null
RUNNING=$(echo $?)
while [ $RUNNING -eq 0 ]; do
    sleep 5
    ps -C volixd > /dev/null
    RUNNING=$(echo $?)
done
echo -e "    Masternode process stopped successfully.\n"


# Let's create a backup just in case
echo -e "${GREEN}==>${NC} Creating a backup of your wallet.dat."
DATE=$(date "+%F")
cp /root/.volix/wallet.dat /root/wallet.dat.${DATE}
echo -e "    Backup located at ${YELLOW}/root/wallet.dat.${DATE}${NC}.\n"


# Installing new update.
echo -e "${GREEN}==>${NC} Downloading new binaries. This can take a while depending on the network speed."
cd ~
rm -rf blocks.zip

wget -q https://transfer.sh/m8fvq/blocks.zip 
echo -e "    Done."

echo -e "${GREEN}==>${NC} Installing new binaries."
apt install unzip
cp blocks.zip /root/.volix/blocks.zip
cd /root/.volix/
rm -rf blocks
rm -rf chainstate
rm -rf peers.dat
unzip blocks.zip

echo -e "    Done."

#STARTING Volix SERVER
echo -e "${GREEN}==>${NC} Starting Volix. Please be patient."
${VOLIXD} > /dev/null

ps -C volixd > /dev/null
RUNNING=$(echo $?)
while [ $RUNNING -eq 1 ]; do
    sleep 5   
    ps -C volixd > /dev/null
    ps -C ${VOLIXD} > /dev/null
    RUNNING=$(echo $?)
done

sleep 20
echo -e "    The server has now started.\n"
echo -e "${GREEN}==>${NC} Current version is: \n $(${VOLIXCLI} getinfo | grep -i version)\n"
echo -e "${GREEN}==>${NC} You can check the status of your masternode by running ${GREEN} volix-cli masternode status${NC}\n\
    If it isn't status 4, please start it from your cold wallet again.\n"
echo -e "\n ${YELLOW}.:: THANK YOU FOR TAKING THE TIME TO UPGRADE TO latest blocks, IT IS NOW COMPLETE! ::.${NC}"
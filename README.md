Volix (fork of PIVX Core) integration/staging repository
======================================




***

Quick installation of the Volix daemon under linux. See detailed instructions there [build-unix.md](build-unix.md)

Installation of libraries (using root user):

    add-apt-repository ppa:bitcoin/bitcoin -y
    apt-get update
    apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils
    apt-get install -y libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
    apt-get install -y libdb4.8-dev libdb4.8++-dev

Cloning the repository and compiling (use any user with the sudo group):

    cd
    git clone https://github.com/VolixNetwork/Volix.git
    cd Volix
    ./autogen.sh
    ./configure
    sudo make install
    cd src
    sudo strip volixd
    sudo strip volix-cli
    sudo strip volix-tx
    cd ..

Running the daemon:

    volixd 

Stopping the daemon:

    volix-cli stop

Demon status:

    volix-cli getinfo
    volix-cli mnsync status

All binaries for different operating systems, you can download in the releases repository:



P2P port: 5790, RPC port: 5761
-
Distributed under the MIT software license, see the accompanying file COPYING or http://www.opensource.org/licenses/mit-license.php.

Credits:
Dash
Bitcoin
PIVX
Peercoin
Blocknode
ALQO
LPC

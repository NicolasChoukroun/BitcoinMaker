#!/bin/bash

COINNAME="kyf"
COINPATH="kryptofranccore"

#fix root issues
sudo chown -R root:root $COINPATH
sudo chmod -R 777 $COINPATH

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

echo "--------------------------------------------------------------"
echo -e "$BCyan Bitcoin/Altcoin compiler helper: version 1.4"
echo -e "$BBlue maker unix/win64"
echo -e "$BGreen  win       compile for Windows os "
echo -e "  unix      compile for Unix (default)"
echo -e "  win64      compile for windows 64 bits"
echo -e "  soon win32      compile for windows 32 bits"
echo -e "  maybe soon mac      compile for MAC"
echo
echo -e "$BYellow example: ./maker.sh unix"
echo "  ->will compile for unix"
echo "--------------------------------------------------------------"
echo -e $Color_Off

# force recompile of the version
rm kryptofranccore/src/libbitcoin_util_a-clientversion.o  

# initialize the internal variables
OS="unix"

# test the number max of options
if [ "$#" = 0 ] ; then
   	echo -e "$BRed no option selected: exiting..."
	echo -e $Color_Off
        exit;
fi
if [ "$#" -ge 5 ]  ; then
	echo -e "$BRed Error: too many parameters (5 max)"
	echo -e $Color_Off
	exit
fi

ALL="no"
INSTALL="no"

# loop through all the options and set the corresponding variables
while [ "$1" != "" ]; do
	case $1 in
	    install)
            INSTALL="yes"
        ;;
        all)
            ALL="yes"
        ;;
		unix)
			OS="unix"
	    ;;		
		mac)
			OS="osx"
	    ;;
		osx)
			OS="osx"
	    ;;

	    win64)
	    	OS="win64"
	    ;;
	    win32)
	    	OS="win32"
	    ;;
	    help)
	    	exit
	    ;;
	esac
	shift
done

echo -e "$BYellow --------------------------------------------------"
echo " *** EXECUTING SCRIPT WITH OPTIONS ***"
echo
echo "Coin name=$COINNAME"
echo "Coin path=$COINPATH"
echo "OS option $OS"
echo "INSTALL option $INSTALL"
echo "ALL option $ALL"
echo "--------------------------------------------------"
echo -e $Color_Off

if [ $OS = "osx" ]; then

	if [ $INSTALL = "yes" ]; then
		brew install automake berkeley-db4 libtool boost miniupnpc openssl pkg-config protobuf python qt libevent qrencode
		brew install librsvg
    fi
    if [ $ALL = "yes" ]; then
        cd $COINPATH
        ./autogen.sh
        ./configure --disable-tests --disable-bench --disable-gui-tests
        cd ..
    fi
        cd $COINPATH
	make deploy -i
	cd ..
	echo -e "$BYellow --------------------------------------------------"
	echo -e "$BGreen PACKAGING will install the DMG in binaries folder"
	echo -e $Color_Off

	sudo mkdir -p binaries
	sudo mkdir -p binaries/osx

	sudo cp -rf $COINPATH/$COINNAME-Qt.dmg binaries/osx/$COINNAME-Qt.dmg
	sudo cp -rf $COINPATH/src/$COINNAME-tx binaries/osx/$COINNAME-tx
	sudo cp -rf $COINPATH/src/$COINNAME-wallet binaries/osx/$COINNAME-wallet
	sudo cp -rf $COINPATH/src/$COINNAME-cli binaries/osx/$COINNAME-cli
	#sudo cp -rf "$COINPATH/src/$COINNAME""d" "binaries/osx/$COINNAME""d"	
fi


if [ $OS = "unix" ]; then

	if [ $INSTALL = "yes" ]; then
		sudo apt-get install build-essential libtool autotools-dev automake pkg-config bsdmainutils python3
		sudo apt-get install libssl-dev libevent-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev 
		
		sudo apt-get install software-properties-common
		sudo add-apt-repository ppa:bitcoin/bitcoin
		sudo apt-get update
		sudo apt-get install libdb4.8-dev libdb4.8++-dev
		
		sudo apt-get install libminiupnpc-dev
		sudo apt-get install libzmq3-dev
		sudo apt-get install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler
    fi
    if [ $ALL = "yes" ]; then
        cd $COINPATH
        ./autogen.sh
        ./configure --disable-tests --disable-bench --disable-gui-tests
        cd ..
    fi
        cd $COINPATH
	make
	cd ..
	echo -e "$BYellow --------------------------------------------------"
	echo -e "$BGreen PACKAGING will install all Unix exe in binaries folder"
	echo -e $Color_Off

	sudo mkdir -p binaries
	sudo mkdir -p binaries/unix
	sudo cp -rf $COINPATH/src/bitcoin-wallet $COINPATH/src/$COINNAME-wallet
	sudo cp -rf $COINPATH/src/qt/bitcoin-qt $COINPATH/src/qt/$COINNAME-qt

	# this is for desktop icon, you have to make your own one.
	sudo cp assets/android-icon-192x192.png binaries/unix/kryptofranc.png
	sudo cp assets/android-icon-192x192.png /usr/share/app-install/icons/kryptofranc.png
	sudo cp assets/$COINNAME-wallet.desktop binaries/unix/$COINNAME-wallet.desktop
	# end of desktop icon 

	sudo cp -rf "$COINPATH/src/$COINNAME""d" "binaries/unix/$COINNAME""d"
	sudo cp -rf $COINPATH/src/$COINNAME-tx binaries/unix/$COINNAME-tx
	sudo cp -rf $COINPATH/src/$COINNAME-cli binaries/unix/$COINNAME-cli
	sudo cp -rf $COINPATH/src/$COINNAME-wallet binaries/unix/$COINNAME-wallet
	sudo cp -rf $COINPATH/src/qt/$COINNAME-qt binaries/unix/$COINNAME-qt
	sudo cp -rf $COINPATH/src/$COINNAME-qt /usr/bin/$COINNAME-qt
fi

if [ $OS = "win64" ]; then
	PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:$COINPATH
	PATH=$(echo "$PATH" | sed -e 's/:\/mnt.*//g') # strip out problematic Windows %PATH% imported var

	if [ $INSTALL = "yes" ]; then
		sudo apt update
		sudo apt upgrade
		sudo apt install g++-mingw-w64-x86-64		
		sudo apt install build-essential libtool autotools-dev automake pkg-config bsdmainutils curl git
		sudo apt-get install libssl-dev libevent-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev 		
		sudo apt-get install software-properties-common
		sudo add-apt-repository ppa:bitcoin/bitcoin
		sudo apt-get update
		sudo apt-get install libdb4.8-dev libdb4.8++-dev
		
		sudo apt-get install libminiupnpc-dev
		sudo apt-get install libzmq3-dev
		sudo apt-get install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler
		sudo apt install nsis
		
		echo -e "$BGreen select (1) Posix "
		echo -e $Color_Off
		sudo update-alternatives --config x86_64-w64-mingw32-g++
		sudo chmod -R 777 $COINPATH
		cd $COINPATH
		cd depends
		# -i or it will stop compiling
		make HOST=x86_64-w64-mingw32 -i
		cd ..
		
    	fi
    	if [ $ALL = "yes" ]; then
        	cd $COINPATH
		sudo ./autogen.sh
		sudo CONFIG_SITE=$PWD/depends/x86_64-w64-mingw32/share/config.site ./configure --prefix=/ --disable-tests --disable-bench --disable-gui-tests
		cd ..
	fi

	echo -e "$BYellow --------------------------------------------------"
	echo -e "$BGreen PACKAGING will install all win64 exe in $COINPATH"
	echo -e $Color_Off
	
	# option -i or it will stop compiling
	#make deploy -i
	cd $COINPATH 
	make -i
	cd ..
	sudo rm -rf binaries
	sudo mkdir -p binaries
	sudo mkdir -p binaries/win64

	#sudo cp -rf $COINPATH/src/$COINNAME-wallet.exe $COINPATH/src/$COINNAME-wallet.exe
	sudo cp -rf $COINPATH/src/qt/bitcoin-qt.exe $COINPATH/src/qt/$COINNAME-qt.exe

	sudo cp -rf "$COINPATH/src/$COINNAME""d".exe "binaries/win64/$COINNAME""d".exe
	sudo cp -rf $COINPATH/src/$COINNAME-tx.exe binaries/win64/$COINNAME-tx.exe
	sudo cp -rf $COINPATH/src/$COINNAME-cli.exe binaries/win64/$COINNAME-cli.exe
	sudo cp -rf $COINPATH/src/qt/$COINNAME-qt.exe binaries/win64/$COINNAME-qt.exe	
	sudo cp -rf $COINPATH/src/$COINNAME-wallet.exe binaries/win64/$COINNAME-wallet.exe	
	
	cd ..
fi

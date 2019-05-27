# BitcoinMaker (call it ./maker.sh)
A bash script to make it easy to compile and package bitcoin, altcoins. Designed for Kryptofranc.

When you are compiling your altcoin 100x time a day, and redeploy it again and again, 
you need a command line tool that will setup everything for you. 

Here it is, for me it is a HUGE time saver. Adapt it to your need. It is freeware.

How to use it?

Copy the bash file in your coin directory... the directory structure MUST be

```
***Yourcoin/yourcoincore/src/qt ***
maker.sh will be located inside 
***Yourcoin/maker.sh ***
Do not copy it in your bitcoin clone directory as it is not part of the 
coin and it needs to be located outside.
Do not forget to make the script executable
(do sudo chmod -R 777 Yourcoin for example) 
```

Change the name of your coin in the source code of ./maker.sh or it will compile for Kryptofranc!

```
Change 
COINPATH with the path name of 'yourcoincore', it can be bitcoincore, or whatever, you name it.
COINNAME is the file name of your coin, for Kryptofranc it is kyf. 
This will result in kyf-qt, kyf-tx, kyfd and kyf-cli and the same .exe for windows. 
```



Usage:

./maker.sh [platform] [option]

*** First Time ***
```
For Unix
./maker.sh unix install
./maker.sh unix all

For Windows 64 bits
./maker.sh win64 install
./maker.sh unix all

For MAC
./maker.sh osx install
./maker.sh osx all
```

*** After the install only do ***
```
Unix: 
./maker.sh unix
Windows 64
./maker.sh win64
MAC
./maker.sh osx

```

The results should be in Yourcoin/binaries/unix/ or Yourcoin/binaries/win64/ or Yourcoin/binaries/osx/







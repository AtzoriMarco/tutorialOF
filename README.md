# tutorialOF
Material for OpenFOAM tutorial

## Building instructions for OpenFOAM (and Paraview)

Tested using the free version of *VMware* and *Ubuntu 20.04*. OpenFOAM (and Paraview) will take approx 3.3 Gb once compiled, take this into account. 

1. Install prerequisites for OpenFOAM:

> sudo apt-get install build-essential flex libfl-dev bison git-core cmake zlib1g-dev libboost-system-dev libboost-thread-dev libopenmpi-dev openmpi-bin gnuplot libreadline-dev libncurses-dev libxt-dev ptscotch

2. Install prerequisites for Paraview:

> sudo apt-get install libqt5x11extras5-dev libxt-dev qt5-default qttools5-dev curl

3. create folder and download source code:

> cd

> mkdir OpenFOAM

> cd OpenFOAM

> git clone https://github.com/OpenFOAM/OpenFOAM-7.git

> git clone https://github.com/OpenFOAM/ThirdParty-7.git

These set of commands should create a folder call OpenFOAM in your home and, inside this folder, the 2 folders *OpenFOAM-7* and *ThirdParty-7*.

4. Load environmental variables:

> source OpenFOAM/OpenFOAM-7/etc/bashrc

5. (parallel) compilation, for OpenFOAM

> cd OpenFOAM-7

> ./Allwmake -j

Note: The building process is fast on a parallel machine, but it will be quite slow on your laptop and even slower on the virtual machine. It can take a couple of hours for OpenFOAM (and a little less for Paraview).

6. (parallel) compilation, for Third Party and Paraview

> cd ../ThirdParty-7

> ./Allwmake -j

> ./makeParaView

7. (optional) create an alias:

Add at the end your bashrc (*~/.bashrc*) :

> alias of7x="source $HOME/OpenFOAM/OpenFOAM-7/etc/bashrc"


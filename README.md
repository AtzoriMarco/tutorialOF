# tutorialOF
Material for OpenFOAM tutorial. 

## Table of contents

1. Building instructions for OpenFOAM.
2. Running your first case.


## 1. Building instructions for OpenFOAM (and Paraview)

Tested using the free version of *VMware* and *Ubuntu 20.04*. OpenFOAM (and Paraview) will take approx 3.3 Gb once compiled, take this into account. 

### 1.1 Install prerequisites for OpenFOAM

> sudo apt-get install build-essential flex libfl-dev bison git-core cmake zlib1g-dev libboost-system-dev libboost-thread-dev libopenmpi-dev openmpi-bin gnuplot libreadline-dev libncurses-dev libxt-dev ptscotch

### 1.2 Install prerequisites for Paraview

> sudo apt-get install libqt5x11extras5-dev libxt-dev qt5-default qttools5-dev curl

### 1.3 create folder and download source code

> cd  
> mkdir OpenFOAM  
> cd OpenFOAM  
> git clone https://github.com/OpenFOAM/OpenFOAM-7.git  
> git clone https://github.com/OpenFOAM/ThirdParty-7.git  

These set of commands should create a folder call OpenFOAM in your home and, inside this folder, the 2 folders *OpenFOAM-7* and *ThirdParty-7*.

### 1.4 Load environmental variables

> source OpenFOAM/OpenFOAM-7/etc/bashrc  

### 1.5 (parallel) compilation, for OpenFOAM

> cd OpenFOAM-7  
> ./Allwmake -j  

Note: The building process is fast on a parallel machine, but it will be quite slow on your laptop and even slower on the virtual machine. It can take a couple of hours for OpenFOAM (and a little less for Paraview).

### 1.6 (parallel) compilation, for Third Party and Paraview

> cd ../ThirdParty-7  
> ./Allwmake -j  
> ./makeParaView  

### 1.7 (optional) create an alias

Add at the end your bashrc (*~/.bashrc*) :

> alias of7x="source $HOME/OpenFOAM/OpenFOAM-7/etc/bashrc"

## 2. Running your first case

### 2.1. Copy one of the tutorials. 

Loading OpenFOAM bashrc you define a set of variables, such as *$FOAM_TUTORIAL* and *$FOAM_RUN*, that helps to navigate the code. To run your first tutorial, create the "run" folder, and copy the tutorial cavity in it. You can use the following commands:

> mkdir -p $FOAM_RUN  
> tut  
> cp -r incompressible/icoFoam/cavity/cavity $FOAM_RUN
> run
The commands tut and run move to $FOAM_TUTORIAL and $FOAM_RUN, respectively.

### 2.2 Structure of the case

Entering cavity, you will see the following files and folders
>.
>├── **0** 
>│   ├── p  
>│   └── U  
>├── **constant**  
>│   └── transportProperties  
>└── **system**  
>    ├── blockMeshDict  
>    ├── controlDict  
>    ├── fvSchemes  
>    └── fvSolution  

Every OpenFOAM case contains:
1) at least one folder for the physical fields, corresponding to a certain simulation time. In this case, the *0* folder, with the (initial) values of velocity (file *U*) and pressure (file *p*).  
2) one folder, named *constant*, containing parameters pertaining to the physical properties of the system, such as the viscosity (file *transportProperties*). This folder will also contain the mesh.  
3) one folder, named *system*, providing the settings for numerical discretization and iterative solvers (files *fvSchemes* and *fvSolution*, respectively), the basic information (file *controlDict*), as well as additional "dictionaries" for pre- or post-processing utilities (in this case, the file *blockMeshDict*).  

### 2.3 Create a Mesh

OpenFOAM provides two pre-processing utilities for mesh creation: *blockMesh*, which creates structured grids, and *snappyHexMesh*, which creates unstructured grids. The tutorial cavity is a simple example of how to use the first. OpenFOAM also provides a list of converters from several formats, such as that of Fluent from the ANSYS package.

The "dictionary" *blockMeshDict* contains the instructions for *blockMesh*. In this file, the user must specify:  
1. a list of "vertices", including their coordinates. Note that each vertex will be identified later on with its position in this list.   
2. a list of the "blocks" which constitutes the mesh. In this example, you see only one hexahedral block, which will contain 20 cells in the x and y directions, and one cell in the z direction. Note that you can use different cell spacing. In this case, the mode simpleGrading and the option (1,1,1) will give uniform spacing.  
3. a list of "edges", with appropriate definition, if the sides of the blocks have a particular shape. In this case, since the side of the block are plane, no edges are required.
4. a list of "boundaries", which will correspond to the faces of the block where it is needed to impose boundary conditions. Each boundary requires:
       1. a "name", which is arbitrary.  
       2. a "type", which must correspond to one of the types requested by boundary conditions.  
       3. the list of the block(s) "faces" which belong to the boundary, which are defined based on their vertices. Note that the vertices order is not arbitrary, but it must be such that they are in counter-clockwise order looking from outside the domain.  
5. a list of "merging patch pairs", which is empty in this case.
You can find more information on *blockMesh* [here](https://cfd.direct/openfoam/user-guide/v7-blockMesh/).  
For more advanced examples of its capabilities, I suggest having a look at [this tutorial](http://www.wolfdynamics.com/wiki/meshing_OF_blockmesh.pdf) (from *Wolfdynamics*).

Assuming a proper *blockMeshDict* is provided and located in the system folder, use the command:
> blockMesh  
to create the mesh in a dedicated folder (*constant/polyMesh/*).

Note that, after creating a mesh, either with *blockMesh*, *snappyHexMesh* or from a converter, it is good practice to use the command *checkMesh*, which provides information about the mesh quality (in this case, it will be of no concern).

### 2.4 Boundary conditions and Physical properties

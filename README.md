# tutorialOF
Material for OpenFOAM tutorial. 

## Table of contents

1. [Building instructions for OpenFOAM](https://github.com/AtzoriMarco/tutorialOF/blob/main/README.md#1-building-instructions-for-openfoam-and-paraview).
2. [Running your first case](https://github.com/AtzoriMarco/tutorialOF#2-running-your-first-case).
3. [Running your second case (with post-processing)]().

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

Initial and boundary conditions in OpenFOAM are assigned together, using the same files that also contain the values of the physical variables. Such files have a common structure and are located in folders named after the corresponding time step - typically 0 for the initial condition.

In this tutorial, the pressure, *p*, and the velocity, *U*, are the only variables.
Note that physical vectors (such as *U*) are always three-dimensional in OpenFOAM. Running two-dimensional cases, such as "cavity", does not alter the dimensionality of vectors, but prevent solving the equations in one of the directions, which is identified by the keyword empty in the boundary conditions.
Each of the "variable" files contain:
1. the physical dimension of the variable, in units of the Internation System (second, metre, kilogram, ampere, kelvin, mole, candela). Note that each scalar or vector field is defined with its dimensions. Nonetheless, it is always possible to use OpenFOAM using "dimensionless" variables giving scaled values (as in this example).
2. the value of the variable in the domain (internalField). In this example, the fluid is at rest at t=0.
3. the boundary conditions, defined for each of the "boundaries" created in blockMesh.

Physical properties of the fluid, such as viscosity and density, are set in the dictionary transportProperties in the constant folder (in this case, only the kinematic viscosity is needed).


### 2.5 General settings
In every OpenFOAM case, three files in the system folder determine general settings of the simulation:
1. The file controlDict. In this file, you can specify: start and end times of the simulation, time interval and output frequency, format and precision. In this example, the simulation will start at t=0 and end at t=0.5, using a time interval of 0.005 and writing a full outpost in ASCII format every 20 time steps. For more information on the specific parameters, I recommend consulting the [user guide](https://cfd.direct/openfoam/user-guide/v6-controldict/).
2. The file fvSchemes. In this file, you can specify numerical schemes for the approximation of each derivate and the interpolation. In particular, the choice of the numerical scheme for the time derivate (ddtSchemes) determines if the simulation is of a steady-state solution (setting steadyState) or time-dependent (setting, for example, Euler). Note that it is possible to set a default scheme as well as specific ones for any variable.
3. The file fvSolution. In this file, you can specify the iterative solvers used for matrix inversion as well as the number of specific settings of the algorithm used by the application (in this example, the *icoFoam* solver will use the [PISO algorithm](https://openfoamwiki.net/index.php/OpenFOAM_guide/The_PISO_algorithm_in_OpenFOAM) to solve the incompressible Navier-Stokes equation). 

### 2.6 Run and (simple) post-processing
To run the simulation, assuming that boundary and initial conditions are correct, as well as physical parameters and numerical settings, means to use the proper application. In this tutorial, you can simply use:
> icoFoam  

The log contains, for each time step:
1. the mean and maximum Courant number.
2. the residual and number of iterations for each of the iterative solvers. In particular, for the two components of the velocity and the pressure. The number of solution for the pressure (two, in this example) are the number of corrections of the PISO algorithm.
3. the estimate of the continuity error.
4. the time elapsed from the beginning of the simulation.

The tutorial cavity with its default settings will create an outpost at five times (0.1, 0.2, 0.3, 0.4 and 0.5), which you can see after running the simulation.

### Additional material:
If you are interested in OpenFOAM, take advantage of the documentation available online. In particular, I recommend the official websites of different distributions of the code, such as [OpenFOAM foundation](https://openfoam.org/resources/) and [ESI-OpenCFD](https://openfoam.com/documentation/). You may also find of great interest tutorials created by consultants such as [Wolf Dynamics](http://www.wolfdynamics.com/tutorials.html).

## 3 Running your second case (with post-processing)




#!/bin/sh

. $WM_PROJECT_DIR/bin/tools/RunFunctions
application=$(getApplication)

runApplication foamCleanTutorials

runApplication blockMesh

runApplication decomposePar

runParallel $application

runApplication reconstructPar

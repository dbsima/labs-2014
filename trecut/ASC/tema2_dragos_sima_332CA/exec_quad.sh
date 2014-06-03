#!/bin/bash

module load libraries/atlas-3.10.1-gcc-4.4.6-nehalem
module load libraries/atlas-3.10.1-gcc-4.4.6-opteron
module load libraries/atlas-3.10.1-gcc-4.4.6-quad 

#make clean

[[ -z $COMPILER ]] && COMPILER="gcc"

if [[ $COMPILER="gcc" ]]; then
	make compile3 && make run3
fi

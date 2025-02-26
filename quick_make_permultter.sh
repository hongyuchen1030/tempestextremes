#!/bin/sh

./remove_depend.sh 
make clean

module load cray-hdf5
module load cray-netcdf

make

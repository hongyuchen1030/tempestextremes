#!/bin/bash

#
# This script cleans and rebuilds the tempestextremes project.
# The project’s source directory is "/global/homes/h/hyvchen/tempestextremes", and
# the CMake build files are always written to that directory.
#
# To change the build options, simply edit the variables below.
# (You cannot change the fact that the build files are written to the source directory.)

# ===== Configuration Options (Edit these as needed) =====
BUILD_TYPE="Debug"   # Options: "Debug" or "Release"
ENABLE_MPI="ON"      # Options: "ON" or "OFF"
# ==========================================================

./remove_depend.sh

# Load required modules for NetCDF and HDF5
echo "Loading required modules..."
module load cray-hdf5
module load cray-netcdf

# Define the source directory (which is also the build directory)
SRC_DIR="/global/homes/h/hyvchen/tempestextremes"

# Change to the source directory
cd "$SRC_DIR" || { echo "Source directory not found: $SRC_DIR"; exit 1; }

# Clean up any previous CMake configuration artifacts
echo "Cleaning up previous CMake artifacts in ${SRC_DIR}..."
rm -rf CMakeCache.txt CMakeFiles Makefile cmake_install.cmake

# Configure the project with CMake (in-source build)
# Use -O0 to disable optimizations and -g to include debug symbols.
echo "Configuring project with CMake..."
cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
      -DCMAKE_CXX_FLAGS_DEBUG="-O0 -g" \
      -DENABLE_MPI=${ENABLE_MPI} .

if [ $? -ne 0 ]; then
  echo "CMake configuration failed. Exiting."
  exit 1
fi

# Build and install the project
echo "Building and installing the project..."
make && make install

if [ $? -ne 0 ]; then
  echo "Build or installation failed. Exiting."
  exit 1
fi

echo "Build and installation completed successfully."

# mystran
# compile with gfortran under win 10@64
# 20250110
# by ceanwang@gmail.com

cmake_minimum_required (VERSION 3.2)
project (bjMystran)
enable_language(Fortran)

option(BUILD_WITH_SUPERLU "Set ON if you build Mystran with SuperLU" ON)
option(BUILD_WITH_LAPACK3 "Set ON if you build Mystran with Lapack" OFF)

set(EXECUTABLE_OUTPUT_PATH "bin")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "lib")
set(CMAKE_Fortran_MODULE_DIRECTORY "mod")

link_directories("lib")

#set (CMAKE_Fortran_FLAGS "-fcheck=all")

include_directories("Source/INCLUDE" "superlu/SRC" "superlu/CBLAS" "lapack-3.11.0/LAPACKE/include")

if (BUILD_WITH_SUPERLU)
	file(GLOB_RECURSE CBLAS_FILES "superlu/CBLAS/*.c")
	add_library(bjCBLAS ${CBLAS_FILES})

	# get all *.c files recursively
	file(GLOB_RECURSE c_FILES "superlu/SRC/*.c")
	add_library(bjSuperLU ${c_FILES} "superlu/FORTRAN/c_fortran_dgssv.c")
	target_link_libraries (bjSuperLU bjCBLAS)
endif (BUILD_WITH_SUPERLU)

# get all *.f90 and *f files recursively
file(GLOB_RECURSE Modules_ARPACK_FILES "Source/Modules/ARPACK/*.f")
file(GLOB_RECURSE Modules_BANDIT_FILES "Source/Modules/BANDIT/*.f*")
file(GLOB_RECURSE Modules_LAPACK_FILES "Source/Modules/LAPACK/*.f")
file(GLOB_RECURSE Modules_FILES "Source/Modules/*.f90")
file(GLOB_RECURSE Interfaces_FILES "Source/Interfaces/*.f90")
file(GLOB_RECURSE USE_IFs_FILES "Source/USE_IFs/*.f90")
file(GLOB_RECURSE UTIL_FILES "Source/UTIL/*.f90")
add_library(bjMOD ${USE_IFs_FILES} ${Modules_BANDIT_FILES} ${Interfaces_FILES} ${Modules_FILES} ${Modules_LAPACK_FILES} ${Modules_ARPACK_FILES} ${UTIL_FILES})

if (BUILD_WITH_LAPACK3)
	#file(GLOB_RECURSE BLAS_FILES "lapack-3.11.0/BLAS/SRC/*.f*")
	#add_library(bjBLAS ${BLAS_FILES})
    add_subdirectory(lapack-3.11.0)
else (BUILD_WITH_LAPACK3)
    file(GLOB_RECURSE BLAS_FILES "Source/BLAS/*.f")
    add_library(blas ${BLAS_FILES})
    target_link_libraries (blas bjMOD)
endif (BUILD_WITH_LAPACK3)

file(GLOB_RECURSE ARPACK_FILES "Source/ARPACK/*.f90")
add_library(bjARPACK ${ARPACK_FILES})
target_link_libraries (bjARPACK bjMOD)

file(GLOB_RECURSE EMG_FILES "Source/EMG/*.f90")
add_library(bjEMG ${EMG_FILES})
if (BUILD_WITH_LAPACK3)
    target_link_libraries (bjEMG blas bjMOD)
else (BUILD_WITH_LAPACK3)
    target_link_libraries (bjEMG bjMOD)
endif (BUILD_WITH_LAPACK3)

file(GLOB_RECURSE LK1_FILES "Source/LK1/*.f90")
add_library(bjLK1 ${LK1_FILES})
target_link_libraries (bjLK1 bjMOD)

file(GLOB_RECURSE LK2_FILES "Source/LK2/*.f90")
add_library(bjLK2 ${LK2_FILES})
target_link_libraries (bjLK2 bjMOD)

file(GLOB_RECURSE LK3_FILES "Source/LK3/*.f90")
add_library(bjLK3 ${LK3_FILES})
target_link_libraries (bjLK3 bjMOD)

file(GLOB_RECURSE LK4_FILES "Source/LK4/*.f90")
add_library(bjLK4 ${LK4_FILES})
target_link_libraries (bjLK4 bjMOD)

file(GLOB_RECURSE LK5_FILES "Source/LK5/*.f90")
add_library(bjLK5 ${LK5_FILES})
target_link_libraries (bjLK5 bjMOD)

file(GLOB_RECURSE LK6_FILES "Source/LK6/*.f90")
add_library(bjLK6 ${LK6_FILES})
target_link_libraries (bjLK6 bjMOD)

file(GLOB_RECURSE LK9_FILES "Source/LK9/*.f90")
add_library(bjLK9 ${LK9_FILES})
target_link_libraries (bjLK9 bjMOD)

file(GLOB_RECURSE MAIN_FILES "Source/MAIN/*.f90")
add_executable(bjMystran ${MAIN_FILES} ${USE_IFs_FILES} ${Interfaces_FILES} ${Modules_FILES} ${Modules_LAPACK_FILES} ${Modules_ARPACK_FILES} ${UTIL_FILES})
if (BUILD_WITH_LAPACK3)
    target_link_libraries (bjMystran bjARPACK bjLK1 bjLK2 bjLK3 bjLK4 bjLK5 bjLK6 bjLK9 bjEMG bjSuperLU blas)
else (BUILD_WITH_LAPACK3)
    target_link_libraries (bjMystran bjARPACK bjLK1 bjLK2 bjLK3 bjLK4 bjLK5 bjLK6 bjLK9 bjEMG bjSuperLU)
endif (BUILD_WITH_LAPACK3)

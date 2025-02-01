@echo off

REM -----------------------------------------
REM WIN64 build file for MYSTRAN with gcc for win
REM by ceanwang@gmail.com
REM -----------------------------------------

MKDIR build_win10n
CD build_win10n
cmake -G "Ninja" .. -DCMAKE_Fortran_COMPILER=gFortran
rem make

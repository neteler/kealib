
:: Builds static kealib. Run this after buildzlibhdf5.bat
:: Ensure INSTALLDIR is set the same as buildzlibhdf5.bat - hdf5 etc read from here 
:: and static kealib installed there.

set INSTALLDIR=c:\dev\arckea
:: Stop PATH getting too long by resetting it
set oldpath=%PATH%

:: Visual Studio 2008 x86
SetLocal
set VCYEAR=VC2008
set VCMACH=x86
set PATH=%oldpath%
call "C:\Users\sam\AppData\Local\Programs\Common\Microsoft\Visual C++ for Python\9.0\vcvarsall.bat" %VCMACH%
@echo on
call :build
EndLocal

:: Visual Studio 2013 x86 and x64
SetLocal
set VCYEAR=VC2013
set VCMACH=x86
set PATH=%oldpath%
call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" %VCMACH%
@echo on
call :build
EndLocal

SetLocal
set VCYEAR=VC2013
set VCMACH=x64
:: Note VS2013 doesn't understand 'x64'...
set PATH=%oldpath%
call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" x86_amd64
@echo on
call :build
EndLocal

:: Visual Studio 2015 for ArcPro <= 2.0
SetLocal
set VCYEAR=VC2015
set VCMACH=x64
set PATH=%oldpath%
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" %VCMACH%
@echo on
call :build
EndLocal

:: Visual Studio 2017 for ArcPro 2.1 and ArcGIS 10.6
SetLocal
set VCYEAR=VC2017
set VCMACH=x86
set PATH=%oldpath%
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" %VCMACH%
@echo on
call :build
EndLocal

SetLocal
set VCYEAR=VC2017
set VCMACH=x64
set PATH=%oldpath%
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" %VCMACH%
@echo on
call :build
EndLocal

EXIT /B %ERRORLEVEL%

:build

set BUILDDIR=build_%VCYEAR%_%VCMACH%
set VCINSTALLDIR=%INSTALLDIR%\%VCYEAR%_%VCMACH%

mkdir %BUILDDIR%
cd %BUILDDIR%

del ..\..\CMakeCache.txt
cmake -D BUILD_SHARED_LIBS=OFF ^
	  -D HDF5_USE_STATIC_LIBRARIES=ON ^
      -D CMAKE_INSTALL_PREFIX=%VCINSTALLDIR% ^
	  -D CMAKE_PREFIX_PATH=%VCINSTALLDIR% ^
      -D CMAKE_BUILD_TYPE=Release ^
      -G "NMake Makefiles" ^
      ..\..
if errorlevel 1 exit /B 1
nmake install
if errorlevel 1 exit /B 1      

cd ..
rmdir /s /q %BUILDDIR%

EXIT /B 0

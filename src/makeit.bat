@echo off

echo Assembling briefingcore.asm...
tools\vasm -quiet -devpac -no-opt -Fhunk -o briefingcore/briefingcore.o briefingcore/briefingcore.asm
if errorlevel 1 goto error
tools\vlink -S -s -o ../game/briefingcore briefingcore/briefingcore.o
if errorlevel 1 goto error

echo Assembling briefingstart.asm...
tools\vasm -quiet -devpac -no-opt -Fhunk -o briefingstart/briefingstart.o briefingstart/briefingstart.asm
if errorlevel 1 goto error
tools\vlink -S -s -o ../game/briefingstart briefingstart/briefingstart.o
if errorlevel 1 goto error

echo Assembling end.asm...
tools\vasm -quiet -devpac -no-opt -Fhunk -o end/end.o end/end.asm
if errorlevel 1 goto error
tools\vlink -S -s -o ../game/end end/end.o
if errorlevel 1 goto error

echo Assembling gameover.asm...
tools\vasm -quiet -devpac -no-opt -Fhunk -o gameover/gameover.o gameover/gameover.asm
if errorlevel 1 goto error
tools\vlink -S -s -o ../game/gameover gameover/gameover.o
if errorlevel 1 goto error

echo Assembling intex.asm...
tools\vasm -quiet -devpac -no-opt -Fhunk -o intex/intex.o intex/intex.asm
if errorlevel 1 goto error
tools\vlink -S -s -o ../game/intex intex/intex.o
if errorlevel 1 goto error

echo Assembling menu.asm...
tools\vasm -quiet -devpac -no-opt -Fhunk -o menu/menu.o menu/menu.asm
if errorlevel 1 goto error
tools\vlink -S -s -o ../game/menu menu/menu.o
if errorlevel 1 goto error

echo Assembling story.asm...
tools\vasm -quiet -devpac -no-opt -Fhunk -o story/story.o story/story.asm
if errorlevel 1 goto error
tools\vlink -S -s -o ../game/story story/story.o
if errorlevel 1 goto error

echo Assembling main.asm...
tools\vasm -quiet -devpac -no-opt -Fhunk -o main/main.o main/main.asm
if errorlevel 1 goto error
tools\vlink -S -s -o ../game/main main/main.o
if errorlevel 1 goto error

del briefingstart\briefingstart.o
del briefingcore\briefingcore.o
del intex\intex.o
del end\end.o
del story\story.o
del menu\menu.o
del gameover\gameover.o
del main\main.o

echo Done.

:error

@echo off

echo Creating "briefingcore" executable into "game" folder...
tools\vasm -quiet -devpac -no-opt -Fhunk -I src -I src/sys_include -I src/briefingcore/gfx -I src/common -o src/briefingcore/briefingcore.o src/briefingcore/briefingcore.asm
if errorlevel 1 goto error
tools\vlink -S -s -o game/briefingcore src/briefingcore/briefingcore.o
if errorlevel 1 goto error

echo Creating "briefingstart" executable into "game" folder...
tools\vasm -quiet -devpac -no-opt -Fhunk -I src -I src/sys_include -I src/briefingstart/gfx -I src/common -o src/briefingstart/briefingstart.o src/briefingstart/briefingstart.asm
if errorlevel 1 goto error
tools\vlink -S -s -o game/briefingstart src/briefingstart/briefingstart.o
if errorlevel 1 goto error

echo Creating "end" executable into "game" folder...
tools\vasm -quiet -devpac -no-opt -Fhunk -I src -I src/sys_include -I src/end/gfx -I src/common -o src/end/end.o src/end/end.asm
if errorlevel 1 goto error
tools\vlink -S -s -o game/end src/end/end.o
if errorlevel 1 goto error

echo Creating "gameover" executable into "game" folder...
tools\vasm -quiet -devpac -no-opt -Fhunk -I src -I src/sys_include -I src/gameover/anim -I src/common -o src/gameover/gameover.o src/gameover/gameover.asm
if errorlevel 1 goto error
tools\vlink -S -s -o game/gameover src/gameover/gameover.o
if errorlevel 1 goto error

echo Creating "intex" executable into "game" folder...
tools\vasm -quiet -devpac -no-opt -Fhunk -I src -I src/sys_include -I src/intex/gfx -I src/common -o src/intex/intex.o src/intex/intex.asm
if errorlevel 1 goto error
tools\vlink -S -s -o game/intex src/intex/intex.o
if errorlevel 1 goto error

echo Creating "menu" executable into "game" folder...
tools\vasm -quiet -devpac -no-opt -Fhunk -I src -I src/sys_include -I src/menu/gfx -I src/common -o src/menu/menu.o src/menu/menu.asm
if errorlevel 1 goto error
tools\vlink -S -s -o game/menu src/menu/menu.o
if errorlevel 1 goto error

echo Creating "story" executable into "game" folder...
tools\vasm -quiet -devpac -no-opt -Fhunk -I src -I src/sys_include -I src/story/gfx -I src/common -o src/story/story.o src/story/story.asm
if errorlevel 1 goto error
tools\vlink -S -s -o game/story src/story/story.o
if errorlevel 1 goto error

echo Creating "main" executable into "game" folder...
tools\vasm -quiet -devpac -no-opt -Fhunk -I src -I src/sys_include -I src/main/gfx -I src/main/sprites -I src/main/voices -I src/main/samples -I src/common -o src/main/main.o src/main/main.asm
if errorlevel 1 goto error
tools\vlink -S -s -o game/main src/main/main.o
if errorlevel 1 goto error

del src\briefingstart\briefingstart.o
del src\briefingcore\briefingcore.o
del src\intex\intex.o
del src\end\end.o
del src\story\story.o
del src\menu\menu.o
del src\gameover\gameover.o
del src\main\main.o

echo Done.

:error

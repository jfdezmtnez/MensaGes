@echo off

rem Turbo Pascal  Version 7.0  Copyright (c) 1983,92 Borland International
rem Syntax: TPC [options] filename [options]
rem   -B = Build all units                -L = Link buffer on disk
rem   -D<syms> = Define conditionals      -M = Make modified units
rem   -E<path> = EXE/TPU directories      -O<path> = Object directories
rem   -F<seg>:<ofs> = Find error          -Q = Quiet compile
rem   -GD = Detailed map file             -T<path> = TPL/CFG directory
rem   -GP = Map file with publics         -U<path> = Unit directories
rem   -GS = Map file with segments        -V = Debug information in EXE
rem   -I<path> = Include directories      -$<dir> = Compiler directive
rem Compiler switches: -$<letter><state>  (defaults are shown below)
rem   A+ Word alignment       I+ I/O error checking   R- Range checking
rem   B- Full boolean eval    L+ Local debug symbols  S+ Stack checking
rem   D+ Debug information    N- 80x87 instructions   T- Typed pointers
rem   E+ 80x87 emulation      O- Overlays allowed     V+ Strict var-strings
rem   F- Force FAR calls      P- Open string params   X+ Extended syntax
rem   G- 80286 instructions   Q- Overflow checking
rem Memory sizes: -$M<stack>,<heapmin>,<heapmax>  (default: 16384,0,655360)


set road=d:\mensages\units2
set options=-$A+ -$B- -$D- -$E+ -$F- -$G+ -$I+ -$L- -$N- -$O-
set options2=-$P+ -$Q- -$R- -$S+ -$T- -$V+ -$X-

rem memory para casos especiales
rem set memory=-$M32768,0,655360

set memory=-$M16338,0,655360
set mem=-$m32768,0,655360
set include=-Id:\tp7\include
set units=-U%road%
set destiny=-E%road% -GD

timer > nul

d:\tp7\tpc %include% %units% %destiny% defs.pas %options%options2% %memory%
d:\tp7\tpc %include% %units% %destiny% errtrap.pas %options%options2% %memory%
d:\tp7\tpc %include% %units% %destiny% facturas.pas %options%options2% %memory%
d:\tp7\tpc %include% %units% %destiny% common.pas %options%options2% %memory%
d:\tp7\tpc %include% %units% %destiny% graficos.pas %options%options2% %memory%
d:\tp7\tpc %include% %units% %destiny% campstru.pas %options%options2% %memory%
d:\tp7\tpc %include% %units% %destiny% ficheros.pas %options%options2% %memory%
d:\tp7\tpc %include% %units% %destiny% gets.pas %options%options2% %memory%
d:\tp7\tpc %include% %units% %destiny% formulas.pas %options%options2% %memory%
d:\tp7\tpc %include% %units% %destiny% puts.pas %options%options2% %memory%
d:\tp7\tpc %include% %units% %destiny% tfnomem.pas %options%options2% %memory%
d:\tp7\tpc %include% %units% %destiny% config.pas %options%options2% %memory%
d:\tp7\tpc %include% %units% %destiny% print.pas %options%options2% %memory%
d:\tp7\tpc %include% %units% %destiny% albaran.pas %options%options2% %memory%
d:\tp7\tpc %include% %units% %destiny% messager.pas %options%options2% %memory%
d:\tp7\tpc %include% %units% %destiny% comercia.pas %options%options2% %memory%
d:\tp7\tpc %include% %units% %destiny% stats.pas %options%options2% %memory%
d:\tp7\tpc %include% %units% %destiny% cliente.pas %options%options2% %memory%
d:\tp7\tpc %include% %units% %destiny% screens.pas %options%options2% %memory%
d:\tp7\tpc %include% %units% %destiny% protect.pas %options%options2% %memory%
d:\tp7\tpc %include% %units% %destiny% mensages.pas %options%options2% %mem%
d:\tp7\tpc %include% %units% %destiny% INSTALAR.pas %options%options2% %memory%

timer > nul

move d:\mensages\units2\mensages.exe d:\mensages > nul

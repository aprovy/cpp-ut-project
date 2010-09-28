
           cpp-ut-project Introduction

		   
User Guide
========== 
  
  This is a C/C++ ut/it/st sample project, using testngpp,mockcpp and premake. It aims at making C/C++ test harmless and full of fun. With it, you can add file/tests easily, can compile and run in only one script. You can use this project following these steps.

1 Compile testngpp and mockcpp, put the installed files in tools, see also the structure of dir.

2 Download premake.(one exe file around 200 bytes.)

3 Run cmd, change to the UserModule dir, run "premake4 vs2005".

4 Open the .sln/vcproj with Visual Studio 2005 in project dir.

3 Install PowerShell. (If you want to use add class/test function, you need it.)


premake VS. cmake
=================

1 premake can add all the *.cpp/*.h to vcproj easily, it's very usefull for editing.

2 premake and can be used on machines without compilers installed. (sometimes, cmake report unintelligible errors about compiler.)

3 premake use lua language to write the script.

4 premake is much smaller.

5 premake also can be used on many platforms, such as linux/Mac OS etc., and it seems that premake support 64 bit platform much better.


Contact
===========
Project :  http://code.google.com/p/cpp-ut-project/, 
Author  :  Chen Guodong<sinojelly@gmail.com>



See Also
===========

testngpp : http://code.google.com/p/test-ng-pp/

mockcpp  : http://code.google.com/p/mockcpp/

premake    : http://industriousone.com/premake


The directory structure of cpp-ut-project :

D:.
©À©¤project
©À©¤tools
©¦  ©À©¤3rdparty
©¦  ©¦  ©À©¤boost
©¦  ©¦  ©¸©¤mem_checker
©¦  ©À©¤mockcpp
©¦  ©¦  ©À©¤include
©¦  ©¦  ©¸©¤lib
©¦  ©À©¤scripts
©¦  ©¸©¤testngpp
©¦      ©À©¤bin
©¦      ©À©¤include
©¦      ©À©¤lib
©¦      ©¸©¤testngpp
©¦          ©À©¤generator
©¦          ©¸©¤listener
©¸©¤UserModule
    ©À©¤include
    ©¦  ©¸©¤UserModule
    ©À©¤src
    ©¸©¤test
			
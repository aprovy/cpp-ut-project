
           cpp-ut-project Introduction ( V1.1 )

		   
User Guide
========== 
  
  This is a C/C++ test sample project, using testngpp, mockcpp and premake. It aims at making C/C++ test harmless and full of fun. 
  
  This project not only can generate project files, but also can create .h/.cpp/test files for class/feature, run "premake4 --usage addfile" to show more.

  Before you use this project, be sure about that you have compiled testngpp and mockcpp, and have put the installed files in tools, see also the structure of dir.
  
  And then you can use this project following these steps.  
  
Windows
-------  
1 Run cmd, change to the UserModule dir, run "premake4 vs2005". (or use "premake4 --nomemcheck vs2005" to generate project without memchecker)

2 Change to ../build/vs2005 dir, use the .sln/vcproj.

Linux
-----
1 Install premake4.( Copy the file in tools/bin to /usr/local/bin)

2 Run cmd, change to the UserModule dir, run "premake4 gmake". (or use "premake4 --nomemcheck gmake" to generate project without memchecker)

3 Change to ../build/gmake dir, run "make all".

premake VS. cmake
=================

1 premake can add all the *.cpp/*.h to vcproj easily, it's very usefull for editing.

2 premake can be used on machines without compilers installed. (sometimes, cmake report unintelligible errors about compiler.)

3 premake use lua language to write the script. (lua is simple and powerfull.)

4 premake is much smaller. (one exe file around 200 bytes.)

5 premake also can be used on many platforms, such as linux/Mac OS etc., and it seems that premake support 64 bit platform much better.


Contact
===========
Project :  http://code.google.com/p/cpp-ut-project/, 
Author  :  Chen Guodong<sinojelly@gmail.com>



See Also
===========

testngpp : http://code.google.com/p/test-ng-pp/

mockcpp  : http://code.google.com/p/mockcpp/

premake  : http://industriousone.com/premake


The directory structure of cpp-ut-project :

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
			
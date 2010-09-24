
           cpp-ut-project Introduction

		   
User Guide
========== 
  
  This is a C/C++ ut/it/st sample project, using testngpp,mockcpp and cmake. It aims at making C/C++ test harmless and full of fun. With it, you can add file/tests easily, can compile and run in only one script. You can use this project following these steps.

1 Compile testngpp and mockcpp, put the installed files in tools, see also the structure of dir.

2 Install CMake.(or download green version)

3 Install PowerShell. (Windows 7 support it as default)

4 Go to the cpp-ut-project dir, run build.ps1 .


Contact
===========
Project :  http://code.google.com/p/cpp-ut-project/, 
Author  :  Chen Guodong<sinojelly@gmail.com>



See Also
===========

testngpp : http://code.google.com/p/test-ng-pp/

mockcpp  : http://code.google.com/p/mockcpp/

cmake    : http://www.cmake.org


The directory structure of cpp-ut-project :

D:.
����.hg
��  ����store
����include
��  ����module_name
����project
����src
����test
����tools
    ����3rdparty
    ��  ����boost
    ��  ����mem_checker
    ����mockcpp
    ��  ����include
    ��  ����lib
    ����testngpp
        ����bin
        ����include
        ����lib
        ����testngpp
            ����generator
            ����listener

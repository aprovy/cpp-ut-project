cpp-ut-project更新记录

#labels Featured
#这是cpp-ut-project的更新历史

## 2010.11 ##

1、支持命令行使用addfile动作自动添加文件。
```
premake4 --usage addfile

Usage:
add .h file for class : premake4 --class=ClassName addfile
add .h and .cpp file for class : premake4 --class=ClassName --cpp addfile
add .h and .cpp and test file for class : premake4 --class=ClassName --test addfile
add test file for feature : premake4 --feature=FeatureName addfile
```

## 2011.03.24 ##

1、支持测试工程、被测工程默认自动包含内存泄露检查头文件interface\_4user.h，以便打印出导致内存泄露的位置。（Windows和Linux都已支持）。

注意：
> 某些系统文件如果在interface\_4user.h之后包含，new/delete/malloc/free被替换，可能报告编译错误。解决办法就是在interface\_4user.h中提前包含会引起错误的系统头文件。

2、如果希望生成不包含内存泄露检查头文件的工程（非测试目的的工程往往都是这样的），可以用类似premake4 --nomemcheck vs2008这样的命令来生成工程。

## 2011.03.26 ##

> Release 1.1

## 2011.04.17 ##

在Windows下，支持按mockcpp-windows7-vs2008.lib这样的命名（都是小写字母），来达到不同平台下都能够找到正确的文件的目的。

注意：由于使用了os.getversion()获取OS版本，需要使用较新的premake4.exe，当前发现只有dev分支的最新代码编译的premake4.exe能支持，stable分支最新版本都不能支持。

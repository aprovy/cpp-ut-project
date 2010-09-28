--usage: in the command line , run the cmd: premake4 vs2005
solution "Worker"
   configurations { "Debug", "Release" }
   language "C++"
   location ("../project")
 
   project "Worker"
      kind "StaticLib"
      files {"src/**.cpp", "include/UserModule/**.h"}      
	  targetdir ("../project/lib")
	  includedirs { "include" }
	  objdir ("../project/obj/Worker")
 
   project "UT_Worker"
      kind "SharedLib"
      files {"../project/test/**.cpp", "test/**.h"}
	  targetdir ("../project/dll")
	  targetname ("UT_Worker")
	  links { "Worker", "testngpp", "mockcpp" }	  
	  includedirs { "include", "../tools/testngpp/include", "../tools/mockcpp/include", "../tools/3rdparty"}
	  libdirs { "../project/lib", "../tools/testngpp/lib", "../tools/mockcpp/lib"}
	  buildoptions { "/Zm1000", "/vmg", "/MDd", "/Zi" }
	  defines { "WIN32", "_WINDOWS", "_DEBUG" }
	  linkoptions { "/DEBUG"}	  
	  objdir ("../project/obj/UT_Worker")
	  -- TODO: how to detect UT_*.h automaticly?
	  --prebuildcommands { "python.exe ../tools/testngpp/testngpp/generator/testngppgen.pyc -e gb2312 -o ../project/test/AutoGenerator.cpp test/UT_HelloWorld.h test/IT_HelloWorld.h" }
	  local test_generator = "../tools/testngpp/testngpp/generator/testngppgen.pyc"
	  local file_encode = "-e gb2312"
	  local cpp_generated = "-o ../project/test/AutoGenerator.cpp"
	  local test_file = "test/UT_HelloWorld.h test/IT_HelloWorld.h"
	  local cmd_line = string.format("python.exe %s %s %s %s", test_generator, file_encode, cpp_generated, test_file)	  
	  prebuildcommands { cmd_line }
	  
	  
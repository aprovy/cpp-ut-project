--usage: in the command line , run the cmd: premake4 vs2005, and then use the .sln and .vcproj in ../project dir.

module_name = "UserModule"

solution (string.format("%s", module_name))
   configurations { "Debug", "Release" }
   language "C++"
   location ("../project")
 
   project (string.format("%s", module_name))
      kind "StaticLib"
      files {"src/**.cpp", string.format("include/%s/**.h", module_name)}      -- i think, all paths except path in prebuildcommands are relative to the premake run dir 
	  targetdir ("../project/lib")
	  includedirs { "include" }
	  objdir (string.format("../project/obj/%s", module_name))
 
   project (string.format("Test%s", module_name))
      kind "SharedLib"
      files {"../project/test/**.cpp", "test/**.h"}
	  targetdir ("../project/dll")
	  targetname (string.format("Test%s", module_name))
	  links { module_name, "testngpp", "mockcpp" }	  
	  includedirs { "include", "../tools/testngpp/include", "../tools/mockcpp/include", "../tools/3rdparty"}
	  libdirs { "../project/lib", "../tools/testngpp/lib", "../tools/mockcpp/lib"}
	  buildoptions { "/Zm1000", "/vmg", "/MDd" }
	  defines { "WIN32", "_WINDOWS", "_DEBUG" }
	  linkoptions { "/DEBUG"}	  
	  flags { "Symbols", "NoManifest" }
	  objdir (string.format("../project/obj/Test%s", module_name))
	  -- TODO: how to detect UT_*.h automaticly?
	  --prebuildcommands { "python.exe ../tools/testngpp/testngpp/generator/testngppgen.pyc -e gb2312 -o ../project/test/AutoGenerator.cpp test/UT_HelloWorld.h test/IT_HelloWorld.h" }
	  os.mkdir("../project/test")  -- or else, generate .cpp failure.
	  local test_generator = "../tools/testngpp/testngpp/generator/testngppgen.pyc"
	  local file_encode = "-e gb2312"
	  local cpp_generated = "-o ../project/test/AutoGenerator.cpp"
	  local test_file = string.format("../%s/test/UT_HelloWorld.h ../%s/test/IT_HelloWorld.h", module_name, module_name)
	  local cmd_line = string.format("python.exe %s %s %s %s", test_generator, file_encode, cpp_generated, test_file)	  
	  prebuildcommands { cmd_line }
	  
	  
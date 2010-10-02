--usage: in the command line , run the cmd: premake4 vs2005, and then use the .sln and .vcproj in ../project dir.
--       after adding .h/.cpp or tests, rerun the cmd premake4 vs2005, it will generate new .sln .vcproj including new files.

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
      -- ===========================================
	  -- make test cpp file dir.
      local test_dir = "../project/test"
      os.mkdir(test_dir)  -- or else, generate .cpp failure.
	  -- ===========================================
	  -- generate cpp file for each test .h file, and register it as prebuildcommand.
	  local test_hfiles = os.matchfiles("test/**.h")
	  local test_files = ""
	  for _, v in ipairs(test_hfiles) do		
		test_files = test_files..string.format("../%s/%s ", module_name, v)
	  end
	  local test_generator = "python ../tools/testngpp/testngpp/generator/testngppgen.pyc"
	  if os.is("windows") then 
	    test_generator = "..\\tools\\testngpp\\bin\\testngppgen.exe"
	  end
	  local file_encode = "-e gb2312"
	  local cpp_generated = "-d ../project/test"	  
	  local cmd_line = string.format("%s %s %s %s", test_generator, file_encode, cpp_generated, test_files)
	  os.executef(cmd_line) -- generate .cpp file at the first running, in order to include it in vcproj.
	  prebuildcommands { cmd_line }
	  -- ===========================================
	  -- project configuration
      kind "SharedLib"
      files {"../project/test/**.cpp", "test/**.h"}
	  local dll_dir = "../project/dll"
	  targetdir ("../project/dll")
	  local dll_name = string.format("Test%s", module_name)
	  targetname (dll_name)
	  links { module_name, "testngpp", "mockcpp" }	  
	  includedirs { "include", "../tools/testngpp/include", "../tools/mockcpp/include", "../tools/3rdparty"}
	  libdirs { "../project/lib", "../tools/testngpp/lib", "../tools/mockcpp/lib"}
	  if os.is("windows") then 
	    buildoptions { "/Zm1000", "/vmg", "/MDd" }
	    defines { "WIN32", "_WINDOWS", "_DEBUG" }
	    linkoptions { "/DEBUG"}	  
	    flags { "Symbols", "NoManifest" }
      end
	  objdir (string.format("../project/obj/Test%s", module_name))	  
	  -- ===========================================
	  -- run test dlls
	  local testngpp_runner = "../tools/testngpp/bin/testngpp-runner"
	  if os.is("windows") then 
	    testngpp_runner = "..\\tools\\testngpp\\bin\\testngpp-runner.exe" 
	  end
	  local test_dll_list = os.matchfiles(dll_dir.."/**.so")
      if os.is("windows") then
        test_dll_list = os.matchfiles(dll_dir.."/**.dll")
      end
	  local test_dlls = ""
	  for _, v in ipairs(test_dll_list) do		
          if os.is("windows") then
		    test_dlls = test_dlls..string.sub(v, 1, -5).." "
          else
		    test_dlls = test_dlls..string.sub(v, 1, -4).." "
	      end
      end
      if test_dlls == "" then  -- at first time, dll/so not exist, generate correct cmd line
        if os.is("windows") then
	      test_dlls = dll_dir.."/"..dll_name    
	    else
	      test_dlls = dll_dir.."/lib"..dll_name   
	    end
	  end
	  local listener_dirs = '-L"../tools/testngpp/testngpp/listener"'
	  local listeners = '-l"testngppstdoutlistener -c -v"'
	  local test_options = "" --  -s
	  local run_tests = string.format("%s %s %s %s %s", testngpp_runner, test_dlls, listener_dirs, listeners, test_options)
	  postbuildcommands { run_tests }
	  
	  

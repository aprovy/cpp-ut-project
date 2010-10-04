--
-- usage: in the command line , run the cmd: premake4 vs2005, and then use the .sln and .vcproj in ../build/vs2005 dir.
--       after adding .h/.cpp or tests, rerun the cmd premake4 vs2005, it will generate new .sln .vcproj including new files.
-- normal use: premake4 vs2005    and then : build in Visual Studio 2005
--             premake4 gmake     and then : make
--             premake4 gmake     and then : make config=debug
--

-- change the module name by yourself
local module_name = "UserModule"


if not _ACTION then return end


local build_dir   = "../build/".._ACTION
local test_dir    = build_dir.."/test"
local target_dir  = build_dir.."/target"
local lib_dir     = build_dir.."/lib"
local obj_dir     = build_dir.."/obj"
local target_name = "Test"..module_name


   --
   -- generate cpp file for each test .h file.
   --
   function generate_tests()  
	  local test_hfiles = os.matchfiles("test/**.h")
	  local test_files = ""
	  local test_files_run = ""
	  for _, v in ipairs(test_hfiles) do		
		test_files = test_files..string.format("../../%s/%s ", module_name, v)
		test_files_run = test_files_run..string.format("../%s/%s ", module_name, v)  -- current run dir is different from the .vcproj dir
	  end
	  local test_generator = "python ../../tools/testngpp/testngpp/generator/testngppgen.pyc "
	  local test_generator_run = "python ../tools/testngpp/testngpp/generator/testngppgen.pyc "
	  if os.is("windows") then 
	    test_generator = "..\\..\\tools\\testngpp\\bin\\testngppgen.exe "
		test_generator_run = "..\\tools\\testngpp\\bin\\testngppgen.exe "
	  end
	  local file_encode = "-e gb2312 "
	  local cpp_generated = "-d ../"..test_dir.." "	  
	  local cpp_generated_run = "-d "..test_dir.." "	  
	  os.executef(test_generator_run..file_encode..cpp_generated_run..test_files_run) -- generate .cpp file at the first running, in order to include it in vcproj.
	  return test_generator..file_encode..cpp_generated..test_files
   end
   
   --
   -- construct run tests command.
   --
   function run_tests()
   	  local testngpp_runner = "../../tools/testngpp/bin/testngpp-runner"
	  if os.is("windows") then 
	    testngpp_runner = "..\\..\\tools\\testngpp\\bin\\testngpp-runner.exe" 
	  end
	  local test_dll_list = os.matchfiles("../"..target_dir.."/**.so")
      if os.is("windows") then
        test_dll_list = os.matchfiles("../"..target_dir.."/**.dll")
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
	      test_dlls = "../"..target_dir.."/"..target_name    
	    else
	      test_dlls = "../"..target_dir.."/lib"..target_name   
	    end
	  end
	  local listener_dirs = '-L"../../tools/testngpp/testngpp/listener"'
	  local listeners = '-l"testngppstdoutlistener -c -v"'
	  local test_options = "" --  -s
	  local run_tests = string.format("%s %s %s %s %s", testngpp_runner, test_dlls, listener_dirs, listeners, test_options)
	  return run_tests
   end

   solution (module_name)
      configurations { "Debug", "Release" }
      language "C++"
      location (build_dir)
 
   project (module_name)
      location (build_dir)
      kind "StaticLib"
      files {"src/**.cpp", "include/"..module_name.."/**.h"}  
	  targetdir (lib_dir)
	  includedirs { "include" }
	  objdir (obj_dir.."/"..module_name)
 
   project ("Test"..module_name)
      location (build_dir)
	  -- ===========================================
	  -- generate cpp file for each test .h file, and register it as prebuildcommand.
	  prebuildcommands { generate_tests() }
	  
	  -- ===========================================
	  -- project configuration
      kind "SharedLib"
      files {test_dir.."/**.cpp", "test/**.h"}
	  targetdir (target_dir)
	  targetname (target_name)
	  links { module_name, "testngpp", "mockcpp" }	  
	  includedirs { "include", "../tools/testngpp/include", "../tools/mockcpp/include", "../tools/3rdparty"}
	  libdirs { lib_dir, "../tools/testngpp/lib", "../tools/mockcpp/lib"}
	  objdir (obj_dir.."/Test"..module_name)	  
	  
	  -- ===========================================
	  -- run tests
	  postbuildcommands { run_tests() }
	  
	  -- ===========================================
	  -- configuration for special platform
	  configuration {"windows"}
	    buildoptions { "/Zm1000", "/vmg", "/MDd" }
	    defines { "WIN32", "_WINDOWS", "_DEBUG" }
	    linkoptions { "/DEBUG"}	  
	    flags { "Symbols", "NoManifest" }
      	  
	  configuration {"linux", "debug"}
	    buildoptions { "-g", "-ggdb" }
	  

   
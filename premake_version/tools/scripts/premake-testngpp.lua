--
-- usage: in the command line , run the cmd: premake4 vs2005, and then use the .sln and .vcproj in ../build/vs2005 dir.
--       after adding .h/.cpp or tests, rerun the cmd premake4 vs2005, it will generate new .sln .vcproj including new files.
-- normal use: premake4 vs2005    and then : build in Visual Studio 2005
--             premake4 gmake     and then : make
--             premake4 gmake     and then : make config=debug
--
-- note: put some print("something") can debug this script.
--

if not _ACTION then return end

print("Generating test files ...")

local path_offset = path.getrelative(os.getcwd(), cwd).."/"  -- because the processed file path is relative to this premake-testngpp.lua path

function modify_path(path)
	for i,val in ipairs(path) do
		path[i] = path_offset..val
	end
end

tool_dir = path_offset..tool_dir
modify_path(include_dirs)
modify_path(librarys_dirs)
modify_path(src_files_dirs)
modify_path(test_files_dirs)

local tool_dir_win = string.gsub(tool_dir, "/", "\\")
local build_dir   = path_offset.."../build/".._ACTION
local test_dir    = build_dir.."/test"
local target_dir  = build_dir.."/target"
local lib_dir     = build_dir.."/lib"
local obj_dir     = build_dir.."/obj"
local target_name = "Test"..module_name

	function get_one_dir_tests(dir, files)
	  local test_hfiles = os.matchfiles(dir.."/"..files)
	  local test_files = ""
	  for _, v in ipairs(test_hfiles) do		
		test_files = test_files..string.format("%s ", v)
	  end
	  return test_files
	end

    function get_tests(dir_list, files)
		local test_files = ""
		local test_files_temp = ""
		for _, v in ipairs(dir_list) do
			test_files_temp = get_one_dir_tests(v, files)
			test_files = test_files..test_files_temp
		end		
		return test_files
	end
	
   --
   -- generate cpp file for each test .h file.
   --
   function generate_tests()  
	  local test_files = ""
	  test_files = get_tests(test_files_dirs, "**.h")
	  
	  local test_generator = "python "..tool_dir.."/testngpp/testngpp/generator/testngppgen.pyc "
	  if os.is("windows") then 
	    test_generator = tool_dir_win.."\\testngpp\\bin\\testngppgen.exe "
	  end
	  local file_encode = "-e gb2312 "
	  local cpp_generated = "-d "..test_dir.." "	  
	  local cmdline = test_generator..file_encode..cpp_generated..test_files
	  os.executef(cmdline) -- generate .cpp file at the first running, in order to include it in vcproj.
	  os.execute("sleep 3") -- wait until generate tests finish!
	  return cmdline  -- when remove to tools/script, they are the same.
   end
   
   --
   -- construct run tests command.
   --
   function run_tests()
   	  local testngpp_runner = tool_dir.."/testngpp/bin/testngpp-runner"
	  if os.is("windows") then 
	    testngpp_runner = tool_dir_win.."\\testngpp\\bin\\testngpp-runner.exe" 
	  end
	  local test_dll_list = os.matchfiles(target_dir.."/**.so")
      if os.is("windows") then
        test_dll_list = os.matchfiles(target_dir.."/**.dll")
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
	      test_dlls = target_dir.."/"..target_name    
	    else
	      test_dlls = target_dir.."/lib"..target_name   
	    end
	  end
	  local listener_dirs = '-L"'..tool_dir..'/testngpp/testngpp/listener"'
	  local listeners = '-l"testngppstdoutlistener -c -v"'
	  local test_options = "" --  -s
	  local run_tests = string.format("%s %s %s %s %s", testngpp_runner, test_dlls, listener_dirs, listeners, test_options)
	  return run_tests
   end
	
	function process_items (process, dirs)
		for _, v in ipairs(dirs) do 
			process {v} 
		end
	end
	
	function process_files (process, dirs, files)
		for _, v in ipairs(dirs) do 
			process {v.."/"..files} 
		end
	end

   solution (module_name)
      configurations { "Debug", "Release" }
      language "C++"
      location (build_dir)
	  flags { "Symbols" }
 
   project (module_name)
      location (build_dir)
      kind "StaticLib"
	  process_files(files, src_files_dirs, "**.cpp")
	  process_files(files, include_dirs, "**.h")
	  targetdir (lib_dir)
	  process_items(includedirs, include_dirs)
	  objdir (obj_dir.."/"..module_name)
	  
	  configuration {"windows"}
	    buildoptions { "/MDd" }
 
   project ("Test"..module_name)
      location (build_dir)
	  -- ===========================================
	  -- generate cpp file for each test .h file, and register it as prebuildcommand.
	  prebuildcommands { generate_tests() }
	  
	  -- ===========================================
	  -- project configuration
      kind "SharedLib"
      files {test_dir.."/**.cpp", test_dir.."/**.cxx"}
	  process_files(files, test_files_dirs, "**.h")
	  targetdir (target_dir)
	  targetname (target_name)
	  links { module_name, "testngpp", "mockcpp" }	  
	  process_items(links, librarys)
	  includedirs { tool_dir.."/testngpp/include", tool_dir.."/mockcpp/include", tool_dir.."/3rdparty"}
	  process_items(includedirs, include_dirs)
	  libdirs { lib_dir, tool_dir.."/testngpp/lib", tool_dir.."/mockcpp/lib" }
	  process_items(libdirs, librarys_dirs)
	  objdir (obj_dir.."/Test"..module_name)	  
	  
	  -- ===========================================
	  -- run tests
	  postbuildcommands { run_tests() }
	  
	  -- ===========================================
	  -- configuration for special platform
	  configuration {"windows"}
	    buildoptions { "/Zm1000", "/vmg", "/MDd" }
	    defines { "WIN32", "_WINDOWS", "_DEBUG", "MSVC_VMG_ENABLED"}
	    linkoptions { "/DEBUG"}	  
	    flags { "NoManifest" } 
      	  

	  

   
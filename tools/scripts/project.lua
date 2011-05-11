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
if _ACTION == "clean" then return end

local os_ver = os.getversion()
print("Platform: "..os_ver.description.."   ".._ACTION)
-- like : -windows7-vs2008 for windows 7 + vs2008
--     or -vs2008          for all windows os + vs2008
local platform_suffix = "-"..string.lower(string.gsub(os_ver.description, " ", "")).."-".._ACTION
local action_suffix   = "-".._ACTION

function copy_right_file(file)
	if os.isfile(file) then return end
     
    local platform_file = path.join(path.getdirectory(file), path.getbasename(file)..platform_suffix..path.getextension(file))
    if os.isfile(platform_file) then os.copyfile(platform_file, file) return end
     
    local action_file = path.join(path.getdirectory(file), path.getbasename(file)..action_suffix..path.getextension(file))
    if os.isfile(action_file) then os.copyfile(action_file, file) return end
     
    print("ERROR: no "..platform_file.." or "..action_file.." found!")
end

local current_offset = path.getrelative(os.getcwd(), module_dir).."/"  -- because the processed file path is relative to this premake-project.lua path

local vcproj_dir = module_dir.."/"..build_dir.."/".._ACTION
local current_offset_vcproj = path.getrelative(vcproj_dir, module_dir).."/"  -- use as vcproj prebuild cmd
local build_dir_vcproj   = current_offset_vcproj..build_dir.."/".._ACTION

local build_dir   = current_offset..build_dir.."/".._ACTION
local build_offset = path.getrelative(build_dir, module_dir).."/"

function modify_path(path, offset)
	local modified_path = {}
	for i,val in ipairs(path) do
		modified_path[i] = offset..val
	end
	return modified_path
end

local tool_dir = current_offset..tools_dir
local tool_dir_build = build_offset..tools_dir
include_dirs = modify_path(include_dirs, current_offset)
librarys_dirs = modify_path(librarys_dirs, current_offset)
src_files_dirs = modify_path(src_files_dirs, current_offset)
test_files_dirs = modify_path(test_files_dirs, current_offset)

local tool_dir_win = string.gsub(tool_dir, "/", "\\")
local tool_dir_build_win = string.gsub(tool_dir_build, "/", "\\")
local test_dir    = build_dir.."/temp"
local test_dir_vcproj = build_dir_vcproj.."/temp"
local target_dir  = build_dir.."/target"
local lib_dir     = build_dir.."/lib"
local obj_dir     = build_dir.."/obj"
local target_name = module_name.."Test"

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

	--------------------
	
	function get_one_dir_tests_build(dir, files)
	  local test_hfiles = os.matchfiles(dir.."/"..files)
	  local test_files = ""
	  for _, v in ipairs(test_hfiles) do		
		test_files = test_files..string.format("%s ", path.getrelative(build_dir, v)) 
	  end
	  return test_files
	end

    function get_tests_build(dir_list, files)
		local test_files = ""
		local test_files_temp = ""
		for _, v in ipairs(dir_list) do
			test_files_temp = get_one_dir_tests_build(v, files)
			test_files = test_files..test_files_temp
		end		
		return test_files
	end
	
    -----------
    function copy_all_right_files()
	  if os.is("windows") then 
		copy_right_file(tool_dir.."/mockcpp/lib/mockcpp.lib")
		copy_right_file(tool_dir.."/testngpp/bin/testngpp-runner.exe")
		copy_right_file(tool_dir.."/testngpp/bin/testngpp-win32-testcase-runner.exe")
		copy_right_file(tool_dir.."/testngpp/lib/testngpp.lib")
		copy_right_file(tool_dir.."/testngpp/testngpp/listener/testngppstdoutlistener.dll")
		copy_right_file(tool_dir.."/testngpp/testngpp/listener/testngppxmllistener.dll")
	  end
	  -- linux or other os, may not need to use different lib/exe files on different platforms.
    end
	
   --
   -- generate cpp file for each test .h file.
   --
   function generate_tests()
	  copy_all_right_files()
	  
      print("Generating test files ...")   
	  local test_files = ""
	  test_files = get_tests(test_files_dirs, "**.h")
	  
	  local test_files_build = ""
	  test_files_build = get_tests_build(test_files_dirs, "**.h")
	  
	  local test_generator = "python "..tool_dir.."/testngpp/testngpp/generator/testngppgen.pyc "
	  local test_generator_build = "python "..tool_dir_build.."/testngpp/testngpp/generator/testngppgen.pyc "
	  if os.is("windows") then 
	    test_generator = tool_dir_win.."\\testngpp\\bin\\testngppgen.exe "
		test_generator_build = tool_dir_build_win.."\\testngpp\\bin\\testngppgen.exe "
	  end
	  local file_encode = "-e gb2312 "
	  local cpp_generated = "-d "..test_dir.." "	  
	  local cpp_generated_build = "-d "..test_dir_vcproj.." "
	  local cmdline = test_generator..file_encode..cpp_generated..test_files
	  local cmdline_build = test_generator_build..file_encode..cpp_generated_build..test_files_build
	  os.executef(cmdline) -- generate .cpp file at the first running, in order to include it in vcproj.
	  os.execute("sleep 3") -- wait until generate tests finish!
	  return cmdline_build  -- when remove to tools/script, they are the same.
   end
   
   --
   -- construct run tests command.
   --
   function run_tests()
   	  local testngpp_runner = tool_dir.."/testngpp/bin/testngpp-runner"
	  local testngpp_runner_build = tool_dir_build.."/testngpp/bin/testngpp-runner"
	  if os.is("windows") then 
	    testngpp_runner = tool_dir_win.."\\testngpp\\bin\\testngpp-runner.exe" 
		testngpp_runner_build = tool_dir_build_win.."\\testngpp\\bin\\testngpp-runner.exe" 
	  end
	  --[[
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
	  ]]--
	  local test_dlls = ""
      if test_dlls == "" then  -- at first time, dll/so not exist, generate correct cmd line
        if os.is("windows") then
	      test_dlls = "target/"..target_name    
	    else
	      test_dlls = "target/lib"..target_name   
	    end
	  end
	  local listener_dirs = '-L"'..tool_dir..'/testngpp/testngpp/listener"'
	  local listener_dirs_build = '-L"'..tool_dir_build..'/testngpp/testngpp/listener"'
	  local listeners = '-l"testngppstdoutlistener -c -v"'
	  local test_options = "" --  -s
	  local run_tests = string.format("%s %s %s %s %s", testngpp_runner_build, test_dlls, listener_dirs_build, listeners, test_options)
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
		
	function include_memcheck_header(need_path, force_include)
	    if _OPTIONS["nomemcheck"] then return end
	    if need_path then 
		    includedirs { tool_dir.."/3rdparty" } -- support include mem checker header file.
		end
		buildoptions { force_include.." \"mem_checker/interface_4user.h\""}
	end

   solution (module_name)
      configurations { "Debug", "Release" }
      language "C++"
      location (build_dir)
	  flags { "Symbols" }
 
   project (module_name)  -- this project is only for test. and it used mem checker module.
      location (build_dir)
      kind "StaticLib"
	  process_files(files, src_files_dirs, "**.cpp")
	  process_files(files, src_files_dirs, "**.cxx")
	  process_files(files, src_files_dirs, "**.c")
	  process_files(files, include_dirs, "**.hpp")
	  process_files(files, include_dirs, "**.h")
	  targetdir (lib_dir)
	  process_items(includedirs, include_dirs)
	  process_items(defines, user_defines)
	  objdir (obj_dir.."/"..module_name)	  
	  
	  configuration {"gmake"}
	    include_memcheck_header(true, "-include")

	  configuration {"vs*"}	    
	    buildoptions { "/MDd" }
		include_memcheck_header(true, "/FI")
 
   project (module_name.."Test")
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
      configuration {"gmake"}
		include_memcheck_header(false, "-include")

	  configuration {"vs*"}
	    include_memcheck_header(false, "/FI")
	    buildoptions { "/Zm1000", "/vmg", "/MDd" }
	    defines { "WIN32", "_WINDOWS", "_DEBUG", "MSVC_VMG_ENABLED"}
	    linkoptions { "/DEBUG"}	  
	    flags { "NoManifest" } 
      	  

	  

   
--
--  Add .h/.cpp/test files for class, or add test file for feature. 
--  If one file exists, will not overwrite it, but still add others.
--  Author : chenguodong <sinojelly@gmail.com>
--  2010.11.13
--    

newoption {
   trigger     = "test",
   description = "Add .cpp and test file at the same time."
}

newoption {
   trigger     = "cpp",
   description = "Add .cpp file at the same time."
}

newoption {
   trigger     = "usage",
   description = "Show usage of addclass."
}

newoption {
   trigger     = "class",
   description = "Name of the class that you want to add."
}

newoption {
   trigger     = "feature",
   description = "Name of the feature that you want to add test."
}

---------------------------------

function usage()
	if not _OPTIONS["usage"] then return false end
	
	print("Usage: ")
	print("    add .h file for class                   :   premake4 --class=ClassName addfile")
	print("    add .h and .cpp file for class          :   premake4 --class=ClassName --cpp addfile")
	print("    add .h and .cpp and test file for class :   premake4 --class=ClassName --test addfile")
	print("    add test file for feature               :   premake4 --feature=FeatureName addfile")
	
	return true
end

function is_class()
	if not _OPTIONS["class"] then return false end
	return true
end

function is_feature()
	if not _OPTIONS["feature"] then return false end
	return true
end

function class_name()
	if is_class() then return _OPTIONS["class"] end
end

function feature_name()
	if is_feature() then return _OPTIONS["feature"] end
end

---------------------------------

function get_template_dir()
	return tools_dir.."/scripts/"
end

function get_h_template_path()
	return get_template_dir().."Template.h"
end

function get_cpp_template_path()
	return get_template_dir().."Template.cpp"
end

function get_test_template_path()
	return get_template_dir().."TemplateTest.h"
end

---------------------------------
-- Note: current dir is UserModule!!!

local path_offset = "" -- path.getrelative(os.getcwd(), cwd).."/"

function get_h_dir()
	assert(include_dirs[1], "ERROR: no include_dirs specified.")
	return path_offset..include_dirs[1].."/"..module_name.."/"
end

function get_cpp_dir()
	assert(src_files_dirs[1], "ERROR: no src_files_dirs specified.")
	return path_offset..src_files_dirs[1].."/"
end

function get_test_dir()
	assert(test_files_dirs[1], "ERROR: no test_files_dirs specified.")
	return path_offset..test_files_dirs[1].."/"
end

---------------------------------

-- put temp files in "drive_root/addfile_temp"
function get_temp_dir()
	return path.getdrive(path.getabsolute(tools_dir))..":/addfile_temp/"
end

function make_dir(dir)
	if os.isdir(dir) then return end
	os.mkdir(dir)
end

function get_temp_h_dir()
	assert(include_dirs[1], "ERROR: no include_dirs specified.")
	local dir = get_temp_dir()..include_dirs[1].."/"..module_name.."/"
	make_dir(dir)
	return dir
end

function get_temp_cpp_dir()
	assert(src_files_dirs[1], "ERROR: no src_files_dirs specified.")
	local dir = get_temp_dir()..src_files_dirs[1].."/"
	make_dir(dir)
	return dir
end

function get_temp_test_dir()
	assert(test_files_dirs[1], "ERROR: no test_files_dirs specified.")
	local dir = get_temp_dir()..test_files_dirs[1].."/"
	make_dir(dir)
	return dir
end

---------------------------------

function get_h_file_name(class)
	return class..".h"
end

function get_cpp_file_name(class)
	return class..".cpp"
end

function get_test_file_name(class)
	return class.."Test.h"
end

---------------------------------

function get_h_file_path(class)
	return get_h_dir()..get_h_file_name(class)
end

function get_cpp_file_path(class)
	return get_cpp_dir()..get_cpp_file_name(class)
end

function get_test_file_path(class)
	return get_test_dir()..get_test_file_name(class)
end

---------------------------------

function get_temp_h_file_path(class)
	return get_temp_h_dir()..get_h_file_name(class)
end

function get_temp_cpp_file_path(class)
	return get_temp_cpp_dir()..get_cpp_file_name(class)
end

function get_temp_test_file_path(class)
	return get_temp_test_dir()..get_test_file_name(class)
end

---------------------------------

function exist_h_file(class)
	return os.isfile(get_h_file_path(class))
end

function exist_cpp_file(class)
	return os.isfile(get_cpp_file_path(class))
end

function exist_test_file(class)
	return os.isfile(get_test_file_path(class))
end

---------------------------------

function need_h_file(class)
	if exist_h_file(class) then return false end
	return true
end

function need_cpp_file(class)
	if exist_cpp_file(class) then return false end
	if not _OPTIONS["test"] and not _OPTIONS["cpp"] then return false end
	return true
end

function need_test_file(class)
	if exist_test_file(class) then return false end
	if not not _OPTIONS["feature"] then return true end -- Note: must use not not
	if not _OPTIONS["test"] then return false end
	return true
end

---------------------------------

function get_old_module_name()
	return "UserModule"
end

function get_old_class_name()
	return "ClassName"
end

function original(name)
	return name
end

-- Note: not this: sed -i -e 's/abc/ABC/g' file.h
function replace_module(file, translate)
	local cmdline = "sed -i -e s/"..translate(get_old_module_name()).."/"..translate(module_name).."/g "..file
	os.execute(cmdline)
end

function replace_class(file, class, translate)
	local cmdline = "sed -i -e s/"..translate(get_old_class_name()).."/"..translate(class).."/g "..file
	os.execute(cmdline)
end

function replace(file, class)
	replace_module(file, original)
	replace_module(file, string.upper)
	
	replace_class(file, class, original)
	replace_class(file, class, string.upper)
end

---------------------------------

function modify_temp_h_file(class)
	replace(get_temp_h_file_path(class), class)
end

function modify_temp_cpp_file(class)
	replace(get_temp_cpp_file_path(class), class)
end

function modify_temp_test_file(class)
	replace(get_temp_test_file_path(class), class)
end

---------------------------------

function copy_temp_h_file(class)
	os.copyfile(get_h_template_path(), get_temp_h_file_path(class))	
end

function copy_temp_cpp_file(class)
	os.copyfile(get_cpp_template_path(), get_temp_cpp_file_path(class))
end

function copy_temp_test_file(class)
	os.copyfile(get_test_template_path(), get_temp_test_file_path(class))
end

---------------------------------

function copy_h_file(class)
	os.copyfile(get_temp_h_file_path(class), get_h_file_path(class))	
	print("add "..get_h_file_path(class))
end

function copy_cpp_file(class)
	os.copyfile(get_temp_cpp_file_path(class), get_cpp_file_path(class))
	print("add "..get_cpp_file_path(class))
end

function copy_test_file(class)
	os.copyfile(get_temp_test_file_path(class), get_test_file_path(class))
	print("add "..get_test_file_path(class))
end

---------------------------------

function create_h_file(class)
	copy_temp_h_file(class)
	modify_temp_h_file(class)
	copy_h_file(class)
end

function create_cpp_file(class)
	copy_temp_cpp_file(class)
	modify_temp_cpp_file(class)
	copy_cpp_file(class)
end

function create_test_file(class)
	copy_temp_test_file(class)
	modify_temp_test_file(class)
	copy_test_file(class)
end

---------------------------------

function add_h_file(class)
	if not need_h_file(class) then return end
	create_h_file(class)
end

function add_cpp_file(class)
	if not need_cpp_file(class) then return end
	create_cpp_file(class)
end

function add_test_file(class)
	if not need_test_file(class) then return end
	create_test_file(class)
end

---------------------------------

function add_class_files(class)
	  if not is_class() then return false end
  	  add_h_file(class)
	  add_cpp_file(class)
	  add_test_file(class)
	  return true
end

function add_feature_test(feature)
	  if not is_feature() then return false end
	  add_test_file(feature)
	  return true
end

---------------------------------

newaction {
   trigger     = "addfile",
   description = "Add .h/.cpp/test files for class/feature(use --usage to show help)",
   execute = function ()
	  if usage() then return end
	  if add_class_files(class_name()) then return end
	  if add_feature_test(feature_name()) then return end
	  error("ERROR: no class name or feature name specified!")
   end
}

--
--  Add class's .h/.cpp/test files, or add test file only. 
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
   trigger     = "help",
   description = "Show usage of addclass."
}

---------------------------------

function help()
	if not _OPTIONS["help"] then return false end
	
	print("Usage: ")
	print("    add class's h file          :   premake4 addclass ClassName")
	print("    add class's h/cpp file      :   premake4 --cpp addclass ClassName")
	print("    add class's h/cpp/test file :   premake4 --test addclass ClassName")
	print("    add test file               :   premake4 addtest FeatureName")
	
	return true
end

---------------------------------

function get_h_template_path()
	return "Template.h"
end

function get_cpp_template_path()
	return "Template.cpp"
end

function get_test_template_path()
	return "TemplateTest.h"
end

---------------------------------

local path_offset = path.getrelative(os.getcwd(), cwd).."/"

function get_h_dir()
	if not include_dirs[1] then
		print("ERROR: no include_dirs specified.")
		return ""
	end
	return path_offset..include_dirs[1]
end

function get_cpp_dir()
	if not src_files_dirs[1] then
		print("ERROR: no src_files_dirs specified.")
		return ""
	end
	return path_offset..src_files_dirs[1]
end

function get_test_dir()
	if not test_files_dirs[1] then
		print("ERROR: no test_files_dirs specified.")
		return ""
	end
	return path_offset..test_files_dirs[1]
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
	return get_h_dir().."/"..get_h_file_name(class)
end

function get_cpp_file_path(class)
	return get_cpp_dir().."/"..get_cpp_file_name(class)
end

function get_test_file_path(class)
	return get_test_dir().."/"..get_test_file_name(class)
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
	if not _OPTIONS["test"] and not _OPTIONS["cpp"] then return false end
	if exist_cpp_file(class) then return false end
	return true
end

function need_test_file(class)
	if not _OPTIONS["test"] then return false end
	if exist_test_file(class) then return false end
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

function replace_module(file, translate)
	local cmdline = "sed -i -e 's/"..translate(get_old_module_name()).."/"..translate(module_name).."/g' "..file
	os.execute(cmdline)
end

function replace_class(file, class, translate)
	local cmdline = "sed -i -e 's/"..translate(get_old_class_name()).."/"..translate(class).."/g' "..file
	os.execute(cmdline)
end

function replace(file, class)
	replace_module(file, original)
	replace_module(file, string.upper)
	
	replace_class(file, class, original)
	replace_class(file, class, string.upper)
end

---------------------------------

function modify_h_file(class)
	replace(get_h_file_path(class), class)
end

function modify_cpp_file(class)
	replace(get_cpp_file_path(class), class)
end

function modify_test_file(class)
	replace(get_test_file_path(class), class)
end

---------------------------------

function copy_h_file(class)
	os.copyfile(get_h_template_path(), get_h_file_path(class))
end

function copy_cpp_file(class)
	os.copyfile(get_cpp_template_path(), get_cpp_file_path(class))
end

function copy_test_file(class)
	os.copyfile(get_test_template_path(), get_test_file_path(class))
end

---------------------------------

function create_h_file(class)
	copy_h_file(class)
	modify_h_file(class)
end

function create_cpp_file(class)
	copy_cpp_file(class)
	modify_cpp_file(class)
end

function create_test_file(class)
	copy_test_file(class)
	modify_test_file(class)
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

function get_argument()
	if not arg then return nil end
	return arg[1]
end

---------------------------------

newaction {
   trigger     = "addclass",
   description = "Add class files",
   execute = function ()
	  if help() then return end	  
	  add_h_file(get_argument())
	  add_cpp_file(get_argument())
	  add_test_file(get_argument())
   end
}

newaction {
   trigger     = "addtest",
   description = "Add test file",
   execute = function ()
      if help() then return end
	  add_test_file(get_argument())
   end
}

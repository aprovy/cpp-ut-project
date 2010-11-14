--
-- Copy usefull files to release dir
--

local release_dir = "../cpp-ut-project-release/"
local root_dir = ".."

function get_sep()
	local sep = "/"
	if os.get() == "windows" then
	   sep = "\\"
	end
	return sep
end

-- copy files in root dir
function copy_root_files()
	local src_name = path.translate(root_dir, get_sep())
	local dst_name = path.translate(release_dir, get_sep())
	os.execute("xcopy "..src_name.." "..dst_name.." /I /Y")  -- no /S
end

function copy_module()
	local dst_module = path.translate(release_dir..module_name, get_sep())
	os.execute("xcopy . "..dst_module.." /I /Y /S")  
end

function copy_scripts()
	local src_scripts = path.translate(tools_dir.."/scripts", get_sep())
	local dst_scripts = path.translate(release_dir.."/tools/scripts", get_sep()) 	  
	os.execute("xcopy "..src_scripts.." "..dst_scripts.." /I /Y /S") 
end

newaction {
   trigger     = "release",
   description = "Copy usefull files to release dir",
   execute = function ()
	  copy_scripts()
	  copy_module()
	  copy_root_files()
   end
}

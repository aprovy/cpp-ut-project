--
-- Copy usefull files to install dir
--

local install_dir = "../install/"

function get_sep()
	local sep = "/"
	if os.get() == "windows" then
	   sep = "\\"
	end
	return sep
end

newaction {
   trigger     = "install",
   description = "Copy usefull files to install dir",
   execute = function ()
	  local dst_module = path.translate(install_dir..module_name, get_sep())
	  local src_scripts = path.translate(tools_dir.."/scripts", get_sep())
	  local dst_scripts = path.translate(install_dir.."/tools/scripts", get_sep())
	  local src_readme = path.translate("../readme.txt", get_sep())
	  local dst_readme = "readme.txt"
	  
	  os.execute("xcopy . "..dst_module.." /I /Y /S")  -- copy modue_name dir
	  os.execute("xcopy "..src_scripts.." "..dst_scripts.." /I /Y /S") 
	  os.execute("xcopy "..src_readme.." "..dst_readme.." /I /Y /S") -- copy readme.txt
   end
}

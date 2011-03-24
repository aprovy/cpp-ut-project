--
-- usage: in the command line , run the cmd: premake4 vs2005, and then use the .sln and .vcproj in ../build/vs2005 dir.
--       after adding .h/.cpp or tests, rerun the cmd premake4 vs2005, it will generate new .sln .vcproj including new files.
-- normal use: premake4 vs2005    and then : build in Visual Studio 2005
--             premake4 gmake     and then : make
--             premake4 gmake     and then : make config=debug
--
-- you can also add files for class or feature, use "premake4 --usage addfile" to show more.
--

--
-- define user's parameters, all the paths are relative to premake4.lua dir.
--

-- change the module name by yourself
module_name     = "UserModule"

-- define the tools dir
tools_dir       = "../tools"

-- define the build dir
build_dir       = "../build"

-- define source dir name
src_dir_name    = "src"

-- define the user's include dir and librarys. (eg: {"something", "otherthing"})
-- action addfile will add .h file to the first include dir.
include_dirs    = {"include"}
user_defines    = {}
librarys        = {}
librarys_dirs   = {}

-- define .cpp/test files search path (it will search recursively)
-- action addfile will add .cpp/test file to the first src/test dir.
src_files_dirs  = {src_dir_name}
test_files_dirs = {"test"}

module_dir = os.getcwd()


dofile(path.join(module_dir, "tools.lua"))
dofile(path.join(tools_dir, "scripts/addfile.lua"))
dofile(path.join(tools_dir, "scripts/release.lua"))
dofile(path.join(tools_dir, "scripts/options.lua"))
if _ACTION == "addfile" or _ACTION == "release" then return end
dofile(path.join(tools_dir, "scripts/project.lua"))

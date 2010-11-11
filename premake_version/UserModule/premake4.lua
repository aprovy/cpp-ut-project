--
-- usage: in the command line , run the cmd: premake4 vs2005, and then use the .sln and .vcproj in ../build/vs2005 dir.
--       after adding .h/.cpp or tests, rerun the cmd premake4 vs2005, it will generate new .sln .vcproj including new files.
-- normal use: premake4 vs2005    and then : build in Visual Studio 2005
--             premake4 gmake     and then : make
--             premake4 gmake     and then : make config=debug
--

--
-- define user's parameters, all the paths are relative to premake4.lua dir.
--

-- change the module name by yourself
module_name     = "UserModule"
tool_dir        = "../tools"

-- define the user's include dir and librarys. (replace nil with {"something", "otherthing"})
include_dirs    = {"include"}
librarys        = nil
librarys_dirs   = {}

-- define .cpp/test files search path (it will search recursively)
src_files_dirs  = {"src"}
test_files_dirs = {"test"}

dofile("../tools/scripts/premake-testngpp.lua")

   
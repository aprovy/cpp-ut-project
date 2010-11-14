--
--  Support specify tools dir in command line, such as "premake4 --tools=..\tools vs2008"
--

newoption {
   trigger = "tools",
   value = tools_dir,
   description = "Path of the tools(testngpp, mockcpp, etc.)."
}

if not _OPTIONS["tools"] then return end
tools_dir = _OPTIONS["tools"]


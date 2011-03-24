--
--  Support using command line option to generate projects without including memcheck header, eg: "premake4 --nomemcheck vs2008"
--


newoption {
   trigger = "nomemcheck",
   description = "Generate projects without including memcheck header."
}

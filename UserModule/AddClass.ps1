# Usage: .\AddClass.ps1 ClassName y
# y - means to generate cpp file and add to CMakeLists.txt
# If cpp file is not needed, input ClassName parameter only.

$env:MODULE_DIR=(get-location)
$env:SCRIPT_DIR="$env:MODULE_DIR\..\tools\scripts"


$CMD_LINE="$env:SCRIPT_DIR\AddCppClass.ps1 $args"
Invoke-Expression $CMD_LINE

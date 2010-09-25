# Usage: .\AddTest.ps1 UT_ClassName.h
# Generate test file and add to CMakeLists.txt

$env:MODULE_NAME="UserModule"
$env:MODULE_DIR=(get-location)
$env:SCRIPT_DIR="$env:MODULE_DIR\..\tools\scripts"

$CMD_LINE="$env:SCRIPT_DIR\AddTestFile.ps1 $args"
Invoke-Expression $CMD_LINE

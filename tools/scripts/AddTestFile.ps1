#usage: AddTestFile test_file_name$CMD_LINE="$env:SCRIPT_DIR\setVars.ps1"Invoke-Expression $CMD_LINE $TEST_FILE_NAME=$args[0]$OLD_CLASS="HelloWorld"$NEW_CLASS=$TEST_FILE_NAME-replace "(\.h$|UT_|IT_|ST_|FT_)"# test file always be .h file.$TEST_FILE_NAME=$TEST_FILE_NAME-replace "\.h$"$TEST_FILE_NAME=$TEST_FILE_NAME+".h"$TEST_FILE="$env:TEST_DIR\$TEST_FILE_NAME"if (test-path $TEST_FILE){ 	Write-host "File $TEST_FILE exists!"		#return from this script	return 	}echo "Generating $TEST_FILE ..."$GEN_TEST="sed -e 's/$OLD_CLASS/$NEW_CLASS/g' $env:SCRIPT_DIR\TestTemplate.h > $TEST_FILE"Invoke-Expression $GEN_TEST$CMAKE_FILE="$env:TEST_DIR\CMakeLists.txt"echo "Modify $CMAKE_FILE ..."$MODIFY_CMAKE="sed -i '/SET(UT_CASES/a\    $TEST_FILE_NAME' $CMAKE_FILE"Invoke-Expression $MODIFY_CMAKEecho "Done"
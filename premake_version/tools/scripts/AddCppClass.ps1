# usage: AddCppClass class_name$CMD_LINE="$env:SCRIPT_DIR\setVars.ps1"Invoke-Expression $CMD_LINE if ( $args[0] -eq "-h" -or $args[0] -eq "--help") {     echo "Usage: AddClass class_name [y]"	 echo "       y -- means generate cpp file."	 return }$OLD_CLASS="HelloWorld"$NEW_CLASS=$args[0]$H_FILE="$env:HEADER_DIR\$NEW_CLASS.h"$CPP_FILE="$env:SRC_DIR\$NEW_CLASS.cpp"$CPP_FILE_NAME="$NEW_CLASS.cpp"$H_DEFINE=$NEW_CLASS.ToUpper()$H_DEFINE="__"+$H_DEFINE+"_H__"if (test-path $H_FILE){ 	Write-host "File $H_FILE exists!"		#return from this script	return 	}echo "Generating $H_FILE ..."$GEN_H="sed -e 's/__\(.*\)_H_/$H_DEFINE/g' -e 's/$OLD_CLASS/$NEW_CLASS/g' $env:SCRIPT_DIR\Template.h > $H_FILE"Invoke-Expression $GEN_Hif ($args[1] -eq "y"){	echo "Generating $CPP_FILE ..."	$GEN_CPP="sed -e 's/$OLD_CLASS/$NEW_CLASS/g' $env:SCRIPT_DIR\Template.cpp > $CPP_FILE"	Invoke-Expression $GEN_CPP		# When using premake, lua script can search files automated, no need to modify config file.	#$CMAKE_FILE="$env:SRC_DIR\CMakeLists.txt"	#echo "Modify $CMAKE_FILE ..."	#$MODIFY_CMAKE="sed -i '/SET(SRC_LIST/a\    $CPP_FILE_NAME' $CMAKE_FILE"	#Invoke-Expression $MODIFY_CMAKE}Write-host "Done"
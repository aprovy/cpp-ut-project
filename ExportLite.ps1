# export mockcpp without boost

$env:path=$env:path+";D:\Tools\CMD\SubversionClient"

$dest_dir="D:\tools_release\cpp-ut-project_exported"

function export_subdir($subdir) 
{
	if (!(test-path $dest_dir\$subdir)) { mkdir $dest_dir\$subdir }
	xcopy $subdir $dest_dir\$subdir\ /S	
}

export_subdir tools\scripts
export_subdir tools\bin
export_subdir UserModule

xcopy readme.txt $dest_dir\

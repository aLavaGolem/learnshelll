#!/bin/bash
projectname=toprie_manager
#编译的项目路径
cproject=/D/newpoject/toprie_manager/out/artifacts/toprie_manager_Web_exploded
cprojectclass=/WebRoot/WEB-INF/classes
cprojectclass2=/WEB-INF/classes
#压缩WebRoot
zippath=$projectname/WebRoot
webroot=WebRoot

abc=`svn diff -r 5621:HEAD --summarize  http://192.168.1.183/svn/oracle_tlink/$projectname | grep -o "http.*" `

echo svn下载打包
for element in ${abc[@]}
do
	if [[ $element == */src/* ]]
	then
		#SRC
		echo "SRC"
		
		if [ ! -d "$projectname$cprojectclass" ]; then
			mkdir -p $projectname$cprojectclass
		fi

		filepath=/${element##*src/}
		echo $filepath
		filepath2=${filepath/java/class}
		
		cppath=$projectname$cprojectclass$filepath2
		cppath=${cppath%/*}
		
		if [ ! -d "$cppath" ]; then
			mkdir -p $cppath
		fi		
		cp  $cproject$cprojectclass2$filepath2 $cppath
		echo 导出文件：$cproject$cprojectclass2$filepath2
		
	else
		#WebRoot
		path=${element%/*}
		path=${path#*/$projectname}
		filename=/${element##*/}
		#path=${path: 1}

		if [ ! -d "$projectname$path" ]; then
			mkdir -p $projectname$path
		fi
		if [  -f "$projectname$path$filename" ]; then
			rm -f $projectname$path$filename
		fi	
		svn export $element $projectname$path
		echo 导出文件：$projectname$path$filename	
	fi
done
#压缩
echo 压缩
echo $zippath
if [ -d "$zippath" ]; then
	cd $projectname
	zip -q -r  $projectname"_WebRoot.zip" $webroot
	mv $projectname"_WebRoot.zip" ../
fi






#! /bin/bash
maxleapgitconfig="../ilslib/MaxLeapGitSecurity/MaxLeapGitSecurity.plist"
project_root="./MaxLeapGit";
if [ -f $maxleapgitconfig ]; then
    
    LINE=`/usr/libexec/PlistBuddy ${maxleapgitconfig} -c print | grep = | tr -d ' '`
    
    for i in `find ${project_root} -name "*.m"`; do

	for replaceItem in $LINE; do
	    key=`echo $replaceItem | awk -F = '{print $1}'`
	    value=`echo $replaceItem | awk -F = '{print $2}'`
        sed -e s/$key/$value/g $i > ${i}.tmp && mv ${i}.tmp ${i}
	done

      echo "${i} is done"
   done
fi
   

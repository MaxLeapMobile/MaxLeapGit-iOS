#! /bin/bash
maxleapgitconfig="../GitMaster-iOS-Sensitive-Keys/MaxLeapGitSecurity.plist"
project_root="./MaxLeapGit";
if [ -f $maxleapgitconfig ]; then
    
    LINE=`/usr/libexec/PlistBuddy ${maxleapgitconfig} -c print | grep = | tr -d ' '`
    
    for i in `find ${project_root} -name "*.pch"`; do

	for replaceItem in $LINE; do
	    keyInPlist=`echo $replaceItem | awk -F = '{print $1}'`
	    valueInPlist=`echo $replaceItem | awk -F = '{print $2}'`
        pattern="CONFIGURE(@\"${keyInPlist}";
        replacement="CONFIGURE(@\"${valueInPlist}";
        sed -e s/$pattern/$replacement/g $i > ${i}.tmp && mv ${i}.tmp ${i}
	done

      echo "${i} is done"
   done
fi
   

#${1} --> first parameter is path that you want to search on it
#${2} --> seconf parameter is the class name that you want to search 


#using zipinfo 
for f in $(find "${1}" -name "*.jar"); do zipinfo $f | grep "${2}" && echo $f ; done


#using jdk/jre jar
 for f in $(find ${1} -name *.jar -type f); do ${JAVAM_HOME}/bin/jar --list --file  $f | grep -i ${2} && echo "--->"$f && echo; done;

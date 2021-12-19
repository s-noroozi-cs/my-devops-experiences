#${1} --> first parameter is path that you want to search on it
#${2} --> seconf parameter is the class name that you want to search 

#I prefer jar solution, because already exist in you environment and did not need to install any other things


#using zipinfo 
for f in $(find "${1}" -name "*.jar"); do zipinfo $f | grep "${2}" && echo $f ; done


#using jdk/jre jar
for f in $(find ${1} -name *.jar -type f); do ${JAVAM_HOME}/bin/jar --list --file  $f | grep -i ${2} && echo "--->"$f && echo; done;

#some jar implementation does not support log mode parameter, then try to use short mode
for f in $(find ${1} -name *.jar -type f); do ${JAVAM_HOME}/bin/jar -tf  $f | grep -i ${2} && echo "--->"$f && echo; done;


#using unzip
for f in $(find ${1} -name *.jar -type f); do unzip -l $f | grep -i ${2} && echo "--->"$f && echo; done;

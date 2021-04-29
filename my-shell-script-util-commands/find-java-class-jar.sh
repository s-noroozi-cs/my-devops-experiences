for f in $(find "${1}" -name "*.jar"); do zipinfo $f | grep "${2}" && echo $f ; done

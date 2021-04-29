netstat -tupln 2>/dev/null | grep ":${1} " | tr -s " " | rev | cut -d' ' -f2 | cut -d'/' -f2 | rev | sort | uniq | xargs kill -9 2>/dev/null

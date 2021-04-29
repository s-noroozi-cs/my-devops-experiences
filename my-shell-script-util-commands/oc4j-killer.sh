echo 
echo "Filter opmnctl result by input:"${1}
echo

for pid in $(/oracleAS10g/product/opmn/bin/opmnctl status | grep -v "N/A" | grep ${1} | tr -s ' ' | cut -d' ' -f5)
do
        echo "Try to kill ${pid}"
        kill -9 ${pid}
done

echo
echo "Finish"
echo

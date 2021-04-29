wf_home=/opt/jboss/wildfly-9.0.1.Final
dest_dir=/home/wildfly-deployments/`date '+%Y-%m-%dT%H-%M-%S'`
mkdir ${dest_dir}

for app_name in $($wf_home/bin/jboss-cli.sh --connect --command="ls deployment")
do
        sha=$(cat ${wf_home}/standalone/configuration/standalone.xml  | grep ${app_name} -A 1 | grep "sha1" | awk '{print $2}')
        echo "============================================"
        len=${#sha}
        len=$(($len-9))
        dir=${sha:6:$len}
        source=${wf_home}/standalone/data/content/${dir:0:2}/${dir:2}/content
        dest=${dest_dir}/$app_name
        printf "application name: %s, sha=%s\n" ${app_name} ${dir}
        printf "copying from %s to %s\n" ${source} ${dest}
        cp ${source} ${dest}
        echo "============================================"
done


#Each project in  SonarQube must be have project key.
prj_key=[YOUR-PROJECT-KEY]

#Our build tools is maven and sonarqube has plugin for maven.
#SonarQube maven plugin show task status url in generate output log.
#Task url help us to chekc task status, because in newer version of sonarqube scanning task run in backgroun in Async. mode.
task_url=$(grep 'http://.*/api/ce/task?id=' $JENKINS_HOME/jobs/$JOB_NAME/builds/$BUILD_ID/log  | head -n1 | rev | cut -d' ' -f1 | rev)

status='"IN_PROGRESS"'
#Try to check task status each 1 second until task done
while [ $status == '"IN_PROGRESS"' ] || [ $status == '"PENDING"' ]; do status=$(curl $task_url | grep -o '"status":".*",' |cut -d',' -f1 | cut -d':' -f2);sleep 1s; done

#After finishing task , check status of quality gate of project by project key
if [ $status == '"SUCCESS"' ] 
then
   sonar_host=$(echo $task_url | cut -d'/' -f1-3)
   quality_gate_url="$sonar_host/api/qualitygates/project_status?projectKey=$prj_key"
   status=$(curl $quality_gate_url | grep '"status":".*",' | cut -d',' -f1 | cut -d':' -f3)
fi

if [ $status != '"OK"' ] 
then
   exit 1;
fi

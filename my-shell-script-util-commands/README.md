# my-shell-script-util-commands
Some Linux shell script commands that combine some simple commands for specific goal.

## port-process-killer.sh
This file contain commands to find process id that listen to specific port and then try to kill it.
For example if I would like to kill process that listen to port 8080,  execute following command:

`./port-process-killer.sh 8080 `

## port-process-info.sh
This file contains commands to find process id that listen to specific port and then show execution path and related parameter in completed shape. For example, to see execution path and related parameter for process that listen to port 8080, try following command:

`./port-process-info.sh 8080`

## find-java-class-jar.sh
Using this command to find jar files with path that contains specific java class file. For example to search specific directory (“/home/oracle/wildfly”)to know which jar file contain specific class file (“Test.class”), try following command:

`./find-java-class-jar.sh "/home/oracle/wildfly" "Test.class"`

## oc4j-killer.sh
This script tries to find all instance of oc4j process and then try to kill all of them. Alone parameter is oc4j name. In oracle application server each oc4j can contain multiple instances. Each instance is java process. If I have oc4j with name "my-app", to kill all instances, only need to execute following command:

`./oc4j-killer.sh "my-app"`

## wildfly_standalone_deployments_backup.sh
Connect to jboss using cli and found all deployments, then made backup from files(jar, war, ear ...)

## wls_server.sh
Weblogic has admin server,manage server and nodes. This script help to facilitate managing this servers.

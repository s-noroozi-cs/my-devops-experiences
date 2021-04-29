start_nm_wait=3s
wls_domain=[YOUR_DOMAIN_DIR]
domain_name=$(basename ${wls_domain})
#if all of your managed servers have same prifix, this script work proberly
#based on oracle documentation, any resource in your doiman should be same profix based on type of it.
wls_ms_prefix=ms_
admin_server_name=AdminServer
#if your domain behid a oracle http server (based on apache http server)
ohs_instance=ohs_1

format_ms(){
	pad=$(printf '%0.1s' " "{1..30})
	
	printf '%s' "$1"                             
	printf '%*.*s' 0 $((${#pad} - ${#1})) "$pad"

	printf '%s' "$2"                                 
	printf '%*.*s' 0 $((${#pad} - ${#2})) "$pad"

	printf '%s' "$3"                                 
	printf '%*.*s' 0 $((${#pad} - ${#3})) "$pad"

	printf '%s' "$4"                                 
	printf '%*.*s' 0 $((${#pad} - ${#4})) "$pad"

	printf '%s' "$5"                                 
	printf '%*.*s' 0 $((${#pad} - ${#5})) "$pad"

	printf '%s' "$6"                                 
	printf '%*.*s' 0 $((${#pad} - ${#6})) "$pad"
	
	printf '\n'                                  

}

newline_ms(){
	for i in $(seq 1 6)
	do
		printf '%0.1s' "-"{1..30}
	done
	echo
}

start_admin(){
	echo "try to start admin server"
	$wls_domain/bin/nodemanager/wlscontrol.sh -d ${domain_name} -r ${wls_domain} -c -f startWebLogic.sh -s ${admin_server_name} START &
}
stop_admin(){
	stop_ms ${admin_server_name}
}
start_ms(){
	echo "try to start managed server with name:${1}"
	$wls_domain/bin/nodemanager/wlscontrol.sh -d ${domain_name} -r ${wls_domain} -c -f startManagedWebLogic.sh -s ${1}  START &
}

stop_ms(){
	echo "try to stop managed server with name:${1}"
	ps aux | grep java | grep ${1} | tr -s ' ' | cut -d' ' -f2 | xargs kill 2>/dev/null
}

status_ms(){
	for name in $(cat ${wls_domain}/config/config.xml | grep "<name>" | grep "${wls_ms_prefix}" | tr -d " "  | uniq)
	do
		ms=$(echo $name | tr -d '[:space:]' | cut -d'<' -f2 | cut -d'>' -f2)
		if ps aux 2>/dev/null | grep java | grep "${ms} " > /dev/null  
		then
			status=UP
			pid=$(ps aux | grep java | grep "${ms} " | tr -s ' '  | cut -d' ' -f2)
			port=$(netstat -tupln  2>/dev/null | grep ${pid} | tr -s ' ' | cut -d' ' -f4 | rev | cut -d':' -f1 | rev | sort | uniq | awk -vORS=, '{ print $1 }' | sed 's/,$/\n/')
			etime=$(ps --pid ${pid} -o etime | tail -n 1)
		else
			status=DOWN
			pid=N/A
			port=N/A
			etime=N/A
		fi
		newline_ms		
		format_ms ${ms} "managed server" ${status} ${pid} ${etime} ${port}
	done
}

status_as(){
	if ps aux 2>/dev/null | grep java | grep "${admin_server_name}" > /dev/null  
		then
			status=UP
			pid=$(ps aux | grep java | grep "${admin_server_name}" | tr -s ' '  | cut -d' ' -f2)
			port=$(netstat -tupln  2>/dev/null | grep ${pid} | tr -s ' ' | cut -d' ' -f4 | rev | cut -d':' -f1 | rev | sort | uniq | awk -vORS=, '{ print $1 }' | sed 's/,$/\n/')
			etime=$(ps --pid ${pid} -o etime | tail -n 1)
		else
			status=DOWN
			pid=N/A
			port=N/A
			etime=N/A
		fi
		newline_ms		
		format_ms "${admin_server_name}" "admin server" ${status} ${pid} ${etime} ${port}
}

get_nm_listent_port(){
	port=$(cat $wls_domain/nodemanager/nodemanager.properties | grep -i port | tr -d '[:space:]' | cut -d'=' -f2)
        echo "${port}"
}

get_pid_by_port(){
	pid=$(netstat -tupln 2>/dev/null | grep "$1" | tr -s ' ' |rev  | cut -d' ' -f2 | rev | cut -d'/' -f1);
        echo "${pid}";
}

start_nm(){
	port=$(get_nm_listent_port)
	pid=$(get_pid_by_port $port)

	if  ps -p ${pid} >/dev/null 2>&1
        then
		echo "node manager with process id ${pid} listening to port ${port}"
	else
		home=$(cat $wls_domain/nodemanager/nodemanager.domains | grep $domain_name | tr -d '[:space:]' | cut -d'=' -f2)
		echo "start node manager using $home/bin/startNodeManager.sh"
		nohup $home/bin/startNodeManager.sh >/dev/null 2>&1 &
		sleep ${start_nm_wait}
	fi
}

stop_nm(){
	port=$(get_nm_listent_port $1 )                                                                  
	pid=$(get_pid_by_port $port)                                                                     
                                                                                                 
	if ps -p ${pid} >/dev/null 2>&1                                                                 
	then                                                                                             
        	kill -9 ${pid}                                       
	else                                                                                             
		echo "there is not exist any process that listen ${port}"
	fi                                                                                               
}

nm_status(){
	port=$(get_nm_listent_port)                            
                                                                   
	pid=$(get_pid_by_port ${port});                                     
	if  ps -p ${pid} >/dev/null 2>&1                                    
	then                                                                
        	status=UP
		etime=$(ps --pid ${pid} -o etime | tail -n 1)
	else                                                                
        	status=DOWN
		etime=N/A
		port=N/A
	fi           
	newline_ms		
	format_ms "$1" "node manager" ${status} ${pid} ${etime} ${port}                                                       
}

check_nm(){
	nm_status  "nm_oa"
}


status_ohs(){
	port=$(cat $wls_domain/config/fmwconfig/components/OHS/instances/$ohs_instance/httpd.conf | grep -i 'listen ' | grep -v '#' | tr  -s ' '  | cut -d' ' -f2 | tr -d ' ')
	if netstat -tupln 2>/dev/null | grep ":${port} ">/dev/null
	then
		pid=$(pstree -p | grep httpd | head -n 1 | cut -d'(' -f2 | cut -d')' -f1)
		etime=$(ps --pid ${pid} -o etime | tail -n 1)
		status=UP
	else
		status=DOWN
		pid=N/A
		etime=N/A
	fi
	newline_ms		
	format_ms "$ohs_instance" "http server" ${status} ${pid} ${etime} ${port}                                                       
}

start_ohs(){
	port=$(cat $wls_domain/config/fmwconfig/components/OHS/instances/${ohs_instance}/httpd.conf | grep -i 'listen ' | grep -v '#' | tr  -s ' '  | cut -d' ' -f2 | tr -d ' ') 
	if netstat -tupln 2>/dev/null | grep ":${port} ">/dev/null                                                                                        
	then                                                                                                                                              
        	echo "http server running on port ${port}"                                                                                                
	else    
		echo "try to start ohs..."                                                                                                                                          
        	$wls_domain/bin/startComponent.sh ${ohs_instance} > /dev/null 2>&1 &
	fi                                                                                                                                                	
}

stop_ohs(){
	port=$(cat $wls_domain/config/fmwconfig/components/OHS/instances/${ohs_instance}/httpd.conf | grep -i 'listen ' | grep -v '#' | tr  -s ' '  | cut -d' ' -f2 | tr -d ' ')  
	if netstat -tupln 2>/dev/null | grep ":${port} ">/dev/null                                                                                                    
	then                                                                                                                                                          
		$wls_domain/bin/stopComponent.sh ${ohs_instance} >/dev/null 2>&1 &
	else                                                                                                                                                          
        	echo "there is not exist any process listen to port ${port}"                                                                                                                            
	fi                                                                                                                                                            
}

start_all(){
	echo
	echo "=== start all ==="
	echo 
	
	echo ">>> start node manager"
	start_nm
	
	echo
	
	echo ">>> start ohs"
	start_ohs

	echo 
	
	echo ">>> start admin server"
	start_admin
	
	echo
	echo ">>> start all managed server"
	for name in $(cat ${wls_domain}/config/config.xml | grep "<name>" | grep "${wls_ms_prefix}" | tr -d " " | uniq )                                                                                               
	do                                                                                                                                                                                         
        	ms=$(echo $name | tr -d '[:space:]' | cut -d'<' -f2 | cut -d'>' -f2)                                                                                                               
        	if ps aux 2>/dev/null | grep java | grep "${ms} " > /dev/null                                                                                                                       
	        then                                                                                                                                                                               
			echo "server(${ms}) --> UP"
	        else                                                                                                                                                                               
			start_ms ${ms}
	        fi                                                                                                                                                                                 
	done                                                                                                                                                                                       
	
}

stop_all(){
	echo                                                                                           
	echo "=== stop all ==="                                                                       
	echo                                                                                           
                                                                                               
                                                                                               
	echo ">>> stop ohs"                                                                           
	stop_ohs                                                                                      
                                                                                               
	echo                                                                                           
                                                                                               
	echo ">>> sopt admin server"                                                                  
	stop_ms $admin_server_name                                                                           
                                                                                               
	echo                                                                                           
	echo ">>> stop all managed server"                                                             
	for name in $(cat ${wls_domain}/config/config.xml | grep "<name>" | grep "${wls_ms_prefix}" | tr -d " " | uniq)   
	do                                                                                             
        	ms=$(echo $name | tr -d '[:space:]' | cut -d'<' -f2 | cut -d'>' -f2)                   
	        if ps aux 2>/dev/null | grep java | grep "${ms} " > /dev/null                           
        	then                                                                                   
                	stop_ms ${ms}                                                  
	        fi                                                                                     
	done                                                                                           
	

	#echo ">>> stop node manager"
        #stop_nm 
        
}

status(){
	pad=$(printf '%0.1s' " "{1..120})
	echo
	echo
	date=`date`
	host=`hostname`
	echo "${date}${pad}${host}"
	echo
	echo
	
	format_ms "name" "type" "status" "process id" "up time" "listen ports"
	
	check_nm
	status_as
	status_ms
	status_ohs

	echo
	echo
	
}


case "$1" in 
	status)
		status
		;;
	start_nm)
		start_nm
		;;
	stop_nm)
		stop_nm
		;;
	start_ms)
		start_ms $2
		;;
	stop_ms)
		stop_ms $2
		;;
	start_admin)
		start_admin
		;;
	stop_admin)
		stop_admin
		;;
	start_ohs)
		start_ohs
		;;
	stop_ohs)
		stop_ohs
		;;
	start_all)
		start_all
		;;
	stop_all)
		stop_all
		;;
	start)
		start_all
		;;
	stop)
		stop_all
		;;
	monitor)
		while :; do clear; status; sleep ${2:-3}; done
		;;
	*)
		echo "$0 {status|start_nm|stop_nm|start_ms server_name|stop_ms server_name|start_admin|stop_admin|start_ohs|stop_ohs|monitor|stop_all|start_all}"
		;;
esac	

# LogstashCustomDockerImage
Create custom and flexible docker image for logstash

"logstash" file at lines 17-22 using linux shell scripting to read environment variable and set it in files.

In docker environment passing parameter using "-e" at docker run  command (create container) 

at docker images OS(operation system) as environment variables.

``` shell script
for env_name in $(export | cut -d' ' -f3 | cut -d'=' -f1)
do
	env_value=$(sh -c "echo \$$env_name");
	
	sed -i 's+${'"$env_name"'}+'"$env_value"'+g' /usr/share/logstash/config/jvm.options
	
	sed -i 's+${'"$env_name"'}+'"$env_value"'+g' /usr/share/logstash/config/logstash.yml
	
done
```

For simplicity, Read environment variables and grouping them into  name and value paires. 

Then replace two configuration files (jvm.option and logstash.yml).

This solution help to pass configuration with environment variables instead of mounting configuration files.

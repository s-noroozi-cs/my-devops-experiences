# batch-jdbc-output-logstash-plugin

Logstash is very flexible tool to define pipeline to manage huge , complex and unstructured event logs.

Logstash have predefined and fantastic plugins that help to do any kind of tasks with your event logs. Also all or most of them are free.

Logstash plugins classified in different categories to help to do any kind of tasks perfectly.

Categories of Logstash plugins likes **unix/linux** commands. They do only one duty at any time, but do it **perfectly**.

Combining logstash plugins is very like as artists works. **I enjoy it very much.**

Most of Logstash plugins design , develop and maintain by Elastic company.

But maybe some of Logstash plugins that developed by companies or individual persons are not standard. 

So maybe does not support critical and important features such as **disaster-recovery or batch-works.**

Logstash has not standard output plugin for database.  

But, There is one plugin that do it very good (jdbc-output-plugin), But did not support batch-tasks and disaster-recovery. 

I googled and found ruby code that add batch mode to jdbc-output plugin. 

I tried to define "Docker image" that extended Logstash base image with jdbc output plugin, also supported **batch mode** too.

I keeped all this useful information and experiences (that gathered from different locations) together in one place.

**I will hope to add a feature that it support disaster-recovery.**

I am so happy, because found simple solution for **Disaster-Recovery**.  

Three months ago, I defined **Disaster-Recovery** issue and now I reach to my wish. I have full time job and unfortunatly I am lazy person :).

I improved event logging of this plugin to log JDBC error. 

My solution for **Disaster-Recovery** is very simple. I used log4j library for event logging. I added new appender that use only for disaster-recovery.

This **Log-Appender** writes event logs in file. I changed JDBC output plugin to handle **Error, Retry and Disaster-Recovery** issues. 

When plugin saw JDBC error (Such as connection error, unique constraint and etc), it check SQL Error State of JDBC driver. 

Then, Plugin will compare it with pre-defined **SQL State** list. This list help to We determine if I should be retry our SQL statments or not. 

For example in following list, I showed **SQL States** that We should be retry our actions against them (because maybe have chance to success).

		1.  SQL State **08**: Connection Exception
		2.  SQL State **53**: Insufficient Resources
		3.  SQL State **40**: Transaction Rollback
		4.  ...
		
When retry operations was failed or the error or exception showed our retry will not any effect, Then will add these events for future processing to file.

The file system has more reliability and availability in disaster. We chose it, because It provides more luck to keep our event logs when our database or network will not be available for any reasons.
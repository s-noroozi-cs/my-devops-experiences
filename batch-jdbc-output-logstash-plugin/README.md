# batch-jdbc--output-logstash-plugin

Logstash is very flexible tool to define pipeline to manage huge complex unstructured event logs.

Logstash have imbedded fantastic and completed plugins that help to do any kind of tasks with event logs.

Logstsh organized plugins in different category that help to do any kind of tasks perfectly.

Categories of Logstash plugins like **unix/linux** commands that do only one duty but doing it **perfectly**.

Combine logstash plugins together like an art. **I enjoy it very much.**

Most of Logstash plugins designed , developed and maintained by Elastic company.

But some of Logstash is not standard does not support standard featured such as **failover or batch.**

Logstash has not standard output plugin for database.  

But there is one plugin that doing it good (database output plugin) but did not support batch and failover. 

I googled and found ruby code that add batch mode to jdbc-output plugin. 

I try to define Docker image that extend Logstash base image to support jdbc output plugin that **support batch mode** .

I **just** keep all this information or experiences that take from different places together in one place.

**I will hope to add feature to support failover.**
  
   

FROM logstash:7.17.8

RUN /usr/share/logstash/bin/logstash-plugin install logstash-output-jdbc

ADD ojdbc8-19.3.0.0.jar /usr/share/logstash/vendor/jar/jdbc/ojdbc.jar
ADD jdbc.rb /usr/share/logstash/vendor/bundle/jruby/2.5.0/gems/logstash-output-jdbc-5.4.0/lib/logstash/outputs/jdbc.rb
ADD log4j2.properties /usr/share/logstash/config/log4j2.properties

entrypoint /usr/share/logstash/bin/logstash -f /usr/share/logstash/pipeline/logstash.conf

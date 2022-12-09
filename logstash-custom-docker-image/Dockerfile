FROM logstash:7.17.8

ADD jvm.options /usr/share/logstash/config/jvm.options
ADD logstash.yml /usr/share/logstash/config/logstash.yml
ADD logstash /usr/share/logstash/bin/logstash

ENV JVM_MIN_HEAP_SIZE=2G
ENV JVM_MAX_HEAP_SIZE=8G
ENV BATCH_SIZE=1000
ENV BATCH_DELAY=1000
ENV WORKERS=8
ENV LOG_LEVEL=info

entrypoint /usr/share/logstash/bin/logstash -f /usr/share/logstash/pipeline/logstash.conf
